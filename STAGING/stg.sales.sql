use dw_future_sales
go

drop table [stg].[SALES]

CREATE TABLE [stg].[SALES](
    date DATE,
    date_block_num nvarchar(250),
    shop_id int,
    item_id int,
    item_price float,
    item_cnt_day float,
)

BULK INSERT [stg].[SALES]
FROM '/sales1.csv'
with(
    format = 'csv',
    firstrow = 2,
    fieldterminator = ';',
    rowterminator = '0x0a'
)

select * from [stg].[SALES]
go


