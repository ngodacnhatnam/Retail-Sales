use dw_future_sales
go

--CREATE SCHEMA [stg]; -- stg previously database name for staging database
--GO

DROP TABLE [stg].[ITEM];

CREATE TABLE [stg].[ITEM](
   item_id int,
   item_name nvarchar(500) collate Cyrillic_General_CI_AS_KS,
   item_category_id int,
)

BULK INSERT [stg].[ITEM]
FROM '/items1.csv'
with(
    format = 'csv',
    firstrow = 2,
    fieldterminator = ';',
    rowterminator = '0x0a'
)

go


select * from [stg].[ITEM]
