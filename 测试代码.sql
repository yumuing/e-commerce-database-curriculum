--�û�ע��
execute  UserRegistrate '�Ͻ�','123456789',13345667890
select * from USER7VIEW
--�ջ���ַ��ɾ�Ĳ�
exec ADDSHIPPINGADDRESS @AddressId='578949',@Consignee='��',@Province='�㶫',@City='����',@Area='����',@DetailedAddress='������',@UserId=7
exec  CHANGESHIPPINGADDRESS @AddressId='578949',@Consignee='��',@Province='ff',@City='��',@Area='��',@DetailedAddress='ɽ��������',@UserId=7
exec CHECKSHIPPINGADDRESS @AddressId='578949',@UserId='7'
exec DELSHIPPINGADDRESS @AddressId='578949',@UserId='7'
exec CHECKSHIPPINGADDRESS @AddressId='578949',@UserId='7'
exec  CHANGESHIPPINGADDRESS @AddressId='551249',@Consignee='��',@Province='ff',@City='��',@Area='��',@DetailedAddress='ɽ��������',@UserId=7
exec CHECKSHIPPINGADDRESS @AddressId='578949',@UserId='7'
--�̼�ע��
execute CompanyRegistrate '��Ϊ','�̼�����'

--��Ʒ���¼�
EXECUTE proGoodsPut �ֻ�,20.10,��Ϊ,1999
select * from MERCHANT1SHOPINGVIEW

EXECUTE proGoodsSoldOut 6
select * from MERCHANT1SHOPINGVIEW

--��������
EXECUTE proOrderCreate 4,2,3,25
EXECUTE  proOrderInquire '55555558'
--�û�֧��
EXECUTE proOrderPaymentUpdate 55555558,1
EXECUTE  proOrderInquire '55555558'
--�̼ҷ���
EXECUTE proLogStatusUpdate 55555558
EXECUTE  proOrderInquire '55555558'
--���ջ����������
EXECUTE proLogAccomplish 55555558
EXECUTE  proOrderInquire '55555558'
--����ɾ��
EXECUTE proOrderDrop '55555558'
EXECUTE  proOrderInquire '55555558'
--������ѯ
EXECUTE  proOrderInquire '55555558'
