-- dwu100c 
-- drop table [staging].[STG_text_load]
-- dwu100c -  5 mins 27 seconds
-- dwu1000c - 44 seconds seconds
CREATE TABLE [staging].[STG_text_load]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
HEAP
)
AS 
SELECT * FROM [staging].[FactInternetSales_text] option(label = 'STG_text_load')

/* drop  TABLE [staging].[#temp_STG_text_load]
-- DWU100c - 5 min 51 secs
-- DWU1000c - 49 seconds
CREATE TABLE [staging].[#temp_STG_text_load]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
HEAP
)
AS 
SELECT * FROM [staging].[FactInternetSales_text] option(label = 'STG_text_load_temp')
*/

-- drop TABLE [staging].[STG_parquet_load]
-- DWU1000c - 81 seconds
CREATE TABLE [staging].[STG_parquet_load]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
HEAP
)
AS
SELECT *  
FROM [staging].[FactInternetSales_parquet]
OPTION (label = 'STG_parquet_load')
GO

-- drop table [staging].[STG_compressed_text_load]
-- 5 min 19
CREATE TABLE [staging].[STG_compressed_text_load]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
HEAP
)
AS
SELECT *  
FROM [staging].[FactInternetSales_compressed_text]
OPTION (label = 'STG_compressed_load')

CREATE TABLE [staging].[STG_CompressedText_single_file]
WITH 
(
DISTRIBUTION = ROUND_ROBIN, HEAP
)
AS 
SELECT *
FROM [staging].[FactInternetSales_single_compressed_text] 
OPTION(label = 'STG_single_compressed_load')
GO

CREATE TABLE [staging].[STG_Hash_ProductKey]
WITH
(
DISTRIBUTION = HASH(ProductKey),
HEAP
)
AS
SELECT *  
FROM [staging].[FactInternetSales_single_compressed_text] 
OPTION (label = 'STG_Hash_ProductKey')

select  ProductKey,count(*) from [staging].[STG_Hash_ProductKey] group by ProductKey
order by count(*) desc;

select min(c),max(c) from (
select  ProductKey,count(*) as c from [staging].[STG_Hash_ProductKey] group by ProductKey ) d;
