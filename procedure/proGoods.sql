create proc proGoodsPut(@ProductName varchar(20),@Specifications varchar(20),@Brands varchar(20),@ProductPrice float)
as
begin
	declare @ProductId int

	select @ProductId = isnull(ProductId,0) from PRODUCTPROPERTIES
	
	IF @ProductId != ''			--若商品编号不为空，则在原基础上+1
	begin
		set @ProductId = @ProductId + 1
	end

	ELSE							-- 若为空，则赋值为0
	begin
		set @ProductId = 0
	end

	-- 插入商品信息到商品属性表
	insert into PRODUCTPROPERTIES(ProductId,ProductName,Specifications,ProductPrice,Brands)
	values(@ProductId,@ProductName,@Specifications,@ProductPrice,@Brands)

	declare curCompany cursor	--定义游标，检索商家编号
	for
		select CompanyId
		from COMPANY

	declare @CompanyId int
	declare @DateIssuedTime smalldatetime
	OPEN curCompany
	FETCH curCompany into @CompanyId
	while( @@FETCH_STATUS = 0 )
	begin
		set @DateIssuedTime = CONVERT(varchar(10), GETDATE(),120)  -- 获取当前系统日期
		insert into COMPANY_PRODUCTPROPERTIES(CompanyID,ProductId,DateIssuedTime)
		select CompanyID = @CompanyId,ProductId = @ProductId, DateIssuedTime = @DateIssuedTime
		
		FETCH curCompany into @CompanyId
	end
	close curCompany
	deallocate curCompany
end
--测试
EXECUTE proGoodsPut 小米,11,888,222
select * from PRODUCTPROPERTIES
select * from COMPANY_PRODUCTPROPERTIES
delete from PRODUCTPROPERTIES where (ProductId='6')
--
go
create proc proGoodsSoldOut(@ProductId int)
as
begin
	IF(@ProductId not in (select ProductId from PRODUCTPROPERTIES) )
	begin
		print '查无此商品'
	end

	ELSE
	begin
		-- 根据商品编号删除
		delete from PRODUCTPROPERTIES
		where ProductId = @ProductId

		delete from COMPANY_PRODUCTPROPERTIES
		where ProductId = @ProductId

		delete from COMPANY_WAREHOUSEINFO
		where ProductId = @ProductId
	end
end
EXECUTE proGoodsSoldOut 7
select * from PRODUCTPROPERTIES
select * from COMPANY_PRODUCTPROPERTIES