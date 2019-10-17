--CREATE EXTERNAL FILE FORMAT [Parquet] WITH (FORMAT_TYPE = PARQUET)
/*CREATE EXTERNAL FILE FORMAT compressed_TextFileFormat
WITH 
(   
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (   
        FIELD_TERMINATOR = '|'
    ), DATA_COMPRESSION = N'org.apache.hadoop.io.compress.GzipCodec'
)
GO
*/

select count_big(*) from   dbo.FactInternetSales_big;;


-- 42 seconds
CREATE EXTERNAL TABLE FactInternetSales_text  
WITH (  
        LOCATION='/loading/FactInternetSales/text_compressed',  
        DATA_SOURCE = [enterprise_adls],  
        FILE_FORMAT = compressed_TextFileFormat
) AS SELECT * FROM dbo.FactInternetSales_big; 


--drop EXTERNAL TABLE FactInternetSales_text  
-- 39 seconds
CREATE EXTERNAL TABLE FactInternetSales_text  
WITH (  
        LOCATION='/loading/FactInternetSales/text',  
        DATA_SOURCE = [enterprise_adls],  
        FILE_FORMAT = [TextFileFormat_CSAtraining]
) AS SELECT * FROM dbo.FactInternetSales_big; 


-- 92 seconds
CREATE EXTERNAL TABLE FactInternetSales_parquet 
WITH (  
        LOCATION='/loading/FactInternetSales/parquet',  
        DATA_SOURCE = [enterprise_adls],  
        FILE_FORMAT = [Parquet]
) AS SELECT * FROM dbo.FactInternetSales_big; 


CREATE EXTERNAL TABLE FactInternetSales_text_single_file  
WITH (  
        LOCATION='/loading/FactInternetSales/text_single_file',  
        DATA_SOURCE = [enterprise_adls],  
        FILE_FORMAT = [TextFileFormat_CSAtraining]
) AS SELECT top 123695104 * FROM dbo.FactInternetSales_big; 


CREATE EXTERNAL TABLE FactInternetSales_compressed 
WITH (  
        LOCATION='/loading/FactInternetSales/singe_text_compressed',  
        DATA_SOURCE = [enterprise_adls],  
        FILE_FORMAT = compressed_TextFileFormat
) AS SELECT top 123695104 * FROM dbo.FactInternetSales_big; 





