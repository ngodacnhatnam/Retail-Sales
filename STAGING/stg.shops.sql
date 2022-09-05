use dw_future_sales
go

drop table [stg].[SHOP]

CREATE TABLE [stg].[SHOP](
    shop_id int,
    shop_name nvarchar(250),
)

BULK INSERT [stg].[SHOP]
FROM '/shop1.csv'
with(
    format = 'csv',
    firstrow = 2,
    fieldterminator = ';',
    rowterminator = '\n'
)

select top 3 * from [stg].[SHOP]
go


