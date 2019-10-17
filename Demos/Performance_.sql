/*
https://docs.microsoft.com/en-us/sql/t-sql/queries/explain-transact-sql?view=azure-sqldw-latest
*/
drop VIEW View1;


EXPLAIN WITH_RECOMMENDATIONS 
SELECT  b.[EnglishProductName]
      ,sum(a.SalesAmount) as TotalSalesAmount
  FROM [dbo].[FactInternetSales] a
  join dimproduct_repl b on a.[ProductKey] = b.[ProductKey]
  group by b.[EnglishProductName]
    OPTION (LABEL = 'Perftest-1');

  /*
 <?xml version="1.0" encoding="utf-8"?>  
 <dsql_query number_nodes="2" number_distributions="60" number_distributions_per_node="30">
 <sql>SELECT  b.[EnglishProductName]        ,sum(a.SalesAmount) as TotalSalesAmount    FROM [dbo].[FactInternetSales] a    join dimproduct_repl b on a.[ProductKey] = b.[ProductKey]    group by b.[EnglishProductName]</sql>    
 <materialized_view_candidates>      
 <materialized_view_candidates with_constants="False">
 CREATE MATERIALIZED VIEW View1 WITH (DISTRIBUTION = HASH([Expr0])) AS  SELECT [b].[EnglishProductName] AS [Expr0],         SUM([a].[SalesAmount]) AS [Expr1]  FROM [dbo].[FactInternetSales],       [dbo].[dimproduct_repl]  WHERE [b].[ProductKey]=[a].[ProductKey]  GROUP BY [b].[EnglishProductName]
 </materialized_view_candidates>    </materialized_view_candidates>
 <dsql_operations total_cost="0" total_number_operations="9">      <dsql_operation operation_type="RND_ID">        <identifier>TEMP_ID_56</identifier>      </dsql_operation>      <dsql_operation operation_type="ON">        <location permanent="false" distribution="AllDistributions" />        <sql_operations>          <sql_operation type="statement">CREATE TABLE [qtabledb].[dbo].[TEMP_ID_56] ([ProductKey] INT NOT NULL, [EnglishProductName] NVARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ) WITH(DISTRIBUTED_MOVE_FILE='');</sql_operation>        </sql_operations>      </dsql_operation>      <dsql_operation operation_type="SHUFFLE_MOVE">        <operation_cost cost="0.102663996816" accumulative_cost="0.102663996816" average_rowsize="42.353134" output_rows="303" GroupNumber="4" />        <source_statement>SELECT [T1_1].[ProductKey] AS [ProductKey], [T1_1].[EnglishProductName] AS [EnglishProductName] FROM [AdventureWorksDW].[dbo].[dimproduct_repl] AS T1_1  OPTION (MAXDOP 2, MIN_GRANT_PERCENT = 25, DISTRIBUTED_MOVE(N''))</source_statement>        <destination_table>[TEMP_ID_56]</destination_table>        <shuffle_columns>ProductKey;</shuffle_columns>      </dsql_operation>      <dsql_operation operation_type="RND_ID">        <identifier>TEMP_ID_57</identifier>      </dsql_operation>      <dsql_operation operation_type="ON">        <location permanent="false" distribution="AllDistributions" />        <sql_operations>          <sql_operation type="statement">CREATE TABLE [qtabledb].[dbo].[TEMP_ID_57] ([EnglishProductName] NVARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, [col] MONEY NOT NULL ) WITH(DISTRIBUTED_MOVE_FILE='');</sql_operation>        </sql_operations>      </dsql_operation>      <dsql_operation operation_type="SHUFFLE_MOVE">        <operation_cost cost="0.027909778219008" accumulative_cost="0.130573775035008" average_rowsize="46.353134" output_rows="75.264" GroupNumber="13" />        <source_statement>SELECT [T1_1].[EnglishProductName] AS [EnglishProductName], [T1_1].[col] AS [col] FROM (SELECT SUM([T2_2].[SalesAmount]) AS [col], [T2_1].[EnglishProductName] AS [EnglishProductName] FROM [qtabledb].[dbo].[TEMP_ID_56] AS T2_1 INNER JOIN  [AdventureWorksDW].[dbo].[FactInternetSales] AS T2_2  ON ([T2_1].[ProductKey] = [T2_2].[ProductKey]) GROUP BY [T2_1].[EnglishProductName]) AS T1_1  OPTION (MAXDOP 2, MIN_GRANT_PERCENT = 25, DISTRIBUTED_MOVE(N''))</source_statement>        <destination_table>[TEMP_ID_57]</destination_table>        <shuffle_columns>EnglishProductName;</shuffle_columns>      </dsql_operation>      <dsql_operation operation_type="RETURN">        <location distribution="AllDistributions" />        <select>SELECT [T1_1].[EnglishProductName] AS [EnglishProductName], [T1_1].[col] AS [col] FROM (SELECT SUM([T2_1].[col]) AS [col], [T2_1].[EnglishProductName] AS [EnglishProductName] FROM [qtabledb].[dbo].[TEMP_ID_57] AS T2_1 GROUP BY [T2_1].[EnglishProductName]) AS T1_1  OPTION (MAXDOP 2, MIN_GRANT_PERCENT = 25)</select>      </dsql_operation>      <dsql_operation operation_type="ON">        <location permanent="false" distribution="AllDistributions" />        <sql_operations>          <sql_operation type="statement">DROP TABLE [qtabledb].[dbo].[TEMP_ID_57]</sql_operation>        </sql_operations>      </dsql_operation>      <dsql_operation operation_type="ON">        <location permanent="false" distribution="AllDistributions" />        <sql_operations>          <sql_operation type="statement">DROP TABLE [qtabledb].[dbo].[TEMP_ID_56]</sql_operation>        </sql_operations>      </dsql_operation>    </dsql_operations>  </dsql_query>  */
 
 */

 /*

 DOH! Doesnt work!!!

 CREATE MATERIALIZED VIEW View1 WITH (DISTRIBUTION = HASH([Expr0])) AS  
 SELECT [b].[EnglishProductName] AS [Expr0],        
 SUM([a].[SalesAmount]) AS [Expr1]  FROM [dbo].[FactInternetSales],    
 [dbo].[dimproduct_repl]  WHERE [b].[ProductKey]=[a].[ProductKey]  
 GROUP BY [b].[EnglishProductName]


 CREATE MATERIALIZED VIEW View1 WITH (DISTRIBUTION = HASH([Expr0])) AS  
 SELECT [b].[EnglishProductName] AS [Expr0],        
 SUM([a].[SalesAmount]) AS [Expr1]  FROM [dbo].[FactInternetSales] a,    
 [dbo].[dimproduct_repl] b WHERE [b].[ProductKey]=[a].[ProductKey]  
 GROUP BY [b].[EnglishProductName]


 */
 
 EXPLAIN
SELECT  b.[EnglishProductName]
      ,sum(a.SalesAmount) as TotalSalesAmount
  FROM [dbo].[FactInternetSales] a
  join dimproduct_repl b on a.[ProductKey] = b.[ProductKey]
  group by b.[EnglishProductName]
  OPTION (LABEL = 'Perftest-2')


  select b.[EnglishProductName]
      ,sum(a.SalesAmount) as TotalSalesAmount
	  from [dbo].[dimproduct_roundrobin] b
join [dbo].[FactInternetSales_roundrobin] a on a.[ProductKey] = b.[ProductKey]
group by b.[EnglishProductName]
OPTION (label = 'Perftest-3')	


  /*
  In previous explain plan, there is a shuffle move. 
  Look at visual plan

  <?xml version="1.0" encoding="utf-8"?>  
  <dsql_query number_nodes="2" number_distributions="60" number_distributions_per_node="30">    <sql>SELECT  b.[EnglishProductName]        ,sum(a.SalesAmount) as TotalSalesAmount    FROM [dbo].[FactInternetSales] a    join dimproduct_repl b on a.[ProductKey] = b.[ProductKey]    group by b.[EnglishProductName]    OPTION (LABEL = 'Perftest-1')</sql>    <dsql_operations total_cost="0" total_number_operations="1">      <dsql_operation operation_type="RETURN">
  <location distribution="AllDistributions" />        <select>SELECT [T1_1].[EnglishProductName] AS [EnglishProductName], [T1_1].[col] AS [col] FROM (SELECT [T2_1].[EnglishProductName] AS [EnglishProductName], [T2_1].[col1] AS [col] FROM (SELECT ISNULL([T3_1].[col1], CONVERT (BIGINT, 0, 0)) AS [col], [T3_1].[EnglishProductName] AS [EnglishProductName], [T3_1].[col] AS [col1] FROM (SELECT SUM([T4_1].[TotalSalesAmount]) AS [col], SUM([T4_1].[cb]) AS [col1], [T4_1].[EnglishProductName] AS [EnglishProductName] FROM (SELECT [T5_1].[EnglishProductName] AS [EnglishProductName], [T5_1].[TotalSalesAmount] AS [TotalSalesAmount], [T5_1].[cb] AS [cb] FROM [AdventureWorksDW].[dbo].[View1] AS T5_1) AS T4_1 GROUP BY [T4_1].[EnglishProductName]) AS T3_1) AS T2_1 WHERE ([T2_1].[col] != CAST ((0) AS BIGINT))) AS T1_1  OPTION (MAXDOP 2)</select>      </dsql_operation>    </dsql_operations>  </dsql_query>
  */



SELECT [label],*
FROM    sys.dm_pdw_exec_requests
WHERE [label] like 'Perftest%';

SELECT * FROM sys.dm_pdw_request_steps
WHERE request_id = 'QID22324'
ORDER BY step_index;

SELECT * FROM sys.dm_pdw_sql_requests
WHERE request_id = 'QID22324' AND step_index = 9;


-- check for replicated tables.
SELECT *
FROM    sys.dm_pdw_exec_requests
WHERE command like 'BuildReplicatedTableCache%';

SELECT *
FROM    sys.dm_pdw_exec_requests
WHERE [label] = 'ReplicatedTableQuery';



