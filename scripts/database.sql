/*
======================================================
  Creating Database and Schema 
======================================================
Here we are dropping the database if it already exists and creating a new database named 'Datawarehouse'. 
Then new schemas are created: 'bronze', 'silver', 'gold' 

Warning: Make sure to have a backup, as this is going to permanently delete it.
*/
-------------------------------------------------------------------------------------


USE master; 
GO 
  
-- Dropping the database if it exists and creating a new one  
IF EXISTS (
  SELECT 1 
  FROM sys.databases 
  WHERE name = 'Datawarehouse'
)

BEGIN
  ALTER DATABASE Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE Datawarehouse;
END;

GO 

CREATE DATABASE Datawarehouse; 
GO
-------------------------------------
USE Datawaehouse;
GO 

-- creating schemas 
  
CREATE SCHEMA bronze;
GO 

CREATE SCHEMA silver; 
GO 

CREATE SCHEMA gold; 
GO 


