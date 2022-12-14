use dw_future_sales
Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [dbo].[SP_FLOAD_FACT_SALES_DAILY]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;
------------------------------------------------------------------------------------
-- Bat dau Transaction
BEGIN TRAN;
BEGIN TRY;

TRUNCATE TABLE dw_future_sales.dbo.FACT_SALES_DAILY;

INSERT INTO dw_future_sales.dbo.FACT_SALES_DAILY(DATE_KEY,ITEM_CATEGORY_KEY,ITEM_KEY,SHOP_KEY,QUANTITY,SALE_AMOUNT)
	SELECT DATE_KEY,ITEM_CATEGORY_KEY,ITEM_KEY, SHOP_KEY,

	SUM(QUANTITY) AS QUANTITY,
	SUM(SALE_AMOUNT) AS SALE_AMOUNT
	FROM dbo.FACT_SALES f
	GROUP BY DATE_KEY, ITEM_CATEGORY_KEY,ITEM_KEY, SHOP_KEY

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

-- K?t thúc Transaction
------------------------------------------------------------------------------------
END

-- EXEC [dbo].[SP_FLOAD_FACT_SALES_DAILY]
-- GO

-- select top 3 * from FACT_SALES_DAILY
