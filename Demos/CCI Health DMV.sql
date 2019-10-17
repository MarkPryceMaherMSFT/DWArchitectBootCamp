 -- CCI Health
 Select
 database_name,
 schema_name,
 table_name,
 table_partition_count,
 row_count_total,
 row_count_per_distribution_MAX,
 rowgroup_per_distribution_MAX,
 OPEN_rowgroup_count,
 OPEN_rowgroup_rows,
 OPEN_rowgroup_rows_MIN,
 OPEN_rowgroup_rows_MAX,
 OPEN_rowgroup_rows_AVG,
 COMPRESSED_Rowgroup_rows_Deleted,
 COMPRESSED_rowgroup_count,
 COMPRESSED_rowgroup_rows,
 COMPRESSED_rowgroup_rows_MIN,
 COMPRESSED_rowgroup_rows_MAX,
 COMPRESSED_rowgroup_rows_AVG
 ,  table_check =
	CASE
		WHEN row_count_per_distribution_MAX < 50000 then '1'
		-- If table is evenly distributed and there are less than 100K rows per distribution (CCI rowgroup size). Go to CI
		WHEN [table_partition_count] > 1 and (OPEN_ROWGROUP_ROWS > (60*1000000) or COMPRESSED_rowgroup_rows_avg <100000) THEN '2'
		-- If a table is partitioned and the system can't compress rowgroups because they are spread too thin or if compressed rowgroup avg is < 10k, then the table is overpartitoned
		WHEN row_count_total > 600000 and COMPRESSED_rowgroup_rows_MAX < 500000 and compressed_rowgroup_count> 60 THEN '3'
		-- If the table is larger than 60 million and compressed rowgroups are smaller than 1/2 million there are by definition 2x the number of row groups than needed.
		WHEN row_count_total > 600000 and  COMPRESSED_Rowgroup_rows_Deleted > COMPRESSED_rowgroup_rows * .05 THEN '3'
		ELSE ''
	END

	/*
	1 - Change Index to CI
	2 - Remove Partitions
	3 - Alter Index Rebuild
	*/
		-- TRIM REASON
 FROM
 -- The query below is input in python model
 (
 SELECT

	   DB_Name()                                                                AS [database_name]
,       s.name                                                                  AS [schema_name]
,       t.name                                                                  AS [table_name]
,       COUNT(DISTINCT rg.[partition_number])                    AS [table_partition_count]
,       SUM(rg.[total_rows])                                                    AS [row_count_total]
,       SUM(rg.[total_rows])/COUNT(DISTINCT rg.[distribution_id])               AS [row_count_per_distribution_MAX]
,       CEILING    ((SUM(rg.[total_rows])*1.0/COUNT(DISTINCT rg.[distribution_id]))/1048576) AS [rowgroup_per_distribution_MAX]
,       SUM(CASE WHEN rg.[State] = 1 THEN 1                   ELSE 0    END)    AS [OPEN_rowgroup_count]
,       SUM(CASE WHEN rg.[State] = 1 THEN rg.[total_rows]     ELSE 0    END)    AS [OPEN_rowgroup_rows]
,       MIN(CASE WHEN rg.[State] = 1 THEN rg.[total_rows]     ELSE NULL END)    AS [OPEN_rowgroup_rows_MIN]
,       MAX(CASE WHEN rg.[State] = 1 THEN rg.[total_rows]     ELSE NULL END)    AS [OPEN_rowgroup_rows_MAX]
,       AVG(CASE WHEN rg.[State] = 1 THEN rg.[total_rows]     ELSE NULL END)    AS [OPEN_rowgroup_rows_AVG]
,       SUM(CASE WHEN rg.[State] = 3 THEN 1                   ELSE 0    END)    AS [COMPRESSED_rowgroup_count]
,       SUM(CASE WHEN rg.[State] = 3 THEN rg.[total_rows]     ELSE 0    END)    AS [COMPRESSED_rowgroup_rows]
,       SUM(CASE WHEN rg.[State] = 3 THEN rg.[deleted_rows]   ELSE 0    END)    AS [COMPRESSED_rowgroup_rows_DELETED]
,       MIN(CASE WHEN rg.[State] = 3 THEN rg.[total_rows]     ELSE NULL END)    AS [COMPRESSED_rowgroup_rows_MIN]
,       MAX(CASE WHEN rg.[State] = 3 THEN rg.[total_rows]     ELSE NULL END)    AS [COMPRESSED_rowgroup_rows_MAX]
,       AVG(CASE WHEN rg.[State] = 3 THEN rg.[total_rows]     ELSE NULL END)    AS [COMPRESSED_rowgroup_rows_AVG]
--,       'ALTER INDEX ALL ON ' + s.name + '.' + t.NAME + ' REBUILD;'             AS [Rebuild_Index_SQL]
FROM    sys.[pdw_nodes_column_store_row_groups] rg
JOIN    sys.[pdw_nodes_tables] nt                   ON  rg.[object_id]          = nt.[object_id]
                                            --        AND rg.[pdw_node_id]        = nt.[pdw_node_id]
                                                    AND rg.[distribution_id]    = nt.[distribution_id]
JOIN    sys.[pdw_table_mappings] mp                 ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[tables] t                              ON  mp.[object_id]          = t.[object_id]
JOIN    sys.[schemas] s                             ON t.[schema_id]            = s.[schema_id]
GROUP BY
        s.[name]
,       t.[name]
) base
ORDER BY Schema_name


