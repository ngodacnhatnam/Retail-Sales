USE dw_future_sales
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INIT_FACT_SALES_DAILY]

AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;
------------------------------------------------------------------------------------
-- Bat dau Transaction
BEGIN TRAN;
BEGIN TRY;

IF EXISTS(SELECT * FROM sys.tables WHERE SCHEMA_NAME(schema_id) LIKE 'dbo' AND name like 'FACT_SALES_DAILY')
   DROP TABLE dw_future_sales.dbo.FACT_SALES_DAILY

CREATE TABLE dw_future_sales.dbo.FACT_SALES_DAILY (
	DATE_KEY BIGINT, -- DIM_DATE
    ITEM_CATEGORY_KEY INT,
    ITEM_KEY INT,
	SHOP_KEY INT,
    QUANTITY INT,
    SALE_AMOUNT DECIMAL(18,2),
)
ALTER TABLE dbo.FACT_SALES_DAILY
ADD CONSTRAINT FK_DATE_KEY_DAILY FOREIGN KEY (DATE_KEY) REFERENCES DIM_DATE(DATE_KEY);
ALTER TABLE dbo.FACT_SALES_DAILY
ADD CONSTRAINT FK_ITEM_CATEGORY_KEY_DAILY FOREIGN KEY (ITEM_CATEGORY_KEY) REFERENCES DIM_ITEMS_CAT(ITEM_CATEGORY_KEY);
ALTER TABLE dbo.FACT_SALES_DAILY
ADD CONSTRAINT FK_ITEM_KEY_DAILY FOREIGN KEY (ITEM_KEY) REFERENCES DIM_ITEM(ITEM_KEY);
ALTER TABLE dbo.FACT_SALES_DAILY
ADD CONSTRAINT FK_SHOP_KEY_DAILY FOREIGN KEY (SHOP_KEY) REFERENCES DIM_SHOP(SHOP_KEY)

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

-- Ket thúc Transaction
------------------------------------------------------------------------------------
END

-- EXEC [dbo].[SP_INIT_FACT_SALES_DAILY]
-- GO


-- drop PROCEDURE [dbo].[SP_INIT_FACT_SALES_DAILY]
-- drop table FACT_SALES_DAILY
