/*
================================================================================
    This script creates the HR_Analytics database and its associated schemas.
    It also creates a role for ETL execution and grants necessary permissions.

TARGET:
    - Database: HR_Analytics
    - Schemas: bronze, staging, silver, gold, ops
    - Role: dw_etl_executor with appropriate permissions on each schema
================================================================================
*/

USE master;
GO

IF DB_ID(N'HR_Analytics') IS NULL
BEGIN
    CREATE DATABASE HR_Analytics;
END;
GO

USE HR_Analytics;
GO

IF SCHEMA_ID(N'bronze') IS NULL
BEGIN
   EXEC(N'CREATE SCHEMA bronze');
END;
GO

IF SCHEMA_ID(N'staging') IS NULL
BEGIN
   EXEC(N'CREATE SCHEMA staging');
END;
GO

IF SCHEMA_ID(N'silver') IS NULL
BEGIN
   EXEC(N'CREATE SCHEMA silver');
END;
GO

IF SCHEMA_ID(N'gold') IS NULL
BEGIN
   EXEC(N'CREATE SCHEMA gold');
END;
GO



