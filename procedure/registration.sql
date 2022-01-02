--用户注册存储过程
use ECMANAGE
go
create procedure UserRegistrate
@userName varchar(15),
@userPassword varchar(15),
@phoneNumber varchar(11)
as
begin
	if(@userName is not null and @userPassword is not null and @phoneNumber is not null)
	begin
		insert into USERS
			values(@userName,@userPassword)
		declare @ID nvarchar(10)
		set @ID = SCOPE_IDENTITY()
	    insert into USERINFO
			values(CONVERT(int,@ID),'离线',CONVERT(varchar,GETDATE(),120),@phoneNumber)
		declare @sql1 nvarchar(500)
		declare @sql2 nvarchar(500)
		set @ID = IDENT_CURRENT('USERS')
		--信息已全，视图不为空
		set @sql1 = '
			CREATE VIEW USER'+@ID+'VIEW
			as 
			select distinct(A.userId),A.UserName,A.UserPassword,B.Consignee,C.PhoneNumber,B.AddressId,B.Province,B.City,B.Area,B.DetailedAddress,C.RegistrationTime
			from USERS A,SHIPPINGADDRESS B,USERINFO C
			where A.userId=C.UserId and B.UserId= A.userId and A.userId='+@ID
		--未创建订单，视图为空
		set @sql2 = '
			CREATE VIEW USER'+@ID+'ORDERVIEW
			as
			select E.UserId,A.UserName,E.OrderId,E.CreationTime,E.Payment,K.CompanyId,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
			from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,LODISTICS F,COMPANY K
			where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND E.CompanyId=K.CompanyId AND A.userId=5058'+ @ID
		Exec SP_ExecuteSQL @sql1
		Exec SP_ExecuteSQL @sql2
	end
end
go

--调用用户注册
execute  UserRegistrate 'yyy47','123456789',13345667890

--商家注册存储过程
use ECMANAGE
go
create procedure CompanyRegistrate
@companyName varchar(20),
@companyDescription char(50)
as
begin
	declare @sql1 nvarchar(max)
	declare @sql2 nvarchar(max)
	declare @sql3 nvarchar(max)
	declare @ID nvarchar(10)
	if @companyName is not null and @companyDescription is not null and IDENT_CURRENT('COMPANY') is not null 
	begin
		set @ID = IDENT_CURRENT('COMPANY')+1
		insert into COMPANY 
		values(CONVERT(int,@ID),@companyName,@companyDescription)
	end
	else
	begin
		declare @count int
		select @count = count(*)
		from COMPANY 
		set @ID = @count+1
		insert into COMPANY 
			values(CONVERT(int,@ID),@companyName,@companyDescription)
	end
	--未增加信息，视图为空
	set @sql1 = '
		CREATE VIEW MERCHANT'+@ID+'VIEW
		as 
		select K.CompanyId,K.CompanyName,K.CompanyDescription,I.ProductsNumber,J.WarehouseID,J.WarehouseAddressId,J.Province,J.City,J.Area,J.DetailedAddress
		from COMPANY K,COMPANY_WAREHOUSEINFO L,WAREHOUSEINFO I,WAREHOUSEADDRESS J
		where L.CompanyID=K.CompanyId AND L.WarehouseID=I.WarehouseID AND I.WarehouseID=J.WarehouseID AND K.CompanyId='+@ID
	set @sql2 = '
		CREATE VIEW	MERCHANT'+@ID+'SHOPINGVIEW
		as
		select K.CompanyId,K.CompanyName,D.ProductName,D.Specifications,D.ProductSales,D.Brands,D.ProductPrice,M.DateIssuedTime
		from COMPANY_PRODUCTPROPERTIES M,COMPANY K,PRODUCTPROPERTIES D
		where M.CompanyID=K.CompanyId AND M.ProductId=D.ProductId AND K.CompanyId='+@ID
	set @sql3 = '
		CREATE VIEW MERCHANT'+@ID+'ORDERVIEW
		as
		select K.CompanyId,K.CompanyName,I.WarehouseID,E.UserId,E.OrderId,H.Consignee,H.UserPhone,H.AddressId,E.CreationTime,E.Payment,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
		from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K,RECEIVEINFO H,SHIPPINGADDRESS B,WAREHOUSEADDRESS J,WAREHOUSEINFO I
		where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND I.ProductID=D.ProductId AND E.CompanyId=K.CompanyId AND H.OrderId=E.OrderId AND I.WarehouseID=J.WarehouseID AND H.AddressId=B.AddressId AND K.CompanyId='+@ID
	print(2)
	print @sql3
	Exec SP_ExecuteSQL @sql1
	Exec SP_ExecuteSQL @sql2
	Exec SP_ExecuteSQL @sql3
end
go

--调用商家注册
execute CompanyRegistrate 'iuchiwdc','duhwuidhwd'
