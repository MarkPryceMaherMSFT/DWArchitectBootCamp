/*
ALTER DATABASE AdventureWorksDW SET QUERY_STORE = ON; 
ALTER DATABASE AdventureWorksDW SET RESULT_SET_CACHING ON;

SELECT name, is_result_set_caching_on, *
FROM sys.databases;
*/
-- query Store queries
SELECT
     q.query_id
     , t.query_sql_text, *
FROM
     sys.query_store_query q
     JOIN sys.query_store_query_text t ON q.query_text_id = t.query_text_id;

SELECT TOP 10
       q.query_id                    [query_id]
       , t.query_sql_text            [command]
       , SUM(rs.count_executions)    [execution_count]
FROM
       sys.query_store_query q
       JOIN sys.query_store_query_text t ON q.query_text_id = t.query_text_id
       JOIN sys.query_store_plan p ON p.query_id = q.query_id
       JOIN sys.query_store_runtime_stats rs ON rs.plan_id = p.plan_id
GROUP BY
       q.query_id , t.query_sql_text ORDER BY 3 DESC;


SELECT
       q.query_id               [query_id]
       , t.query_sql_text       [command]
       , rs.avg_duration        [avg_duration]
       , rs.min_duration        [min_duration]
       , rs.max_duration        [max_duration]
FROM
       sys.query_store_query q
       JOIN sys.query_store_query_text t ON q.query_text_id = t.query_text_id
       JOIN sys.query_store_plan p ON p.query_id = q.query_id
       JOIN sys.query_store_runtime_stats rs ON rs.plan_id = p.plan_id
WHERE
       q.query_id = 10
       AND rs.avg_duration > 0;



