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
--A�û���
use ECMANAGE
go
CREATE TABLE USERS(  
    userId    INT  NOT NULL identity(1,1),
    UserName  VARCHAR(15) NOT NULL,
    UserPassword    VARCHAR(15) NOT NULL,
    CONSTRAINT userid_pk PRIMARY KEY (userid),
    CONSTRAINT username_ck UNIQUE(username),--����û������ظ�
    CONSTRAINT usepassword CHECK (LEN(userpassword)>6)--����������6λ��
)
go
insert into USERS values('wang','1233456')
insert into USERS values('lin','13456333')
insert into USERS values('fang','1345633')
insert into USERS values('ma','1345633233')
insert into USERS values('luo','132233233')--�������ݲ�������ID��ϵͳ���Լ���������ɾ�����ݺ�������ID��������ȥ�ģ�
select * from users

--B�ջ���ַ
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
insert into SHIPPINGADDRESS values('551243','С��','�㶫','����','����','�㶫�ڶ�ʦ��','1')
insert into SHIPPINGADDRESS values('553490','С��','����','����','����','ɽˮ','2')
insert into SHIPPINGADDRESS values('573811','С��','����','�ߺ�','���','111111','3')
insert into SHIPPINGADDRESS values('515200','С��','����','����','����','�ɽ','4')
insert into SHIPPINGADDRESS values('578943','С��','����','�人','��ɽ','�����¼���������','5')
select *from SHIPPINGADDRESS
--C�û���Ϣ
use ECMANAGE
go
CREATE TABLE USERINFO(  
    UserId  int  NOT NULL ,
	UserStatus   varchar(20)  NOT NULL ,
	RegistrationTime   smalldatetime  NOT NULL ,
	PhoneNumber   varchar(11)  NOT NULL ,
	foreign key(UserId) references USERS(UserId),
	CONSTRAINT phonenumber_ck check (len(PhoneNumber)=11 and PhoneNumber like'[1][35678][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--����ֻ��Ÿ�ʽ
)
go
insert into USERINFO values('1','����','1998-01-01 23:59','13580214940')
insert into USERINFO values('2','����','1998-01-01 23:59','16580214940')
insert into USERINFO values('3','����','1998-01-01 23:29','13580214940')--C��������ݱ��������A���B������ݣ���ID������ͬ
insert into USERINFO values('4','����','2021-04-21 3:29','13582924940')
insert into USERINFO values('5','����','2020-02-16 5:29','13522346140')
select *from USERINFO

--k�̼���Ϣ
use ECMANAGE
go
CREATE TABLE COMPANY(  
	CompanyId   int,
	CompanyName		varchar(20) not null,	
	CompanyDescription char(50) not null,
    CONSTRAINT companyid_pk PRIMARY KEY (CompanyId),
)
go
insert into COMPANY values('1','��Ϊ','�̼�����')
insert into COMPANY values('2','С��','�̼�����')
insert into COMPANY values('3','����','�̼�����')
insert into COMPANY values('4','����','�̼�����')
insert into COMPANY values('5','����','�̼�����')
select *from COMPANY

--D��Ʒ����
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
	foreign key(CompanyId) references COMPANY(CompanyId),--�̼�ID����K��
	CONSTRAINT productprice_ck check (ProductPrice>0)--���۸����0
)
insert into PRODUCTPROPERTIES values('1','����','80*60','233','ɭ��','8848','1')
insert into PRODUCTPROPERTIES values('2','�ֻ�','20*10','12343','��Ϊ','1999','2')
insert into PRODUCTPROPERTIES values('3','�����','20','2683','��糵','1999','3')
insert into PRODUCTPROPERTIES values('4','���','43','664','��˶','23','4')
insert into PRODUCTPROPERTIES values('5','��ʾ��','120*140','263','����','668','5')
select * from PRODUCTPROPERTIES

--I�ֿ���Ϣ
use ECMANAGE
go
CREATE TABLE WAREHOUSEINFO(
	WarehouseID	  int,
	ProductID int not null UNIQUE,
	ProductsNumber int default(0) ,
	CompanyId int not null,
	CONSTRAINT warehouseid_pk PRIMARY KEY (WarehouseID,ProductID),
	foreign key(CompanyId) references Company(CompanyId),--�̼�ID����k��
	foreign key(ProductID) references PRODUCTPROPERTIES(ProductID),--��Ʒ�������D��
	constraint productsnumber_ck check (ProductsNumber>0)--�����Ʒ�������ڵ���0
)

go
insert into WAREHOUSEINFO values('1','1','35','1')
insert into WAREHOUSEINFO values('2','2','56','2')
insert into WAREHOUSEINFO values('3','5','345','3')
insert into WAREHOUSEINFO values('4','3','725','4')
insert into WAREHOUSEINFO values('5','4','116','5')
select * from WAREHOUSEINFO

--J�ֿ��ַ
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
insert into WAREHOUSEADDRESS values('53333','1','�㶫','����','����','����ѧԺ','1')
insert into WAREHOUSEADDRESS values('3333','2','�㶫','����','����','¡����','2')
insert into WAREHOUSEADDRESS values('517781','5','����','����','����','�纣��','3')
insert into WAREHOUSEADDRESS values('73513','3','�ӱ�','����','�ˮ','������','4')
select *from WAREHOUSEADDRESS

--F����
use ECMANAGE
go
CREATE TABLE lODISTICS(  
    ExpressNumber    INT  NOT NULL ,
    DeliveryTime  smallDateTime NOT NULL,
    ReceiptTime    smallDateTime   NULL,
	Freight    smallmoney NOT NULL,
	LogisticsStatusCode  int default(3),
    CONSTRAINT expressnumber_pk PRIMARY KEY (ExpressNumber),
    CONSTRAINT logisticsstatuscode_ck CHECK (LogisticsStatusCode like'[0123]'),--�������״̬���Ƿ���0123 ��
)
go
insert into lODISTICS values('123456789','2021-12-01 13:59','2021-12-05 23:59','34','1')
insert into lODISTICS values('1135792468','2020-10-01 2:59','2020-11-01 23:59','10','2')
insert into lODISTICS values('657817661','2020-05-01 2:59','2020-05-01 23:59','37','1')
insert into lODISTICS values('765728292','2020-06-01 5:59','2020-12-01 23:59','20','3')
insert into lODISTICS values('426768292','2020-07-01 7:59','2020-11-01 23:59','133','2')
select * from lODISTICS


--E������Ϣ
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
	foreign key(UserId) references Users(UserId),--�û�ID����A��
	foreign key(ProductId) references PRODUCTPROPERTIES(ProductId),--��Ʒ�������D��
	foreign key(ExpressNumber) references lODISTICS(ExpressNumber),--��ݵ�������F��
	foreign key(CompanyId) references COMPANY(CompanyId),
	constraint expressnumber_fk foreign key (ExpressNumber) references lODISTICS(ExpressNumber) on delete cascade on update cascade,--��ݵ��ż���F��
	CONSTRAINT payment_ck CHECK (Payment like'[0123]'),--���֧����ʽ���Ƿ���0123��
	CONSTRAINT commodityprice_ck CHECK (CommodityPrice>0),--������0
	CONSTRAINT totalamount_ck CHECK (TotalAmount>0),--������0
	CONSTRAINT quantity_ck CHECK (Quantity>0),--������0
)
go
insert into ORDERINFORMATION values('11111111','2021-11-02 23:59','1','2','2','8848','12888','123456789','6','1')
insert into ORDERINFORMATION values('22222222','2021-11-01 23:59','3','3','1','76','888','1135792468','23','2')
insert into ORDERINFORMATION values('33333333','2020-05-04 23:59','2','1','4','199','1348','657817661','263','3')
insert into ORDERINFORMATION values('44444444','2020-04-18 23:59','2','5','2','299','2456','765728292','2343','4')
insert into ORDERINFORMATION values('55555555','2021-07-27 23:59','2','4','5','648','1345','426768292','293','5')
select * from ORDERINFORMATION

--G����״̬
use ECMANAGE
go
CREATE TABLE ORDERSTATUS(  
    OrderId   INT  NOT NULL ,
	OrderStatusCode   INT  default(0),
    CONSTRAINT ORDERSTATUS_orderid_pk PRIMARY KEY (OrderId),
    foreign key(OrderId) references ORDERINFORMATION(OrderId),--���������������E��
    CONSTRAINT orderstatuscode_ck CHECK (OrderStatusCode like'[012]')--��鶩��״̬���Ƿ���012��
)
go
insert into ORDERSTATUS values('11111111','2')
insert into ORDERSTATUS values('22222222','0')
insert into ORDERSTATUS values('33333333','1')
insert into ORDERSTATUS values('44444444','0')
insert into ORDERSTATUS values('55555555','1')
select * from ORDERSTATUS


--H�ջ���Ϣ
use ECMANAGE
go
CREATE TABLE RECEIVEINFO(--�������������ź��û�id���ظ��������û�id�ظ���������Ų��ظ�����һ�������˶������
	UserId  int not null,
	OrderId	 int not null,
	Consignee	char(6)	not null,
	AddressId	varchar(20)	not null,
	UserPhone	varchar(11)not null,
    CONSTRAINT Userid_OrderId_pk PRIMARY KEY (UserId,OrderId),
	foreign key(UserId) references Users(UserId),--�û�ID��������A��
    foreign key(OrderId) references ORDERINFORMATION(OrderId),--���������������E��
	foreign key(AddressId) references SHIPPINGADDRESS(AddressId),--��ַ�����������B��
    constraint RECEIVEINFO_addressid_fk foreign key (AddressId) references SHIPPINGADDRESS(AddressId) on delete cascade on update cascade,--��ַ�����B����
	CONSTRAINT RECEIVEINFO_UserPhone_ck check (len(UserPhone)=11 and UserPhone like'[1][35678][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),--����ֻ��Ÿ�ʽ
)
go
insert into RECEIVEINFO values('1','11111111','����','551243','13578268811')
insert into RECEIVEINFO values('3','22222222','����','553490','13935562345')
insert into RECEIVEINFO values('2','33333333','����','573811','13578213812')
insert into RECEIVEINFO values('5','44444444','�ϳ�','515200','13578456841')
insert into RECEIVEINFO values('1','55555555','�Ϸ�','578943','13578262225')
select * from RECEIVEINFO

--�̼�-�ֿ��ϵ��
use ECMANAGE
go
CREATE TABLE COMPANY_WAREHOUSEINFO(
	CompanyID  int not null,
	WarehouseID	 int not null,
	ProductID int not null,
	LeaseExpiryTime smalldatetime not null,
    CONSTRAINT CompanyID_WarehouseID_pk PRIMARY KEY (CompanyID,WarehouseID,ProductID),
	foreign key(CompanyID) references COMPANY(CompanyID),--�̼�ID��������k��
    foreign key(WarehouseID,ProductID) references WAREHOUSEINFO(WarehouseID,ProductID),--�ֿ�ID��������i��
    constraint COMPANY_CompanyID_fk foreign key (CompanyID) references COMPANY(CompanyID) on delete cascade on update cascade,--�̼�ID��k����
	constraint WAREHOUSEINFO_WarehouseID_fk foreign key (WarehouseID,ProductID) references WAREHOUSEINFO(WarehouseID,ProductID) on delete cascade on update cascade,--�ֿ�ID��I����
	constraint LeaseExpiryTime_ck check (LeaseExpiryTime>getdate())--���ʱ�䲻С�ڵ�ǰʱ��
)
go
insert into COMPANY_WAREHOUSEINFO values('1','1','1','2027-11-02 23:59')
insert into COMPANY_WAREHOUSEINFO values('3','2','2','2025-1-16 23:59')
insert into COMPANY_WAREHOUSEINFO values('2','3','5','2051-11-02 23:59')
insert into COMPANY_WAREHOUSEINFO values('5','4','3','2028-1-02 23:59')
select * from COMPANY_WAREHOUSEINFO

--�̼�-��Ʒ��ϵ��
use ECMANAGE
go
CREATE TABLE COMPANY_PRODUCTPROPERTIES(
	CompanyID  int ,
	ProductId	 int,
	DateIssuedTime smalldatetime not null,
    CONSTRAINT CompanyID_ProductId_pk PRIMARY KEY (CompanyID,ProductId),
	foreign key(CompanyID) references COMPANY(CompanyID),--�̼�ID��������k��
    foreign key(ProductId) references PRODUCTPROPERTIES(ProductId),--��ƷID��������d��
    constraint COMPANY_PRODUCTPROPERTIES_CompanyID_fk foreign key (CompanyID) references COMPANY(CompanyID) on delete cascade on update cascade,--�̼�ID��k����
	constraint PRODUCTPROPERTIES_ProductId_fk foreign key (ProductId) references PRODUCTPROPERTIES(ProductId) on delete cascade on update cascade,--��ƷID��d����
	constraint DateIssuedTime_ck check (DateIssuedTime<getdate())--���ʱ�䲻���ڵ�ǰʱ��
)
go
insert into COMPANY_PRODUCTPROPERTIES values('1','2','2021-11-02 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('3','3','2020-1-16 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('2','4','2011-11-02 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('5','1','2012-1-02 23:59')
insert into COMPANY_PRODUCTPROPERTIES values('4','5','2018-11-02 23:59')
select * from COMPANY_PRODUCTPROPERTIES