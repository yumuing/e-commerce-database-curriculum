--用户注册
execute  UserRegistrate '老江','123456789',13345667890
select * from USER7VIEW
--收货地址增删改查
exec ADDSHIPPINGADDRESS @AddressId='578949',@Consignee='江',@Province='广东',@City='广州',@Area='海珠',@DetailedAddress='广州塔',@UserId=7
exec  CHANGESHIPPINGADDRESS @AddressId='578949',@Consignee='王',@Province='ff',@City='北',@Area='汉',@DetailedAddress='山术开发区',@UserId=7
exec CHECKSHIPPINGADDRESS @AddressId='578949',@UserId='7'
exec DELSHIPPINGADDRESS @AddressId='578949',@UserId='7'
exec CHECKSHIPPINGADDRESS @AddressId='578949',@UserId='7'
exec  CHANGESHIPPINGADDRESS @AddressId='551249',@Consignee='王',@Province='ff',@City='北',@Area='汉',@DetailedAddress='山术开发区',@UserId=7
exec CHECKSHIPPINGADDRESS @AddressId='578949',@UserId='7'
--商家注册
execute CompanyRegistrate '华为','商家描述'

--商品上下架
EXECUTE proGoodsPut 手机,20.10,华为,1999
select * from MERCHANT1SHOPINGVIEW

EXECUTE proGoodsSoldOut 6
select * from MERCHANT1SHOPINGVIEW

--订单创建
EXECUTE proOrderCreate 4,2,3,25
EXECUTE  proOrderInquire '55555558'
--用户支付
EXECUTE proOrderPaymentUpdate 55555558,1
EXECUTE  proOrderInquire '55555558'
--商家发货
EXECUTE proLogStatusUpdate 55555558
EXECUTE  proOrderInquire '55555558'
--已收货，订单完成
EXECUTE proLogAccomplish 55555558
EXECUTE  proOrderInquire '55555558'
--订单删除
EXECUTE proOrderDrop '55555558'
EXECUTE  proOrderInquire '55555558'
--订单查询
EXECUTE  proOrderInquire '55555558'
