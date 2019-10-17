/*
This script walks through:
Table Distributions, 
Indexes, 
Data Movement, 
Gen2 Cache,
and impact to queries.

*/

-- DROP TABLE Hash_example
CREATE TABLE Hash_example
(
Hash_Column INT NOT NULL
)
WITH
(
DISTRIBUTION = HASH(Hash_Column),
HEAP
)

-- Insert two records with same value 
INSERT INTO Hash_example VALUES (1)
INSERT INTO Hash_example VALUES (1)


-- Find where rows landed
SELECT tb.Name,  
       tb.object_id,
	   np.pdw_node_id,
	   np.distribution_id,
	   np.index_id,
	   np.partition_number, 
	   np.rows,
	   distribution_policy_desc
	   
FROM    sys.[schemas] sm
JOIN    sys.[tables] tb                            ON  sm.[schema_id]          = tb.[schema_id]
JOIN    sys.[pdw_table_distribution_properties] dp ON  tb.[object_id]           = dp.[object_id]
JOIN    sys.[pdw_table_mappings] mp                ON  tb.[object_id]          = mp.[object_id]
JOIN    sys.[pdw_nodes_tables] nt                  ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[pdw_nodes_partitions] np              ON  np.[object_id]          = nt.[object_id]
                                                   AND np.[pdw_node_id]        = nt.[pdw_node_id]
                                                   AND np.[distribution_id]    = nt.[distribution_id]
WHERE tb.Name = 'Hash_example' --Table Name
ORDER BY distribution_id


-----------------------------------------------------------------------------------------------------------
-- INNER JOIN on Distributed Column
SELECT * FROM Hash_example h1
INNER JOIN Hash_example h2 
ON h1.Hash_Column = h2.Hash_Column 
OPTION(label = 'Hash_inner_Join')


-----------------------------------------------------------------------------------------------------------
-- INTRO to DMVs

--
SELECT * FROM sys.dm_pdw_exec_requests where [label] = 'Hash_inner_Join'

SELECT * FROM sys.dm_pdw_request_steps where request_id = 'QID921333'


-- Insert record with different value. 
INSERT INTO Hash_example values (2)

-- Should land in different distribution 
SELECT tb.Name,  
       tb.object_id,
	   np.pdw_node_id,
	   np.distribution_id,
	   np.index_id,
	   np.partition_number, 
	   np.rows,
	   distribution_policy_desc
	   
FROM    sys.[schemas] sm
JOIN    sys.[tables] tb                            ON  sm.[schema_id]          = tb.[schema_id]
JOIN    sys.[pdw_table_distribution_properties] dp ON  tb.[object_id]           = dp.[object_id]
JOIN    sys.[pdw_table_mappings] mp                ON  tb.[object_id]          = mp.[object_id]
JOIN    sys.[pdw_nodes_tables] nt                  ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[pdw_nodes_partitions] np              ON  np.[object_id]          = nt.[object_id]
                                                   AND np.[pdw_node_id]        = nt.[pdw_node_id]
                                                   AND np.[distribution_id]    = nt.[distribution_id]
WHERE tb.Name = 'Hash_example' --Table Name
ORDER BY distribution_id


-- Let's create another table
-- DROP Table Hash_example_two

Create Table Hash_example_two
(
Hash_Column_two SMALLINT NOT NULL
)
WITH
(
DISTRIBUTION = HASH(Hash_Column_two),
HEAP
)

INSERT INTO Hash_example_two VALUES (1)

SELECT * FROM Hash_example h1
INNER JOIN Hash_example_two h2 
ON h1.Hash_Column = h2.Hash_Column_two OPTION(label = 'HashJoin')

-- INTRO to DMVs
SELECT * FROM sys.dm_pdw_exec_requests WHERE [label] = 'HashJoin'
SELECT * FROM sys.dm_pdw_request_steps where request_id = 'QID921357'

-- What was different and why? 


-- Let's add 60 records.
DECLARE @i INT = 0 
WHILE @i < 60
BEGIN 
	INSERT INTO Hash_example VALUES (@i)
	SET @i = @i +1 
END

-- What about now? All distributions must have more than 1 record right?

SELECT tb.Name,  
       tb.object_id,
	   np.pdw_node_id,
	   np.distribution_id,
	   np.index_id,
	   np.partition_number, 
	   np.rows,
	   distribution_policy_desc
	   
FROM    sys.[schemas] sm
JOIN    sys.[tables] tb                            ON  sm.[schema_id]          = tb.[schema_id]
JOIN    sys.[pdw_table_distribution_properties] dp ON  tb.[object_id]           = dp.[object_id]
JOIN    sys.[pdw_table_mappings] mp                ON  tb.[object_id]          = mp.[object_id]
JOIN    sys.[pdw_nodes_tables] nt                  ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[pdw_nodes_partitions] np              ON  np.[object_id]          = nt.[object_id]
                                                   AND np.[pdw_node_id]        = nt.[pdw_node_id]
                                                   AND np.[distribution_id]    = nt.[distribution_id]
WHERE tb.Name = 'Hash_example' --Table Name
ORDER BY distribution_id

-- Not exactly
-- How hashing works 
-- Cardinality impact https://en.wikipedia.org/wiki/Cardinality_(SQL_statements)

DECLARE @i INT = 60 
WHILE @i <= 200
BEGIN 
	INSERT INTO Hash_example VALUES (@i)
	SET @i = @i +1 
END


SELECT tb.Name,  
       tb.object_id,
	   np.pdw_node_id,
	   np.distribution_id,
	   np.index_id,
	   np.partition_number, 
	   np.rows,
	   distribution_policy_desc
	   
FROM    sys.[schemas] sm
JOIN    sys.[tables] tb                            ON  sm.[schema_id]          = tb.[schema_id]
JOIN    sys.[pdw_table_distribution_properties] dp ON  tb.[object_id]           = dp.[object_id]
JOIN    sys.[pdw_table_mappings] mp                ON  tb.[object_id]          = mp.[object_id]
JOIN    sys.[pdw_nodes_tables] nt                  ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[pdw_nodes_partitions] np              ON  np.[object_id]          = nt.[object_id]
                                                   AND np.[pdw_node_id]        = nt.[pdw_node_id]
                                                   AND np.[distribution_id]    = nt.[distribution_id]
WHERE tb.Name = 'Hash_example' --Table Name
ORDER BY rows desc



DECLARE @i INT = 201
WHILE @i <= 500
BEGIN 
	INSERT INTO Hash_example VALUES (@i)
	SET @i = @i +1 
END


SELECT tb.Name,  
       tb.object_id,
	   np.pdw_node_id,
	   np.distribution_id,
	   np.index_id,
	   np.partition_number, 
	   np.rows,
	   distribution_policy_desc
	   
FROM    sys.[schemas] sm
JOIN    sys.[tables] tb                            ON  sm.[schema_id]          = tb.[schema_id]
JOIN    sys.[pdw_table_distribution_properties] dp ON  tb.[object_id]           = dp.[object_id]
JOIN    sys.[pdw_table_mappings] mp                ON  tb.[object_id]          = mp.[object_id]
JOIN    sys.[pdw_nodes_tables] nt                  ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[pdw_nodes_partitions] np              ON  np.[object_id]          = nt.[object_id]
                                                   AND np.[pdw_node_id]        = nt.[pdw_node_id]
                                                   AND np.[distribution_id]    = nt.[distribution_id]
WHERE tb.Name = 'Hash_example' --Table Name
ORDER BY rows



DECLARE @i INT = 501
WHILE @i <= 1000
BEGIN 
	INSERT INTO Hash_example VALUES (@i)
	SET @i = @i +1 
END

SELECT tb.Name,  
       tb.object_id,
	   np.pdw_node_id,
	   np.distribution_id,
	   np.index_id,
	   np.partition_number, 
	   np.rows,
	   distribution_policy_desc
	   
FROM    sys.[schemas] sm
JOIN    sys.[tables] tb                            ON  sm.[schema_id]          = tb.[schema_id]
JOIN    sys.[pdw_table_distribution_properties] dp ON  tb.[object_id]           = dp.[object_id]
JOIN    sys.[pdw_table_mappings] mp                ON  tb.[object_id]          = mp.[object_id]
JOIN    sys.[pdw_nodes_tables] nt                  ON  nt.[name]               = mp.[physical_name]
JOIN    sys.[pdw_nodes_partitions] np              ON  np.[object_id]          = nt.[object_id]
                                                   AND np.[pdw_node_id]        = nt.[pdw_node_id]
                                                   AND np.[distribution_id]    = nt.[distribution_id]
WHERE tb.Name = 'Hash_example' --Table Name
ORDER BY distribution_id

SELECT * FROM Hash_example h1
INNER JOIN Hash_example h2 
ON h1.Hash_Column = h2.Hash_Column OPTION(label = 'Hash_inner_Join')

-- INTRO to DMVs
Select * FROM sys.dm_pdw_exec_requests where [label] = 'Hash_inner_Join'

SELECT * FROM sys.dm_pdw_request_steps where request_id = 'QID920647'


DECLARE @i smallint = 2
While @i < 1000
BEGIN 
	INSERT INTO Hash_example_two values (@i)
	set @i = @i +1 
END



SELECT * FROM Hash_example h1
INNER JOIN Hash_example_two h2 
ON h1.Hash_Column = h2.Hash_Column_two option(label = 'HashJoin_1000')

-- INTRO to DMVs
Select * FROM sys.dm_pdw_exec_requests where [label] = 'HashJoin_1000'
SELECT * FROM sys.dm_pdw_request_steps where request_id = ''




-- REAL WORLD Examples

SELECT COUNT_BIG(*) as [Dimension Row Count] FROM [Dimension].[CityRR]
SELECT COUNT_BIG(*) as [Fact Row Count] FROM [Fact].[Sales]


SELECT SUM(profit), [Salesperson key] 
FROM [Fact].[Sales]  F 
LEFT JOIN [Dimension].[CityRR] D 
ON F.[City Key] = D.[City Key]
WHERE 

City = 'Dry Run' and 
[State Province] = 'Pennsylvania' 
and [invoice date key] >= '2017-12-01' and [invoice date key] <= '2017-12-31'
GROUP BY [Salesperson key]
OPTION(label = 'Realquery')

Select * FROM sys.dm_pdw_exec_requests where [label] = 'Realquery'
SELECT * FROM sys.dm_pdw_request_steps where request_id = ''

-- Same query, but Dimension is replicated
-- What do we expect to happen??
SELECT SUM(profit), [Salesperson key] 
FROM [Fact].[Sales]  F 
LEFT JOIN [Dimension].[City] D 
ON F.[City Key] = D.[City Key]
WHERE 
City = 'Dry Run' and 
[State Province] = 'Pennsylvania' 
and [invoice date key] >= '2017-12-01' and [invoice date key] <= '2017-12-31'
GROUP BY [Salesperson key]
OPTION(label = 'Realquery_replicate')

Select * FROM sys.dm_pdw_exec_requests where [label] = 'Realquery_replicate'
SELECT * FROM sys.dm_pdw_request_steps where request_id = ''



-- Gen 2 cache?
DBCC DROPCLEANBUFFERS (ALL)
SELECT SUM(profit), [Salesperson key] FROM [Fact].[Sales]  F 
LEFT JOIN [Dimension].[CityRR] D 
on F.[City Key] = D.[City Key]
WHERE 
City = 'Dry Run' and 
[State Province] = 'Pennsylvania' 
and [invoice date key] >= '2017-12-01' and [invoice date key] <= '2017-12-31'
GROUP BY [Salesperson key]
OPTION( label = 'Realquery')