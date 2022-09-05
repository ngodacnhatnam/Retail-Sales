use dw_future_sales
go

drop table [stg].[ITEM_CAT]

CREATE TABLE [stg].[ITEM_CAT](
    item_category_id int,
    item_category_name nvarchar(250) collate Cyrillic_General_CI_AS_KS,
)

BULK INSERT [stg].[ITEM_CAT]
FROM '/items_cat_1.csv'
with(
    format = 'csv',
    firstrow = 2,
    fieldterminator = ';',
    rowterminator = '0x0a'
)

go

-- select * from [stg].[ITEM_CAT]

