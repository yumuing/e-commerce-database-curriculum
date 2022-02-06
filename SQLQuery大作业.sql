create database ECMANAGE
on
   (name='ECMANAGE',
    filename='D:\ECMANAGE\ECMANAGE.mdf',
    size=5,
    maxsize=100,
    filegrowth=5%)
log on
   (name='ECManagelog',
    filename='D:\ECMANAGE\ECMANAGELOG.ldf',
    size=1,
    maxsize=10,
    filegrowth=10
)
--A用户表
use ECMANAGE
go
CREATE TABLE USERS(  
    userId    INT  NOT NULL identity(1,1),
    UserName  VARCHAR(15) NOT NULL,
    UserPassword    VARCHAR(15) NOT NULL,
    CONSTRAINT userid_pk PRIMARY KEY (userid),
    CONSTRAINT username_ck UNIQUE(username),--检查用户名不重复
    CONSTRAINT usepassword CHECK (LEN(userpassword)>6)--检查密码大于6位数
)
go
insert into USERS values('wang','1233456')
insert into USERS values('lin','13456333')
insert into USERS values('fang','1345633')
insert into USERS values('ma','1345633233')
insert into USERS values('luo','132233233')--插入数据不用输入ID，系统会自己给。而且删掉数据后新增的ID继续加上去的！
select * from users

--B收货地址
use ECMANAGE
go
CREATE TABLE SHIPPINGADDRESS(  
    AddressId   varchar(20)  NOT NULL ,
	Consignee  varchar(6)  not null,
	Province   varchar(20)  NOT NULL ,
	City   varchar(20)  NOT NULL ,
	Area   varchar(20)  NOT NULL ,
    DetailedAddress  VARCHAR(50) NOT NULL,
	UserId  int  NOT NULL
    CONSTRAINT addressid_pk PRIMARY KEY (AddressId)
	foreign key(UserId) references USERS(UserId)
)
go
insert into SHIPPINGADDRESS values('551243','小明','广东','广州','花都','广东第二师范','1')
insert into SHIPPINGADDRESS values('553490','小红','广西','南宁','桂林','山水','2')
insert into SHIPPINGADDRESS values('573811','小方','江西','芜湖','起飞','111111','3')
insert into SHIPPINGADDRESS values('515200','小罗','湖南','衡阳','衡南','岐山','4')
insert into SHIPPINGADDRESS values('578943','小李','湖北','武汉','洪山','东湖新技术开发区','5')
select *from SHIPPINGADDRESS
--C用户信息
use ECMANAGE
go
CREATE TABLE USERINFO(  
    UserId  int  NOT NULL ,
	UserStatus   varchar(20)  NOT NULL ,
	RegistrationTime   smalldatetime  NOT NULL ,
	PhoneNumber   varchar(11)  NOT NULL ,
	foreign key(UserId) references USERS(UserId),
	CONSTRAINT phonenumber_ck check (len(PhoneNumber)=11 and PhoneNumber like'[1][35678][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--检查手机号格式
)
go
insert into USERINFO values('1','在线','1998-01-01 23:59','13580214940')
insert into USERINFO values('2','离线','1998-01-01 23:59','16580214940')
insert into USERINFO values('3','在线','1998-01-01 23:29','13580214940')--C表添加数据必须先添加A表和B表的数据，且ID必须相同
insert into USERINFO values('4','离线','2021-04-21 3:29','13582924940')
insert into USERINFO values('5','在线','2020-02-16 5:29','13522346140')
select *from USERINFO

--k商家信息
use ECMANAGE
go
CREATE TABLE COMPANY(  
	CompanyId   int,
	CompanyName		varchar(20) not null,	
	CompanyDescription char(50) not null,
    CONSTRAINT companyid_pk PRIMARY KEY (CompanyId),
)
go
insert into COMPANY values('1','华为','商家描述')
insert into COMPANY values('2','小米','商家描述')
insert into COMPANY values('3','松下','商家描述')
insert into COMPANY values('4','雷蛇','商家描述')
insert into COMPANY values('5','联想','商家描述')
select *from COMPANY

--D商品属性
use ECMANAGE
go
CREATE TABLE PRODUCTPROPERTIES(  
    ProductId   int  NOT NULL ,
	ProductName   varchar(20)  NOT NULL ,
	Specifications   varchar(20) NULL ,
	ProductSales  int  default(0),
    Brands  VARCHAR(20) NOT NULL,
	ProductPrice float default(0),
	CompanyId int,
    CONSTRAINT  productid_pk PRIMARY KEY ( ProductId),
	foreign key(CompanyId) references COMPANY(CompanyId),--商家ID依赖K表
	CONSTRAINT productprice_ck check (ProductPrice>0)--检查价格大于0
)
insert into PRODUCTPROPERTIES values('1','电脑','80*60','233','森下','8848','1')
insert into PRODUCTPROPERTIES values('2','手机','20*10','12343','华为','1999','2')
insert into PRODUCTPROPERTIES values('3','吹风机','20','2683','大风车','1999','3')
insert into PRODUCTPROPERTIES values('4','鼠标','43','664','华硕','23','4')
insert into PRODUCTPROPERTIES values('5','显示器','120*140','263','极光','668','5')
select * from PRODUCTPROPERTIES

--I仓库信息
use ECMANAGE
go
CREATE TABLE WAREHOUSEINFO(
	WarehouseID	  int,
	ProductID int not null UNIQUE,
	ProductsNumber int default(0) ,
	CompanyId int not null,
	CONSTRAINT warehouseid_pk PRIMARY KEY (WarehouseID,ProductID),
	foreign key(CompanyId) references Company(CompanyId),--商家ID依赖k表
	foreign key(ProductID) references PRODUCTPROPERTIES(ProductID),--商品编号依赖D表
	constraint productsnumber_ck check (ProductsNumber>0)--检查商品数量大于等于0
)

go
insert into WAREHOUSEINFO values('1','1','35','1')
insert into WAREHOUSEINFO values('2','2','56','2')
insert into WAREHOUSEINFO values('3','5','345','3')
insert into WAREHOUSEINFO values('4','3','725','4')
insert into WAREHOUSEINFO values('5','4','116','5')
select * from WAREHOUSEINFO

--J仓库地址
use ECMANAGE
go
CREATE TABLE WAREHOUSEADDRESS(  
    WarehouseAddressId   int  NOT NULL ,
	ProductID int not null,
	Province   varchar(20)  NOT NULL ,
	City   varchar(20)  NOT NULL ,
	Area   varchar(20)  NOT NULL ,
    DetailedAddress  VARCHAR(50) NOT NULL,
	WarehouseID  int NOT NULL,
    CONSTRAINT warehouseaddressid_pk PRIMARY KEY (WarehouseAddressId),
	foreign key(WarehouseID,ProductID) references WAREHOUSEINFO(WarehouseID,ProductID)
)
go
insert into WAREHOUSEADDRESS values('53333','1','广东','广州','花都','行政学院','1')
insert into WAREHOUSEADDRESS values('3333','2','广东','揭阳','惠来','隆江镇','2')
insert into WAREHOUSEADDRESS values('517781','5','贵州','贵阳','驿埔','苗海镇','3')
insert into WAREHOUSEADDRESS values('73513','3','河北','保定','涞水','九龙镇','4')
insert into WAREHOUSEADDRESS values('6421','4','吉林','四平','伊通','伊莱镇','5')
select *from WAREHOUSEADDRESS

--F物流
use ECMANAGE
go
CREATE TABLE lODISTICS(  
    ExpressNumber    INT  NOT NULL ,
    DeliveryTime  smallDateTime NOT NULL,
    ReceiptTime    smallDateTime   NULL,
	Freight    smallmoney NOT NULL,
	LogisticsStatusCode  int default(3),
    CONSTRAINT expressnumber_pk PRIMARY KEY (ExpressNumber),
    CONSTRAINT logisticsstatuscode_ck CHECK (LogisticsStatusCode like'[0123]'),--检查物流状态码是否在0123 中
)
go
insert into lODISTICS values('123456789','2021-12-01 13:59','2021-12-05 23:59','34','1')
insert into lODISTICS values('1135792468','2020-10-01 2:59','2020-11-01 23:59','10','2')
insert into lODISTICS values('657817661','2020-05-01 2:59','2020-05-01 23:59','37','1')
insert into lODISTICS values('765728292','2020-06-01 5:59','2020-12-01 23:59','20','3')
insert into lODISTICS values('426768292','2020-07-01 7:59','2020-11-01 23:59','133','2')
select * from lODISTICS


--E订单信息
use ECMANAGE
go
CREATE TABLE ORDERINFORMATION(  
    OrderId  int  NOT NULL ,
	CreationTime   smalldatetime  NOT NULL ,
	Payment    int NULL ,
	UserId   int  NOT NULL ,
    ProductId  int NOT NULL,
	CommodityPrice  smallmoney  NOT NULL ,
	TotalAmount  smallmoney  NOT NULL ,
	ExpressNumber  int  NULL ,
	Quantity  int  NOT NULL ,
	CompanyId int ,
	CONSTRAINT orderid_pk PRIMARY KEY (OrderId),
	foreign key(UserId) references Users(UserId),--用户ID依赖A表
	foreign key(ProductId) references PRODUCTPROPERTIES(ProductId),--商品编号依赖D表
	foreign key(ExpressNumber) references lODISTICS(ExpressNumber),--快递单号依赖F表
	foreign key(CompanyId) references COMPANY(CompanyId),
	constraint expressnumber_fk foreign key (ExpressNumber) references lODISTICS(ExpressNumber) on delete cascade on update cascade,--快递单号级联F表
	CONSTRAINT payment_ck CHECK (Payment like'[0123]'),--检查支付方式码是否在0123中
	CONSTRAINT commodityprice_ck CHECK (CommodityPrice>0),--检查大于0
	CONSTRAINT totalamount_ck CHECK (TotalAmount>0),--检查大于0
	CONSTRAINT quantity_ck CHECK (Quantity>0),--检查大于0
)
go
insert into ORDERINFORMATION values('11111111','2021-11-02 23:59','1','2','2','8848','12888','123456789','6','1')
insert into ORDERINFORMATION values('22222222','2021-11-01 23:59','3','3','1','76','888','1135792468','23','2')
insert into ORDERINFORMATION values('33333333','2020-05-04 23:59','2','1','4','199','1348','657817661','263','3')
insert into ORDERINFORMATION values('44444444','2020-04-18 23:59','2','5','2','299','2456','765728292','2343','4')
insert into ORDERINFORMATION values('55555555','2021-07-27 23:59','2','4','5','648','1345','426768292','293','5')
insert into ORDERINFORMATION values('66666666','2021-07-27 23:59','3','4','5','648','1345','426768292','293','5')
select * from ORDERINFORMATION
delete from ORDERINFORMATION where(OrderId='66666666')
--G订单状态
use ECMANAGE
go
CREATE TABLE ORDERSTATUS(  
    OrderId   INT  NOT NULL ,
	OrderStatusCode   INT  default(0),
    CONSTRAINT ORDERSTATUS_orderid_pk PRIMARY KEY (OrderId),
    foreign key(OrderId) references ORDERINFORMATION(OrderId),--订单编号外码依赖E表
    CONSTRAINT orderstatuscode_ck CHECK (OrderStatusCode like'[012]')--检查订单状态码是否在012中
)
go
insert into ORDERSTATUS values('11111111','2')
insert into ORDERSTATUS values('22222222','0')
insert into ORDERSTATUS values('33333333','1')
insert into ORDERSTATUS values('44444444','0')
insert into ORDERSTATUS values('55555555','1')
select * from ORDERSTATUS


--H收货信息
use ECMANAGE
go
CREATE TABLE RECEIVEINFO(--！！如果订单编号和用户id都重复，报错。用户id重复，订单编号不重复就是一个人买了多个东西
	UserId  int not null,
	OrderId	 int not null,
	Consignee	char(6)	not null,
	AddressId	varchar(20)	not null,
	UserPhone	varchar(11)not null,
    CONSTRAINT Userid_OrderId_pk PRIMARY KEY (UserId,OrderId),
	foreign key(UserId) references Users(UserId),--用户ID外码依赖A表
    foreign key(OrderId) references ORDERINFORMATION(OrderId),--订单编号外码依赖E表
	foreign key(AddressId) references SHIPPINGADDRESS(AddressId),--地址编号外码依赖B表
    constraint RECEIVEINFO_addressid_fk foreign key (AddressId) references SHIPPINGADDRESS(AddressId) on delete cascade on update cascade,--地址编号与B表级联
	CONSTRAINT RECEIVEINFO_UserPhone_ck check (len(UserPhone)=11 and UserPhone like'[1][35678][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--检查手机号格式
)
go
insert into RECEIVEINFO values('1','11111111','老王','551243','13578268811')
insert into RECEIVEINFO values('3','22222222','老李','553490','13935562345')
insert into RECEIVEINFO values('2','33333333','老罗','573811','13578213812')
insert into RECEIVEINFO values('5','44444444','老陈','515200','13578456841')
insert into RECEIVEINFO values('1','55555555','老方','578943','13578262225')
select * from RECEIVEINFO

--商家-仓库关系表
use ECMANAGE
go
CREATE TABLE COMPANY_WAREHOUSEINFO(
	CompanyID  int not null,
	WarehouseID	 int not null,
	ProductID int not null,
	LeaseExpiryTime smalldatetime not null,
    CONSTRAINT CompanyID_WarehouseID_pk PRIMARY KEY (CompanyID,WarehouseID,ProductID),
	foreign key(CompanyID) references COMPANY(CompanyID),--商家ID外码依赖k表
    foreign key(WarehouseID,ProductID) references WAREHOUSEINFO(WarehouseID,ProductID),--仓库ID外码依赖i表
    constraint COMPANY_CompanyID_fk foreign key (CompanyID) references COMPANY(CompanyID) on delete cascade on update cascade,--商家ID与k表级联
	constraint WAREHOUSEINFO_WarehouseID_fk foreign key (WarehouseID,ProductID) references WAREHOUSEINFO(WarehouseID,ProductID) on delete cascade on update cascade,--仓库ID与I表级联
	constraint LeaseExpiryTime_ck check (LeaseExpiryTime>getdate())--检查时间不小于当前时间
)
go
insert into COMPANY_WAREHOUSEINFO values('1','1','1','2027-11-02 23:59')
insert into COMPANY_WAREHOUSEINFO values('3','2','2','2025-1-16 23:59')
insert into COMPANY_WAREHOUSEINFO values('2','3','5','2051-11-02 23:59')
insert into COMPANY_WAREHOUSEINFO values('5','4','3','2028-1-02 23:59')
select * from COMPANY_WAREHOUSEINFO

--商家-商品关系表
use ECMANAGE
go
CREATE TABLE COMPANY_PRODUCTPROPERTIES(
	CompanyID  int ,
	ProductId	 int,
	DateIssuedTime smalldatetime not null,
    CONSTRAINT CompanyID_ProductId_pk PRIMARY KEY (CompanyID,ProductId),
	foreign key(CompanyID) references COMPANY(CompanyID),--商家ID外码依赖k表
    foreign key(ProductId) references PRODUCTPROPERTIES(ProductId),--商品ID外码依赖d表
    constraint COMPANY_PRODUCTPROPERTIES_CompanyID_fk foreign key (CompanyID) references COMPANY(CompanyID) on delete cascade on update cascade,--商家ID与k表级联
	constraint PRODUCTPROPERTIES_ProductId_fk foreign key (ProductId) references PRODUCTPROPERTIES(ProductId) on delete cascade on update cascade,--商品ID与d表级联
	constraint DateIssuedTime_ck check (DateIssuedTime<getdate())--检查时间不大于当前时间
)
go
insert into COMPANY_PRODUCTPROPERTIES values('1','2','2021-11-02 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('3','3','2020-1-16 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('2','4','2011-11-02 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('5','1','2012-1-02 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('4','5','2018-11-02 23:59')
select * from COMPANY_PRODUCTPROPERTIES









---用户1视图
CREATE VIEW USER1VIEW
as 
	select distinct(A.userId),A.UserName,A.UserPassword,B.Consignee,C.PhoneNumber,B.AddressId,B.Province,B.City,B.Area,B.DetailedAddress,C.RegistrationTime
	from USERS A,SHIPPINGADDRESS B,USERINFO C
	where A.userId=C.UserId and B.UserId= A.userId and A.userId=1
	select *from USER1VIEW
---用户1订单视图
CREATE VIEW USER1ORDERVIEW
as
	select E.UserId,A.UserName,E.OrderId,E.CreationTime,E.Payment,K.CompanyId,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
	from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K
	where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND E.CompanyId=K.CompanyId AND A.userId=1

--drop view USER1ORDERVIEW
	--select *from USER1ORDERVIEW

---用户2视图
CREATE VIEW USER2VIEW
as 
	select distinct(A.userId),A.UserName,A.UserPassword,B.Consignee,C.PhoneNumber,B.AddressId,B.Province,B.City,B.Area,B.DetailedAddress,C.RegistrationTime
	from USERS A,SHIPPINGADDRESS B,USERINFO C
	where A.userId=C.UserId and B.UserId= A.userId and A.userId=2

---用户2订单视图
CREATE VIEW USER2ORDERVIEW
as
	select E.UserId,A.UserName,E.OrderId,E.CreationTime,E.Payment,K.CompanyId,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
	from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K
	where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND E.CompanyId=K.CompanyId AND A.userId=2
select * from USER2ORDERVIEW

---商家1信息视图
CREATE VIEW MERCHANT1VIEW
as 
	select K.CompanyId,K.CompanyName,K.CompanyDescription,I.ProductsNumber,J.WarehouseID,J.WarehouseAddressId,J.Province,J.City,J.Area,J.DetailedAddress
	from COMPANY K,COMPANY_WAREHOUSEINFO L,WAREHOUSEINFO I,WAREHOUSEADDRESS J
	where L.CompanyID=K.CompanyId AND L.WarehouseID=I.WarehouseID AND I.WarehouseID=J.WarehouseID AND K.CompanyId=1

select * from MERCHANT1VIEW

---商家1商品视图
CREATE VIEW	MERCHANT1SHOPINGVIEW
as
	select K.CompanyId,K.CompanyName,D.ProductName,D.Specifications,D.ProductSales,D.Brands,D.ProductPrice,M.DateIssuedTime
	from COMPANY_PRODUCTPROPERTIES M,COMPANY K,PRODUCTPROPERTIES D
	where M.CompanyID=K.CompanyId AND M.ProductId=D.ProductId AND K.CompanyId=1

---商家1订单视图
CREATE VIEW MERCHANT1ORDERVIEW
as
	select K.CompanyId,K.CompanyName,I.WarehouseID,E.UserId,E.OrderId,H.Consignee,H.UserPhone,H.AddressId,E.CreationTime,E.Payment,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
	from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K,RECEIVEINFO H,SHIPPINGADDRESS B,WAREHOUSEADDRESS J,WAREHOUSEINFO I
	where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND I.ProductID=D.ProductId AND E.CompanyId=K.CompanyId AND H.OrderId=E.OrderId AND I.WarehouseID=J.WarehouseID AND H.AddressId=B.AddressId AND K.CompanyId=1





---收货地址增
CREATE PROCEDURE ADDSHIPPINGADDRESS
@AddressId varchar(20),---地址编号
@Consignee varchar(6),---收货人
@Province  varchar(20),
@City	   varchar(20),
@Area      varchar(20),
@DetailedAddress varchar(50),
@UserId	int 
as
declare @msg varchar(30)
begin
	if @UserId in (select UserId from USERS)
	begin
		if @AddressId not in (select AddressId from SHIPPINGADDRESS)
		begin
		insert into SHIPPINGADDRESS values(@AddressId,@Consignee,@Province,@City,@Area,@DetailedAddress,@UserId)
		set @msg='增加成功'
		end
		else
			begin
			--set @msg='用户不存在'
			exec  CHANGESHIPPINGADDRESS @AddressId,@Consignee,@Province,@City,@Area,@DetailedAddress,@UserId
			end
	end
	else 
		begin
		set @msg='用户不存在'
		end
	select @msg
end
select * from SHIPPINGADDRESS
exec ADDSHIPPINGADDRESS @AddressId='578942',@Consignee='李',@Province='ff',@City='北',@Area='汉',@DetailedAddress='山术开发区',@UserId=6
select * from SHIPPINGADDRESS
delete  from SHIPPINGADDRESS where AddressId='578942' and UserId=5
delete  from SHIPPINGADDRESS where AddressId='551243' and UserId=1
drop PROCEDURE   ADDSHIPPINGADDRESS


---收货地址删
CREATE PROCEDURE DELSHIPPINGADDRESS
@AddressId varchar(20),---地址编号
@UserId	int ---用户id
as	
declare @msg varchar(30)
begin
	if @UserId in (select UserId from SHIPPINGADDRESS)
	begin
		if @AddressId in (select AddressId from SHIPPINGADDRESS)
		begin
		delete from SHIPPINGADDRESS where AddressId=@AddressId
		set @msg='删除成功'	
		end	
		else
		set @msg='用户地址编号不存在'	
	end
	else 
		set @msg='用户不存在'
	select @msg
end

--select * from SHIPPINGADDRESS
--exec DELSHIPPINGADDRESS @AddressId='515200',@UserId='6'
--drop PROCEDURE   DELSHIPPINGADDRESS


---收货地址查
CREATE PROCEDURE CHECKSHIPPINGADDRESS
@AddressId varchar(20),---地址编号
@UserId	int ---用户id
as	
declare @msg varchar(30)
begin
	if @UserId in(select UserId from SHIPPINGADDRESS)
	begin
		if @AddressId in (select AddressId from SHIPPINGADDRESS)
		begin
		select * from SHIPPINGADDRESS where UserId= @UserId and AddressId=@AddressId
		set @msg='查询成功'
		end
		else
		set @msg='用户地址编号不存在'
	end	
	else
		begin
		set @msg='用户不存在'	
		end
	select @msg
end

--drop PROCEDURE  CHECKSHIPPINGADDRESS
exec CHECKSHIPPINGADDRESS @AddressId='551243',@UserId='1'


---收货地址改
CREATE PROCEDURE CHANGESHIPPINGADDRESS
@AddressId varchar(20),---地址编号
@Consignee varchar(6),---收货人
@Province  varchar(20),
@City	   varchar(20),
@Area      varchar(20),
@DetailedAddress varchar(50),
@UserId	int 
as
declare @msg varchar(30)
begin
	if @UserId in (select UserId from SHIPPINGADDRESS)
	begin
		if @AddressId  in (select AddressId from SHIPPINGADDRESS)
		begin
		update  SHIPPINGADDRESS set Consignee=@Consignee,Province=@Province,City=@City,Area=@Area,DetailedAddress=@DetailedAddress
		where AddressId= @AddressId and UserId= @UserId
		set @msg='更改成功'

		end
		else
			begin
			set @msg='地址编号不存在'
			end
	end
	else 
		begin
		set @msg='用户不存在'
		end
	select @msg
end

exec  CHANGESHIPPINGADDRESS @AddressId='551243',@Consignee='李',@Province='ff',@City='北',@Area='汉',@DetailedAddress='山术开发区',@UserId=1
drop PROCEDURE  CHANGESHIPPINGADDRESS
select * from SHIPPINGADDRESS

1.订单查询
输入参数：订单编号
输出结果：订单编号，订单状态，下单时间，商品编号，商品数量，商品金额，总金额
判断输入参数是否符合条件
根据输入参数查询订单信息表和订单状态表中的订单编号、订单状态、下单时间、商品编号、商品数量、商品金额、总金额，
显示对应订单编号的内容	
CREATE PROCEDURE proOrderInquire(@OrderId int)
AS 
BEGIN
	if(@OrderId is not null and @OrderId<> '')
	BEGIN
		SELECT a.OrderId,OrderStatusCode,CreationTime,ProductId,Quantity,CommodityPrice,TotalAmount
		FROM ORDERINFORMATION a,ORDERSTATUS b
		WHERE a.OrderId = @OrderId AND a.OrderId = b.OrderId
	END
END

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




