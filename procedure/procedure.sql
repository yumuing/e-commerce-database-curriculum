1.订单查询
输入参数：订单编号
输出结果：订单编号，订单状态，下单时间，商品编号，商品数量，商品金额，总金额
判断输入参数是否符合条件
根据输入参数查询订单信息表和订单状态表中的订单编号、订单状态、下单时间、商品编号、商品数量、商品金额、总金额，
显示对应订单编号的内容	
CREATE PROCEDURE proOrderInquire(@OrderId int)
AS 
BEGIN
	if(@OrderId in (SELECT OrderId FROM ORDERINFORMATION))
	BEGIN
		SELECT a.OrderId,OrderStatusCode,CreationTime,ProductId,Quantity,CommodityPrice,TotalAmount
		FROM ORDERINFORMATION a,ORDERSTATUS b
		WHERE a.OrderId = @OrderId AND a.OrderId = b.OrderId
	END
	ELSE
	BEGIN
		PRINT('订单编号不存在')
	END
END
DROP PROCEDURE proOrderInquire
EXECUTE  proOrderInquire '11111111'

2.订单创建
传入参数：用户id，商品编号，购买数量,商家编号
输出参数：订单编号
判断如果购买数量大于仓库的商品数量，print（‘仓库库存不足，请及时补充’），更新仓库商品数量，在原有基础+购买数量
订单编号=订单编号表中最后订单编号+1
商品金额=商品价格*购买数量
总金额=商品金额(后面触发器会加上运费)
运用insert语句将信息插入订单信息E表中。
添加订单编号到订单状态G表中，订单状态码初始状态是0.订单创建（未支付）
快递单号初始状态为空
触发器执行
CREATE PROCEDURE proOrderCreate(@CompanyId int,@userId int,@ProductId int,@Quantity int)
AS
BEGIN
	IF(@Quantity>(SELECT ProductsNumber FROM WAREHOUSEINFO WHERE ProductID=@ProductId))
	BEGIN
		print('仓库库存不足，请及时补充')
		UPDATE WAREHOUSEINFO
		SET ProductsNumber = ProductsNumber + @Quantity
		WHERE ProductID=@ProductId
	END
	declare @CommodityPrice smallmoney,@CreationTime smalldatetime,@TotalAmount smallmoney,@OrderId INT
	declare @OrderStatusCode int
	set @OrderId = (SELECT TOP 1 OrderId FROM ORDERINFORMATION order by OrderId desc) + 1
	set @CreationTime = (select CONVERT(varchar(30),GETDATE(),120)+':' + DATENAME(MILLISECOND,GETDATE()))
	set @CommodityPrice = (select ProductPrice from PRODUCTPROPERTIES where ProductId=@ProductId)*@Quantity
	set @TotalAmount = @CommodityPrice + CAST(ceiling(rand()*40)as int)
	set @OrderStatusCode = 0
	insert into ORDERINFORMATION(OrderId,CreationTime,UserId,ProductId,CommodityPrice,TotalAmount,Quantity,CompanyId)
	values(@OrderId,@CreationTime,@userId,@ProductId,@CommodityPrice,@TotalAmount,@Quantity,@CompanyId)
	INSERT INTO ORDERSTATUS(OrderId,OrderStatusCode)
	VALUES(@OrderId,@OrderStatusCode)
	print('订单创建成功')
END

EXECUTE proOrderCreate 1,1,1,12
SELECT * FROM ORDERINFORMATION
SELECT * FROM ORDERSTATUS


3.订单删除
传入参数：订单编号
输出参数：null
声明临时变量：@用户id，@商品编号，@购买数量,@快递单号，@订单状态码
触发器停止
查询订单状态G表
订单状态码 	0：订单创建;1:订单已支付；2：订单已完成			
如果订单状态码==0时
根据订单编号级联删除订单状态G表和订单信息E表相关元组。
如果订单状态码==1时
1通过订单编号访问订单信息E表，获取数据。
2.根据商品编号更新仓库信息表，回滚到订单未创建时的仓库商品数量。
3.根据快递单号在物流F表删除相关元组。
4.根据用户id和订单编号删除收货信息H的相关元组
5.根据订单编号级联删除订单状态G表和订单信息E表相关元组
如果订单状态码==2时
Print('交易已完成，无法删除')

CREATE PROCEDURE proOrderDrop(@OrderId int)
AS
BEGIN
	DECLARE @OrderStatusCode int,@Quantity int,@ExpressNumber int,@userId int,@ProductId int 
	SET @Quantity = (select Quantity from ORDERINFORMATION where OrderId = @OrderId)
	SET @ExpressNumber = (select ExpressNumber from ORDERINFORMATION where OrderId = @OrderId)
	SET @userId = (select userId from ORDERINFORMATION where OrderId = @OrderId)
	SET @ProductId = (select ProductId from ORDERINFORMATION where OrderId = @OrderId)
	SET @OrderStatusCode = (select orderstatuscode from ORDERSTATUS where OrderId = @OrderId)
	IF(@OrderStatusCode=0)
	BEGIN	
		DELETE FROM ORDERSTATUS
		WHERE OrderId = @OrderId 
		DELETE FROM ORDERINFORMATION
		WHERE OrderId = @OrderId 
	END
	IF(@OrderStatusCode=1)
	BEGIN
		UPDATE WAREHOUSEINFO
		SET ProductsNumber = ProductsNumber + @Quantity
		WHERE ProductID=@ProductId
		DELETE FROM lODISTICS
		WHERE ExpressNumber = @ExpressNumber
		DELETE FROM RECEIVEINFO
		WHERE OrderId = @OrderId and UserId = @userId
		DELETE FROM ORDERSTATUS
		WHERE OrderId = @OrderId 
		DELETE FROM ORDERINFORMATION
		WHERE OrderId = @OrderId
	END
	IF(@OrderStatusCode=2)
	BEGIN	
		PRINT('交易已完成，无法删除')
	END
END
			
EXECUTE proOrderDrop '55555556'
SELECT * FROM ORDERINFORMATION
SELECT * FROM ORDERSTATUS

