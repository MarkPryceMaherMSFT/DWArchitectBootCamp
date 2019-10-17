
-- STG_text_load
SELECT s.* 
FROM 
sys.dm_pdw_exec_requests r 
JOIN
Sys.dm_pdw_request_steps s
ON r.request_id = s.request_id
WHERE r.[label] = 'STG_text_load'

SELECT ew.* 
FROM[sys].[dm_pdw_dms_external_work] ew 
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = ew.request_id
JOIN Sys.dm_pdw_request_steps s
ON r.request_id = s.request_id
WHERE r.[label] = 'STG_text_load'
ORDER BY input_name, read_location


---STG_parquet_load
SELECT DISTINCT ew.* 
FROM[sys].[dm_pdw_dms_external_work] ew 
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = ew.request_id
JOIN Sys.dm_pdw_request_steps s
ON r.request_id = s.request_id
WHERE r.[label] = 'STG_parquet_load'
ORDER BY  start_time ASC, dms_step_index


SELECT AVG(total_elapsed_time) AS [avg_loadTime_ms], [label]
FROM sys.dm_pdw_exec_requests 
WHERE [label] IS NOT NULL 
AND [label] <> 'System' 
AND Status = 'Completed'
GROUP BY [label]


Select * 
FROM sys.dm_pdw_dms_workers dw
JOIN sys.dm_pdw_exec_requests r 
ON r.request_id = dw.request_id
WHERE r.[label] = 'STG_Hash_ProductKey'












