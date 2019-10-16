Azure SQL DW in a Day Lab Introduction

'''Overview'''

In this workshop, you will work on a series of lab modules that teach you best practices for getting the most out of your Azure SQL Data Warehouse. These modules cover the entire lifecycle of data in your Azure SQL Data Warehouse from loading, to securing, querying, and optimizing the data. 



'''Pre-requisites:'''

* Your own Azure Subscription.

Student Machine (latest versions of the tools below) 

* SQL Server Management Studio (SSMS) or Azure Data Studio
* Azure Storage Explorer

'''Lab initialization:'''



# Log into Portal

Create your Azure SQL Data Warehouse. 

[[image:|405x373px]]

Set the Data warehouse name to be ; AdventureWorksDW

Performance Level; DWU100c**



<nowiki>** Y</nowiki>ou could run a faster Azure DW , but you need to be aware of the running costs.

'''<nowiki>** </nowiki>PLEASE Remember to pause the Azure Data Warehouse when you are not using it!!! '''



[[image:|462x307px]]

Use sample database.





# 
# Configure SQL Server Firewall Settings

Click on the SQL Server name 

Click on ‘Show Firewall Settings’ 

Click on ‘Add Client IP’ and click ‘Save’ 

This will add your client IP address to the firewall so you can use client tools on your laptop to access your Azure SQL Server.

# Access Key

We will be using a shared storage account to host the files.

Account name; csatraining

Key:



vkMnoFXwWXfGik/bw03Otx6oS9aHzjyBx6QKeQmyyKvM3TgEihyeFg6tm7PuFUSyJaIBhSpwBPmn6AzjJSFSXQ==



[[image:|624x244px]]



# Open SQL Server Management Studio/Azure Data Studio on your laptop and connect to your SQLDW instance using the credentials provided during creation.



Open a new query window connected to ‘Master’ database (right-click on Master and click ‘New Query’) and execute the following command:

'''''Create Login usgsloader with PASSWORD = 'Password!1234''''''



Open another query window connected to ‘AdventureWorksDW’ and execute the following commands:

'''''Create user usgsloader from login usgsloader'''''

'''''EXEC sp_addrolemember 'staticrc60', 'usgsloader''''''

'''''EXEC sp_addrolemember 'db_ddladmin', 'usgsloader''''''

'''''EXEC sp_addrolemember 'db_datawriter', 'usgsloader''''''

'''''EXEC sp_addrolemember 'db_datareader', 'usgsloader''''''



# Configure Azure Data Warehouse Diagnostics Logs

Logon to Azure Portal (<nowiki>portal.azure.com</nowiki>) using your credentials

Navigate to your Azure Data Warehouse

Click on Diagnostic Settings from the side menu



[[image:|624x330px]]





Click on the “Add diagnostic setting” in the blade

Provide a name for your diagnostics

* Check Send to Log Analytics
* Select all options under LOG

[[image:|460x480px]]



Click Save on Diagnostics settings blade



Click refresh on Diagnostic settings blade to see your new diagnostics

[[image:|534x151px]]





'''Congratulations! You are ready to dive into labs now 😊'''

'''Lab modules:'''

Lab 1: Data Loading Scenarios and Best Practices

* Impact of File Format on Loading
* Impact of Single File Compression
* Impact of Table Distribution
* DMVs to review Load Speeds
* Impact of CTAS vs INSERT INTO SELECT
* COPY Command (out soon)

Lab 2: Performance Tuning Best Practices

* Replicated Table Behavior
* Performance Tuning
* Resource Class Usage
* Result Set Caching

Lab 3: Monitoring, Maintenance and Security

* Resource Monitoring in Azure Monitor
* Azure Data Studio SQLDW Dashboard (Azure SQL Data Warehouse Insights)
* Azure SQL Data Warehouse Table and Statistics Queries 
* Create User-defined Restore Points
* Maintenance Window Scheduling, Service Health, Service Health Alerts
* Querying ADW Diagnostic Logs using Azure Monitor 



















'''PLEASE Remember to pause the Azure Data Warehouse when you are not using it!!!'''



