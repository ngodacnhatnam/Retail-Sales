USE dw_future_sales
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [dbo].[SP_FLOAD_FACT_SALES]
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

	------------------------------------------------------------------------------------
	BEGIN TRAN;
	BEGIN TRY

		TRUNCATE TABLE dbo.FACT_SALES;
		/***----------------------------------------------------------------------------------***/
		;with source AS(
			SELECT s.date, s.shop_id, s.item_id, s.item_price, s.item_cnt_day, ct.ITEM_CATEGORY_ID
			FROM stg.[SALES] s
            JOIN stg.[ITEM] i on i.item_id = s.item_id
            JOIN dbo.DIM_ITEMS_CAT ct on ct.ITEM_CATEGORY_ID = i.item_category_id
		)
        ,fload AS
		(
            SELECT DISTINCT i.ITEM_KEY,s.item_price, s.item_cnt_day, s.item_cnt_day * s.item_price as sale_amount, s.shop_id, ic.ITEM_CATEGORY_KEY, sh.SHOP_KEY, s.[date]
            FROM source s
            LEFT JOIN DIM_ITEM i ON s.item_id = i.ITEM_ID
            LEFT JOIN DIM_SHOP sh on s.shop_id = sh.SHOP_ID
            LEFT JOIN DIM_ITEMS_CAT ic on s.ITEM_CATEGORY_ID = ic.ITEM_CATEGORY_ID
        )

        insert into dbo.FACT_SALES(DATE_KEY,ITEM_CATEGORY_KEY,ITEM_KEY, SHOP_KEY,UNIT_PRICE,QUANTITY,SALE_AMOUNT)
        SELECT DATE_KEY, ITEM_CATEGORY_KEY,ITEM_KEY, SHOP_KEY,
				item_price AS UNIT_PRICE,item_cnt_day AS QUANTITY,sale_amount as SALE_AMOUNT
		FROM fload f
        join DIM_DATE d on d.[DATE] = CAST(f.date as DATE)
		ORDER BY ITEM_CATEGORY_KEY,ITEM_KEY
		------------------------------------------------------------------------------------

	-- COMMIT HANDLE DATA
	COMMIT
	RETURN 0
	END TRY
	BEGIN CATCH
		ROLLBACK
		DECLARE @ERRORMESSAGE NVARCHAR(2000)
		SELECT @ERRORMESSAGE = 'ERROR: ' + ERROR_MESSAGE()
		RAISERROR(@ERRORMESSAGE, 16, 1)

	END CATCH

END

-- EXEC [dbo].[SP_FLOAD_FACT_SALES]
-- GO

select * from fact_sales
