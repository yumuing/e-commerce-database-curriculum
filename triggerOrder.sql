create trigger TriOrderStatusInsert		--���붩��״̬��ʱִ��
on OrderStatus
for insert as
begin
	declare @OrderId int
	declare @OrderStatusCode int
	select @OrderId = OrderId, @OrderStatusCode = OrderStatusCode	-- ���ն�����ź�״̬�봫��
	from INSERTED		-- �� inserted ���ȡ��������

	IF (@OrderStatusCode = 0)
	begin
		declare @strOrderId varchar(20)
		set @strOrderId = STR(@OrderId)
		print '�����Ѵ����������ţ�' + @strOrderId
	end
end
drop trigger TriOrderStatusUpdate	
go
create trigger TriOrderStatusUpdate		--����״̬�����ʱִ��
on OrderStatus
for update as
begin
    declare @OrderId int
	declare @OrderStatusCode int
	select top 1 @OrderId = OrderId, @OrderStatusCode = OrderStatusCode	-- ���ն�����ź�״̬�봫��
	from INSERTED

	declare @ExpressNumber int
	declare @DeliveryTime smallDateTime
	set @DeliveryTime = CONVERT(varchar(10), GETDATE(),120)  -- ��ȡ��ǰϵͳ����
	declare @Freight smallmoney
	select @Freight = (ord.TotalAmount - ord.CommodityPrice)
	from ORDERINFORMATION ord
	where ord.OrderId = @OrderId	-- �����˷� = �ܽ��-��Ʒ���

	IF (@OrderStatusCode = 1)
	begin
		print '��ʼ��������'
		select @ExpressNumber = isnull(ExpressNumber,0)
		from lODISTICS

		IF @ExpressNumber != ''			--����ݵ��Ų�Ϊ�գ�����ԭ������+1
		begin
			set @ExpressNumber = @ExpressNumber + 1
		end

		ELSE							-- ��Ϊ�գ���ֵΪ0
		begin
			set @ExpressNumber = 0
		end

		insert into lODISTICS(ExpressNumber,DeliveryTime,ReceiptTime,Freight,LogisticsStatusCode)
		values (@ExpressNumber,@DeliveryTime,null,@Freight,null)

		update ORDERINFORMATION			 --�������Ŀ�ݵ��Ų��붩����Ϣ����
		set ExpressNumber = @ExpressNumber
		where OrderId = @OrderId

		declare @strExpressNumber varchar(20)
		set @strExpressNumber = STR(@ExpressNumber)

		print '��ݵ��Ѵ�������ݵ��ţ�' + @strExpressNumber
	end
end

go
create trigger TriLodisticsInsert	--������������ʱ
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

		declare @strOrderId varchar(20)		--����ת��
		set @strOrderId = STR(@OrderId)

		declare @strExpressNumber varchar(20)	--����ת��
		set @strExpressNumber = STR(@ExpressNumber)

		declare @strProductId varchar(20)		--����ת��
		set @strProductId = STR(@ProductId)


		print '�����ţ�'+@strOrderId+'������...'+' ��ݵ���Ϊ��'+@strExpressNumber

		update PRODUCTPROPERTIES		--��Ʒ��������
		set ProductSales = ProductSales + @TotalAmount
		where ProductId = @ProductId

		print '��Ʒ '+@strProductId+' �����Ѹ���'

		update WAREHOUSEINFO		--�ֿ������
		set ProductsNumber = ProductsNumber - @TotalAmount
		where ProductID = @ProductId

		print '�ֿ���Ʒ '+@strProductId+' ����Ѹ���'

	end
end
drop trigger TriLodisticsUpdate
go
create trigger TriLodisticsUpdate --�����������ʱ
on LODISTICS
for update as
begin
	declare @OrderId int
	declare @ExpressNumber int
	declare @ReceiptTime smalldatetime
	set @ReceiptTime = CONVERT(varchar(10), GETDATE(),120)  --��ȡ��ǰϵͳ����
	declare @LogisticsStatusCode int
	
	select @OrderId = ord.OrderId, @ExpressNumber = ins.ExpressNumber, @LogisticsStatusCode = lod.LogisticsStatusCode
	from INSERTED ins, ORDERINFORMATION ord, lODISTICS lod
	where ins.ExpressNumber = lod.ExpressNumber and lod.ExpressNumber = ord.ExpressNumber

	IF (@LogisticsStatusCode = 0)
	begin
		update lODISTICS
		set LogisticsStatusCode = 1
		where ExpressNumber = @ExpressNumber

		print '����������'
	end

	ELSE IF (@LogisticsStatusCode = 2)
	begin
		update lODISTICS
		set ReceiptTime = @ReceiptTime
		where ExpressNumber = @ExpressNumber

		declare @strOrderId varchar(20)		--����ת��

		update ORDERSTATUS
		set OrderStatusCode = 2
		where OrderId = @OrderId

		set @strOrderId = STR(@OrderId)
		print '������Ϊ '+@strOrderId+' ����Ʒ��ȷ���ջ�'
	end
end