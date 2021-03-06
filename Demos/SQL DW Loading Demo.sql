/****** Script for SelectTopNRows command from SSMS  ******/

-- Create Base Dimension Table
--DROP TABLE Dim_Person_type_one
CREATE TABLE Dim_Person_type_one
(
    PersonID INT NOT NULL,
    Name VARCHAR(255),
    Age INT
)
WITH 
(
DISTRIBUTION = ROUND_ROBIN,
HEAP
)


-- seed the table with customers
INSERT INTO Dim_Person_type_one
   (PersonID,
	 Name, 
	 Age)
    SELECT 1, 'Casey', 21 UNION ALL
    SELECT 2, 'Amy',   24 UNION ALL
    SELECT 3, 'Kal',   20 UNION ALL
    SELECT 4, 'Kevin', 26 UNION ALL
    SELECT 5, 'Sapna', 22 

-- Create Staging table to mimic incremental load
-- DROP TABLE STG.Dim_Customer
CREATE TABLE [STG].[dim_Customer]
(
PersonID INT NOT NULL,
Name VARCHAR(255) NULL,
Age INT NULL,
SYS_CHANGE_VERSION VARCHAR(100) NULL,
SYS_CHANGE_OPERATION VARCHAR(100) NULL
)
WITH
(
DISTRIBUTION = Round_robin, 
Heap 
)

-- Seed Staging table with an update and an insert
INSERT INTO [STG].[dim_Customer]
(
PersonID,
Name,
Age, 
SYS_CHANGE_VERSION, 
SYS_CHANGE_OPERATION
)
SELECT 1, 'update', 10, 14, 'U' UNION ALL
SELECT 6, 'new', 50, 13, 'I'


-- Existing Dimension Table
SELECT * FROM Dim_Person_type_one order by personId

-- Incremental delta coming in
SELECT TOP (1000) [PersonID]
      ,[Name]
      ,[Age]
      ,[SYS_CHANGE_VERSION]
      ,[SYS_CHANGE_OPERATION]
  FROM [STG].[dim_Customer]


-- CREATE AN UPSERT VERSION
CREATE TABLE dbo.[Dim_Person_upsert]
WITH
(   DISTRIBUTION = ROUND_ROBIN
,   HEAP
)
AS
-- New rows and new versions of rows
SELECT      s.[PersonID]
,           s.[Name]
,           s.[Age]
FROM      [STG].[dim_Customer]
 AS s
UNION ALL  
-- Keep rows that are not being touched
SELECT      p.[PersonID]
,           p.[Name]
,           p.[Age]
FROM      dbo.Dim_Person_type_one  AS p
WHERE NOT EXISTS
(   SELECT  *
    FROM    [STG].[dim_Customer] s
    WHERE   s.[PersonID] = p.[PersonID]
)
;

--Verify the Results
SELECT * FROM Dim_Person_upsert order by PersonId
SELECT * FROM Dim_person_type_one order by PersonId

-- MetaData Rename into production position
RENAME OBJECT dbo.Dim_Person_type_one         TO Dim_Person_type_one_old;
RENAME OBJECT dbo.[Dim_Person_upsert]         TO Dim_Person_type_one;

-- Verify results
SELECT * FROM DIM_PERSON_TYPE_ONE order by personId



-- REVERTING THE SCRIPT 
DROP TABLE Dim_Person_type_one
DROP TABLE [STG].[dim_Customer]
