create trigger TriOrderStatusInsert		--插入订单状态表时执行
on OrderStatus
for insert as
begin
	declare @OrderId int
	declare @OrderStatusCode int
	select @OrderId = OrderId, @OrderStatusCode = OrderStatusCode	-- 接收订单编号和状态码传参
	from INSERTED		-- 从 inserted 表获取最新数据

	IF (@OrderStatusCode = 0)
	begin
		declare @strOrderId varchar(20)
		set @strOrderId = STR(@OrderId)
		print '订单已创建，订单号：' + @strOrderId
	end
end
drop trigger TriOrderStatusUpdate	
go
create trigger TriOrderStatusUpdate		--订单状态表更新时执行
on OrderStatus
for update as
begin
    declare @OrderId int
	declare @OrderStatusCode int
	select top 1 @OrderId = OrderId, @OrderStatusCode = OrderStatusCode	-- 接收订单编号和状态码传参
	from INSERTED

	declare @ExpressNumber int
	declare @DeliveryTime smallDateTime
	set @DeliveryTime = CONVERT(varchar(10), GETDATE(),120)  -- 获取当前系统日期
	declare @Freight smallmoney
	select @Freight = (ord.TotalAmount - ord.CommodityPrice)
	from ORDERINFORMATION ord
	where ord.OrderId = @OrderId	-- 计算运费 = 总金额-商品金额

	IF (@OrderStatusCode = 1)
	begin
		print '开始创建物流'
		select @ExpressNumber = isnull(ExpressNumber,0)
		from lODISTICS

		IF @ExpressNumber != ''			--若快递单号不为空，则在原基础上+1
		begin
			set @ExpressNumber = @ExpressNumber + 1
		end

		ELSE							-- 若为空，则赋值为0
		begin
			set @ExpressNumber = 0
		end

		insert into lODISTICS(ExpressNumber,DeliveryTime,ReceiptTime,Freight,LogisticsStatusCode)
		values (@ExpressNumber,@DeliveryTime,null,@Freight,null)

		update ORDERINFORMATION			 --将创建的快递单号插入订单信息表中
		set ExpressNumber = @ExpressNumber
		where OrderId = @OrderId

		declare @strExpressNumber varchar(20)
		set @strExpressNumber = STR(@ExpressNumber)

		print '快递单已创建，快递单号：' + @strExpressNumber
	end
end

go
create trigger TriLodisticsInsert	--当插入物流表时
on LODISTICS
for insert as
begin
	declare @ExpressNumber int
	declare @OrderId int
	declare @LogisticsStatusCode int
	declare @ProductId int
	declare @TotalAmount int
	

	select @ExpressNumber = ins.ExpressNumber,@OrderId = OrderId, @LogisticsStatusCode = ins.LogisticsStatusCode, @ProductId = ord.ProductId, @TotalAmount = ord.TotalAmount
	from INSERTED ins, ORDERINFORMATION ord, lODISTICS lod
	where ins.ExpressNumber = lod.ExpressNumber and lod.ExpressNumber = ord.ExpressNumber
	 
	IF ( @LogisticsStatusCode = 0)
	begin
		set @LogisticsStatusCode = 1
		update lODISTICS
		set LogisticsStatusCode = @LogisticsStatusCode
		where ExpressNumber = @ExpressNumber

		declare @strOrderId varchar(20)		--类型转换
		set @strOrderId = STR(@OrderId)

		declare @strExpressNumber varchar(20)	--类型转换
		set @strExpressNumber = STR(@ExpressNumber)

		declare @strProductId varchar(20)		--类型转换
		set @strProductId = STR(@ProductId)


		print '订单号：'+@strOrderId+'配送中...'+' 快递单号为：'+@strExpressNumber

		update PRODUCTPROPERTIES		--商品销量增加
		set ProductSales = ProductSales + @TotalAmount
		where ProductId = @ProductId

		print '商品 '+@strProductId+' 销量已更新'

		update WAREHOUSEINFO		--仓库库存减少
		set ProductsNumber = ProductsNumber - @TotalAmount
		where ProductID = @ProductId

		print '仓库商品 '+@strProductId+' 库存已更新'

	end
end
drop trigger TriLodisticsUpdate
go
create trigger TriLodisticsUpdate --当物流表更新时
on LODISTICS
for update as
begin
	declare @OrderId int
	declare @ExpressNumber int
	declare @ReceiptTime smalldatetime
	set @ReceiptTime = CONVERT(varchar(10), GETDATE(),120)  --获取当前系统日期
	declare @LogisticsStatusCode int
	
	select @OrderId = ord.OrderId, @ExpressNumber = ins.ExpressNumber, @LogisticsStatusCode = lod.LogisticsStatusCode
	from INSERTED ins, ORDERINFORMATION ord, lODISTICS lod
	where ins.ExpressNumber = lod.ExpressNumber and lod.ExpressNumber = ord.ExpressNumber

	IF (@LogisticsStatusCode = 0)
	begin
		update lODISTICS
		set LogisticsStatusCode = 1
		where ExpressNumber = @ExpressNumber

		print '订单配送中'
	end

	ELSE IF (@LogisticsStatusCode = 2)
	begin
		update lODISTICS
		set ReceiptTime = @ReceiptTime
		where ExpressNumber = @ExpressNumber

		declare @strOrderId varchar(20)		--类型转换

		update ORDERSTATUS
		set OrderStatusCode = 2
		where OrderId = @OrderId

		set @strOrderId = STR(@OrderId)
		print '订单号为 '+@strOrderId+' 的商品已确认收货'
	end
end