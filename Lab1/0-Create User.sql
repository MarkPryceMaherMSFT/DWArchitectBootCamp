Create Login usgsloader with PASSWORD = 'Password!1234'

Create user usgsloader from login usgsloader
EXEC sp_addrolemember 'staticrc60', 'usgsloader'
EXEC sp_addrolemember 'db_ddladmin', 'usgsloader'
EXEC sp_addrolemember 'db_datawriter', 'usgsloader'
EXEC sp_addrolemember 'db_datareader', 'usgsloader'
