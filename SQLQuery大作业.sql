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
insert into WAREHOUSEADDRESS values('6421','4','����','��ƽ','��ͨ','������','5')
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
insert into ORDERINFORMATION values('66666666','2021-07-27 23:59','3','4','5','648','1345','426768292','293','5')
select * from ORDERINFORMATION
delete from ORDERINFORMATION where(OrderId='66666666')
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









---�û�1��ͼ
CREATE VIEW USER1VIEW
as 
	select distinct(A.userId),A.UserName,A.UserPassword,B.Consignee,C.PhoneNumber,B.AddressId,B.Province,B.City,B.Area,B.DetailedAddress,C.RegistrationTime
	from USERS A,SHIPPINGADDRESS B,USERINFO C
	where A.userId=C.UserId and B.UserId= A.userId and A.userId=1
	select *from USER1VIEW
---�û�1������ͼ
CREATE VIEW USER1ORDERVIEW
as
	select E.UserId,A.UserName,E.OrderId,E.CreationTime,E.Payment,K.CompanyId,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
	from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K
	where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND E.CompanyId=K.CompanyId AND A.userId=1

--drop view USER1ORDERVIEW
	--select *from USER1ORDERVIEW

---�û�2��ͼ
CREATE VIEW USER2VIEW
as 
	select distinct(A.userId),A.UserName,A.UserPassword,B.Consignee,C.PhoneNumber,B.AddressId,B.Province,B.City,B.Area,B.DetailedAddress,C.RegistrationTime
	from USERS A,SHIPPINGADDRESS B,USERINFO C
	where A.userId=C.UserId and B.UserId= A.userId and A.userId=2

---�û�2������ͼ
CREATE VIEW USER2ORDERVIEW
as
	select E.UserId,A.UserName,E.OrderId,E.CreationTime,E.Payment,K.CompanyId,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
	from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K
	where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND E.CompanyId=K.CompanyId AND A.userId=2
select * from USER2ORDERVIEW

---�̼�1��Ϣ��ͼ
CREATE VIEW MERCHANT1VIEW
as 
	select K.CompanyId,K.CompanyName,K.CompanyDescription,I.ProductsNumber,J.WarehouseID,J.WarehouseAddressId,J.Province,J.City,J.Area,J.DetailedAddress
	from COMPANY K,COMPANY_WAREHOUSEINFO L,WAREHOUSEINFO I,WAREHOUSEADDRESS J
	where L.CompanyID=K.CompanyId AND L.WarehouseID=I.WarehouseID AND I.WarehouseID=J.WarehouseID AND K.CompanyId=1

select * from MERCHANT1VIEW

---�̼�1��Ʒ��ͼ
CREATE VIEW	MERCHANT1SHOPINGVIEW
as
	select K.CompanyId,K.CompanyName,D.ProductName,D.Specifications,D.ProductSales,D.Brands,D.ProductPrice,M.DateIssuedTime
	from COMPANY_PRODUCTPROPERTIES M,COMPANY K,PRODUCTPROPERTIES D
	where M.CompanyID=K.CompanyId AND M.ProductId=D.ProductId AND K.CompanyId=1

---�̼�1������ͼ
CREATE VIEW MERCHANT1ORDERVIEW
as
	select K.CompanyId,K.CompanyName,I.WarehouseID,E.UserId,E.OrderId,H.Consignee,H.UserPhone,H.AddressId,E.CreationTime,E.Payment,E.ProductId,E.CommodityPrice,E.Quantity,E.TotalAmount,E.ExpressNumber,F.Freight,F.DeliveryTime,F.ReceiptTime,F.LogisticsStatusCode
	from ORDERINFORMATION E,USERS A,PRODUCTPROPERTIES D,lODISTICS F,COMPANY K,RECEIVEINFO H,SHIPPINGADDRESS B,WAREHOUSEADDRESS J,WAREHOUSEINFO I
	where E.UserId=A.userId AND E.ProductId=D.ProductId AND E.ExpressNumber=F.ExpressNumber AND I.ProductID=D.ProductId AND E.CompanyId=K.CompanyId AND H.OrderId=E.OrderId AND I.WarehouseID=J.WarehouseID AND H.AddressId=B.AddressId AND K.CompanyId=1





---�ջ���ַ��
CREATE PROCEDURE ADDSHIPPINGADDRESS
@AddressId varchar(20),---��ַ���
@Consignee varchar(6),---�ջ���
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
		set @msg='���ӳɹ�'
		end
		else
			begin
			--set @msg='�û�������'
			exec  CHANGESHIPPINGADDRESS @AddressId,@Consignee,@Province,@City,@Area,@DetailedAddress,@UserId
			end
	end
	else 
		begin
		set @msg='�û�������'
		end
	select @msg
end
select * from SHIPPINGADDRESS
exec ADDSHIPPINGADDRESS @AddressId='578942',@Consignee='��',@Province='ff',@City='��',@Area='��',@DetailedAddress='ɽ��������',@UserId=6
select * from SHIPPINGADDRESS
delete  from SHIPPINGADDRESS where AddressId='578942' and UserId=5
delete  from SHIPPINGADDRESS where AddressId='551243' and UserId=1
drop PROCEDURE   ADDSHIPPINGADDRESS


---�ջ���ַɾ
CREATE PROCEDURE DELSHIPPINGADDRESS
@AddressId varchar(20),---��ַ���
@UserId	int ---�û�id
as	
declare @msg varchar(30)
begin
	if @UserId in (select UserId from SHIPPINGADDRESS)
	begin
		if @AddressId in (select AddressId from SHIPPINGADDRESS)
		begin
		delete from SHIPPINGADDRESS where AddressId=@AddressId
		set @msg='ɾ���ɹ�'	
		end	
		else
		set @msg='�û���ַ��Ų�����'	
	end
	else 
		set @msg='�û�������'
	select @msg
end

--select * from SHIPPINGADDRESS
--exec DELSHIPPINGADDRESS @AddressId='515200',@UserId='6'
--drop PROCEDURE   DELSHIPPINGADDRESS


---�ջ���ַ��
CREATE PROCEDURE CHECKSHIPPINGADDRESS
@AddressId varchar(20),---��ַ���
@UserId	int ---�û�id
as	
declare @msg varchar(30)
begin
	if @UserId in(select UserId from SHIPPINGADDRESS)
	begin
		if @AddressId in (select AddressId from SHIPPINGADDRESS)
		begin
		select * from SHIPPINGADDRESS where UserId= @UserId and AddressId=@AddressId
		set @msg='��ѯ�ɹ�'
		end
		else
		set @msg='�û���ַ��Ų�����'
	end	
	else
		begin
		set @msg='�û�������'	
		end
	select @msg
end

--drop PROCEDURE  CHECKSHIPPINGADDRESS
exec CHECKSHIPPINGADDRESS @AddressId='551243',@UserId='1'


---�ջ���ַ��
CREATE PROCEDURE CHANGESHIPPINGADDRESS
@AddressId varchar(20),---��ַ���
@Consignee varchar(6),---�ջ���
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
		set @msg='���ĳɹ�'

		end
		else
			begin
			set @msg='��ַ��Ų�����'
			end
	end
	else 
		begin
		set @msg='�û�������'
		end
	select @msg
end

exec  CHANGESHIPPINGADDRESS @AddressId='551243',@Consignee='��',@Province='ff',@City='��',@Area='��',@DetailedAddress='ɽ��������',@UserId=1
drop PROCEDURE  CHANGESHIPPINGADDRESS
select * from SHIPPINGADDRESS

1.������ѯ
����������������
��������������ţ�����״̬���µ�ʱ�䣬��Ʒ��ţ���Ʒ��������Ʒ���ܽ��
�ж���������Ƿ��������
�������������ѯ������Ϣ��Ͷ���״̬���еĶ�����š�����״̬���µ�ʱ�䡢��Ʒ��š���Ʒ��������Ʒ���ܽ�
��ʾ��Ӧ������ŵ�����	
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




