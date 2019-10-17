

-- DMV's
-- requests
SELECT top 20 s.* 
FROM 
sys.dm_pdw_exec_requests r 
JOIN
Sys.dm_pdw_request_steps s
ON r.request_id = s.request_id
--WHERE r.[label] = 'STG_text_load'

SELECT [ReplicatedTable] = t.[name],c.[state] 
  FROM sys.tables t  
  JOIN sys.pdw_replicated_table_cache_state c  
    ON c.object_id = t.object_id 
  JOIN sys.pdw_table_distribution_properties p 
    ON p.object_id = t.object_id 
  WHERE --c.[state] = 'NotReady'
    --AND
	p.[distribution_policy_desc] = 'REPLICATE'


-- movement
SELECT ew.* 
FROM[sys].[dm_pdw_dms_external_work] ew 
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = ew.request_id
JOIN Sys.dm_pdw_request_steps s
ON r.request_id = s.request_id
--WHERE r.[label] = 'STG_text_load'


SELECT AVG(total_elapsed_time) AS [avg_loadTime_ms], [label]
FROM sys.dm_pdw_exec_requests 
WHERE [label] IS NOT NULL 
AND [label] <> 'System' 
AND Status = 'Completed'
GROUP BY [label]


SELECT *
FROM    sys.dm_pdw_exec_requests
WHERE [status] in ('Running', 'Suspended')

Select * 
FROM sys.dm_pdw_dms_workers dw
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = dw.request_id
--WHERE r.[label] = 'STG_Hash_ProductKey'



/*
select top 20 * from sys.dm_pdw_exec_requests order by submit_time desc;
	
select top 20 * from sys.dm_pdw_request_steps

select top 20 * from sys.dm_pdw_dms_workers
	
select top 20 * from sys.dm_pdw_waits

select top 20 * from sys.dm_pdw_sql_requests order by [start_time] desc;

*/
