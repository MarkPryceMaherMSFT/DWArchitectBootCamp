
CREATE MASTER KEY
GO

CREATE DATABASE SCOPED CREDENTIAL storage_cred
WITH IDENTITY = 'mas',
SECRET = 'vkMnoFXwWXfGik/bw03Otx6oS9aHzjyBx6QKeQmyyKvM3TgEihyeFg6tm7PuFUSyJaIBhSpwBPmn6AzjJSFSXQ=='
GO

-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=azure-sqldw-latest
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-table-as-select-transact-sql?view=azure-sqldw-latest

CREATE EXTERNAL DATA SOURCE enterprise_adls
WITH 
(
TYPE = HADOOP, 
LOCATION = N'abfss://csafs@csatraining.dfs.core.windows.net/',
CREDENTIAL = storage_cred
)
GO


CREATE EXTERNAL FILE FORMAT TextFileFormat_CSAtraining
WITH 
(   
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (   
        FIELD_TERMINATOR = '|'
    )
)
GO

CREATE EXTERNAL FILE FORMAT [Parquet] WITH (FORMAT_TYPE = PARQUET);


CREATE EXTERNAL FILE FORMAT [compressed_TextFileFormat] WITH 
(FORMAT_TYPE = DELIMITEDTEXT, FORMAT_OPTIONS (FIELD_TERMINATOR = N'|', 
USE_TYPE_DEFAULT = False), DATA_COMPRESSION = N'org.apache.hadoop.io.compress.GzipCodec')
GO


CREATE SCHEMA staging;
GO


CREATE EXTERNAL TABLE [staging].[FactInternetSales_text]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH (
DATA_SOURCE = [enterprise_adls],
LOCATION = N'/loading/FactInternetSales/text',
FILE_FORMAT = [TextFileFormat_CSAtraining],
REJECT_TYPE = VALUE,
REJECT_VALUE = 0)


CREATE EXTERNAL TABLE [staging].[FactInternetSales_parquet]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH (
DATA_SOURCE = [enterprise_adls],
LOCATION = N'/loading/FactInternetSales/parquet',
FILE_FORMAT = [parquet],
REJECT_TYPE = VALUE,
REJECT_VALUE = 0)


--DROP  EXTERNAL TABLE [staging].[FactInternetSales_compressed_text]
CREATE EXTERNAL TABLE [staging].[FactInternetSales_compressed_text]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH (
DATA_SOURCE = [enterprise_adls],
LOCATION = N'/loading/FactInternetSales/text_compressed',
FILE_FORMAT = compressed_TextFileFormat,
REJECT_TYPE = VALUE,
REJECT_VALUE = 0)




--DROP  EXTERNAL TABLE [staging].[FactInternetSales_compressed_text]
CREATE EXTERNAL TABLE  [staging].[FactInternetSales_single_compressed_text]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH (
DATA_SOURCE = [enterprise_adls],
LOCATION = N'/loading/FactInternetSales/singe_text_compressed',
FILE_FORMAT = compressed_TextFileFormat,
REJECT_TYPE = VALUE,
REJECT_VALUE = 0)


CREATE EXTERNAL TABLE [staging].[FactInternetSales_single_text]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH (
DATA_SOURCE = [enterprise_adls],
LOCATION = N'/loading/FactInternetSales/text_single_file',
FILE_FORMAT = [TextFileFormat_CSAtraining],
REJECT_TYPE = VALUE,
REJECT_VALUE = 0)


-- 20 seconds
select count_big(*) from [staging].[FactInternetSales_text]

-- 8 seconds
select count_big(*) from [staging].[FactInternetSales_parquet]

-- 8 seconds
select count_big(*) from [staging].[FactInternetSales_compressed_text]

select count_big(*) from [staging].[FactInternetSales_single_compressed_text];

select count_big(*) from [staging].[FactInternetSales_single_text]



