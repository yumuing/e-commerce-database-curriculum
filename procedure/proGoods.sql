create proc proGoodsPut(@ProductName varchar(20),@Specifications varchar(20),@Brands varchar(20),@ProductPrice float)
as
begin
	declare @ProductId int

	select @ProductId = isnull(ProductId,0) from PRODUCTPROPERTIES
	
	IF @ProductId != ''			--����Ʒ��Ų�Ϊ�գ�����ԭ������+1
	begin
		set @ProductId = @ProductId + 1
	end

	ELSE							-- ��Ϊ�գ���ֵΪ0
	begin
		set @ProductId = 0
	end

	-- ������Ʒ��Ϣ����Ʒ���Ա�
	insert into PRODUCTPROPERTIES(ProductId,ProductName,Specifications,ProductPrice,Brands)
	values(@ProductId,@ProductName,@Specifications,@ProductPrice,@Brands)

	declare curCompany cursor	--�����α꣬�����̼ұ��
	for
		select CompanyId
		from COMPANY

	declare @CompanyId int
	declare @DateIssuedTime smalldatetime
	OPEN curCompany
	FETCH curCompany into @CompanyId
	while( @@FETCH_STATUS = 0 )
	begin
		set @DateIssuedTime = CONVERT(varchar(10), GETDATE(),120)  -- ��ȡ��ǰϵͳ����
		insert into COMPANY_PRODUCTPROPERTIES(CompanyID,ProductId,DateIssuedTime)
		select CompanyID = @CompanyId,ProductId = @ProductId, DateIssuedTime = @DateIssuedTime
		
		FETCH curCompany into @CompanyId
	end
	close curCompany
	deallocate curCompany
end
--����
EXECUTE proGoodsPut С��,11,888,222
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
		print '���޴���Ʒ'
	end

	ELSE
	begin
		-- ������Ʒ���ɾ��
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