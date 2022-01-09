1.������ѯ
����������������
��������������ţ�����״̬���µ�ʱ�䣬��Ʒ��ţ���Ʒ��������Ʒ���ܽ��
�ж���������Ƿ��������
�������������ѯ������Ϣ��Ͷ���״̬���еĶ�����š�����״̬���µ�ʱ�䡢��Ʒ��š���Ʒ��������Ʒ���ܽ�
��ʾ��Ӧ������ŵ�����	
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
		PRINT('������Ų�����')
	END
END
DROP PROCEDURE proOrderInquire
EXECUTE  proOrderInquire '11111111'

2.��������
����������û�id����Ʒ��ţ���������,�̼ұ��
����������������
�ж���������������ڲֿ����Ʒ������print�����ֿ��治�㣬�뼰ʱ���䡯�������²ֿ���Ʒ��������ԭ�л���+��������
�������=������ű�����󶩵����+1
��Ʒ���=��Ʒ�۸�*��������
�ܽ��=��Ʒ���(���津����������˷�)
����insert��佫��Ϣ���붩����ϢE���С�
��Ӷ�����ŵ�����״̬G���У�����״̬���ʼ״̬��0.����������δ֧����
��ݵ��ų�ʼ״̬Ϊ��
������ִ��
CREATE PROCEDURE proOrderCreate(@CompanyId int,@userId int,@ProductId int,@Quantity int)
AS
BEGIN
	IF(@Quantity>(SELECT ProductsNumber FROM WAREHOUSEINFO WHERE ProductID=@ProductId))
	BEGIN
		print('�ֿ��治�㣬�뼰ʱ����')
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
	print('���������ɹ�')
END

EXECUTE proOrderCreate 1,1,1,12
SELECT * FROM ORDERINFORMATION
SELECT * FROM ORDERSTATUS


3.����ɾ��
����������������
���������null
������ʱ������@�û�id��@��Ʒ��ţ�@��������,@��ݵ��ţ�@����״̬��
������ֹͣ
��ѯ����״̬G��
����״̬�� 	0����������;1:������֧����2�����������			
�������״̬��==0ʱ
���ݶ�����ż���ɾ������״̬G��Ͷ�����ϢE�����Ԫ�顣
�������״̬��==1ʱ
1ͨ��������ŷ��ʶ�����ϢE����ȡ���ݡ�
2.������Ʒ��Ÿ��²ֿ���Ϣ���ع�������δ����ʱ�Ĳֿ���Ʒ������
3.���ݿ�ݵ���������F��ɾ�����Ԫ�顣
4.�����û�id�Ͷ������ɾ���ջ���ϢH�����Ԫ��
5.���ݶ�����ż���ɾ������״̬G��Ͷ�����ϢE�����Ԫ��
�������״̬��==2ʱ
Print('��������ɣ��޷�ɾ��')

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
		PRINT('��������ɣ��޷�ɾ��')
	END
END
			
EXECUTE proOrderDrop '55555556'
SELECT * FROM ORDERINFORMATION
SELECT * FROM ORDERSTATUS

