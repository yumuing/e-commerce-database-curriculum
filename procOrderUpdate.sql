create proc proOrderPaymentUpdate(@OrderId int,@Payment int) --用户支付
as
begin
	IF ( @OrderId not in (select OrderId from ORDERINFORMATION) ) --查看是否有此订单
	begin
		print '此订单不存在，请检查输入的订单编号是否正确。'
	end

	ELSE IF ( @Payment not in (0,1,2,3) ) --检查输入参数格式
	begin
		print '支付状态码输入错误，请重新输入'
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
			print '购买成功'
		end
	end
end

go
create proc proLogStatusUpdate (@OrderId int) --商家发货
as
begin
	declare @LogisticsStatusCode int
	set @LogisticsStatusCode = 0
	declare @ExpressNumber int
	declare @UserId int
	
	select @ExpressNumber = ord.ExpressNumber, @UserId = ord.UserId
	from ORDERINFORMATION ord
	where OrderId = @OrderId

	IF ( @OrderId not in (select OrderId from ORDERINFORMATION) ) --查看是否有此订单
	begin
		print '此订单不存在，请检查输入的订单编号是否正确。'
	end

	ELSE
	begin
		update lODISTICS	--更新物流状态码为0（出库）
		set LogisticsStatusCode = @LogisticsStatusCode
		where ExpressNumber = @ExpressNumber
		
		declare @strOrderId varchar(20)		--类型转换
		set @strOrderId = STR(@OrderId)

		print '商品已出库，订单号为：'+@strOrderId

		-- 创建插入收货信息
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

		print '收货信息已更新'
	end
end

go
create proc proLogAccomplish(@OrderId int) --已收货，订单完成
as
begin
	declare @LogisticsStatusCode int
	set @LogisticsStatusCode = 2

	IF ( @OrderId not in (select OrderId from ORDERINFORMATION) ) --查看是否有此订单
	begin
		print '此订单不存在，请检查输入的订单编号是否正确。'
	end
	ELSE
	begin
		update lODISTICS
		set LogisticsStatusCode = @LogisticsStatusCode
		where ExpressNumber = (select ord.ExpressNumber from ORDERINFORMATION ord
							where OrderId = @OrderId)

		declare @strOrderId varchar(20)		--类型转换
		set @strOrderId = STR(@OrderId)

		

		print '订单号为：'+@strOrderId+' 的商品已签收'
	end
end


