create database ECMANAGE
on
   (name='ECMANAGE',
    filename='E:\ECMANAGE\ECMANAGE.mdf',
    size=5,
    maxsize=100,
    filegrowth=5%)
log on
   (name='ECManagelog',
    filename='E:\ECMANAGE\ECMANAGELOG.ldf',
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
select * from ORDERINFORMATION

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