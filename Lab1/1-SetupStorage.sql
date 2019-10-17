
CREATE MASTER KEY
GO

CREATE DATABASE SCOPED CREDENTIAL storage_cred
WITH IDENTITY = 'mas',
SECRET = 'vkMnoFXwWXfGik/bw03Otx6oS9aHzjyBx6QKeQmyyKvM3TgEihyeFg6tm7PuFUSyJaIBhSpwBPmn6AzjJSFSXQ=='
GO


CREATE EXTERNAL DATA SOURCE enterprise_adls
WITH 
(
TYPE = HADOOP, 
LOCATION = N'abfss://csafs@csatraining.dfs.core.windows.net/',
CREDENTIAL = storage_cred
)
GO
