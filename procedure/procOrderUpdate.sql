create proc proOrderPaymentUpdate(@OrderId int,@Payment int) --�û�֧��
as
begin
	IF ( @OrderId not in (select OrderId from ORDERINFORMATION) ) --�鿴�Ƿ��д˶���
	begin
		print '�˶��������ڣ���������Ķ�������Ƿ���ȷ��'
	end

	ELSE IF ( @Payment not in (0,1,2,3) ) --������������ʽ
	begin
		print '֧��״̬�������������������'
	end

	ELSE
	begin
		IF ( @Payment in (0,1,2) )
		begin
			update ORDERINFORMATION
			set Payment = @Payment
			where OrderId = @OrderId


			update ORDERSTATUS
			set OrderStatusCode = 1
			print '����ɹ�'
		end
	end
end

go
create proc proLogStatusUpdate (@OrderId int) --�̼ҷ���
as
begin
	declare @LogisticsStatusCode int
	set @LogisticsStatusCode = 0
	declare @ExpressNumber int
	declare @UserId int
	
	select @ExpressNumber = ord.ExpressNumber, @UserId = ord.UserId
	from ORDERINFORMATION ord
	where OrderId = @OrderId

	IF ( @OrderId not in (select OrderId from ORDERINFORMATION) ) --�鿴�Ƿ��д˶���
	begin
		print '�˶��������ڣ���������Ķ�������Ƿ���ȷ��'
	end

	ELSE
	begin
		update lODISTICS	--��������״̬��Ϊ0�����⣩
		set LogisticsStatusCode = @LogisticsStatusCode
		where ExpressNumber = @ExpressNumber
		
		declare @strOrderId varchar(20)		--����ת��
		set @strOrderId = STR(@OrderId)

		print '��Ʒ�ѳ��⣬������Ϊ��'+@strOrderId

		-- ���������ջ���Ϣ
		declare @Consignee char(6)
		declare @AddressId int
		declare @UserPhone varchar(11)
		declare @intUserPhone bigint
		select @Consignee = adr.Consignee, @AddressId = adr.AddressId,@UserPhone = uifo.PhoneNumber
		from SHIPPINGADDRESS adr, USERINFO uifo,RECEIVEINFO rec
		where adr.UserId = @UserId and adr.UserId = uifo.UserId and rec.UserId = adr.UserId

		set @intUserPhone = convert(bigint,@UserPhone)
		insert into RECEIVEINFO(Userid,OrderId,Consignee,AddressId,UserPhone)
		values(@UserId,@OrderId,@Consignee,@AddressId,@intUserPhone)

		print '�ջ���Ϣ�Ѹ���'
	end
end

go
create proc proLogAccomplish(@OrderId int) --���ջ����������
as
begin
	declare @LogisticsStatusCode int
	set @LogisticsStatusCode = 2

	IF ( @OrderId not in (select OrderId from ORDERINFORMATION) ) --�鿴�Ƿ��д˶���
	begin
		print '�˶��������ڣ���������Ķ�������Ƿ���ȷ��'
	end
	ELSE
	begin
		update lODISTICS
		set LogisticsStatusCode = @LogisticsStatusCode
		where ExpressNumber = (select ord.ExpressNumber from ORDERINFORMATION ord
							where OrderId = @OrderId)

		declare @strOrderId varchar(20)		--����ת��
		set @strOrderId = STR(@OrderId)

		

		print '������Ϊ��'+@strOrderId+' ����Ʒ��ǩ��'
	end
end


