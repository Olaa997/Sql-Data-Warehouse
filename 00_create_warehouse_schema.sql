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

IF SCHEMA_ID(N'ops') IS NULL
BEGIN
   EXEC(N'CREATE SCHEMA ops');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'dw_etl_executor'
      AND type = N'R'
)
BEGIN
    CREATE ROLE dw_etl_executor;
END;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::bronze TO dw_etl_executor;

GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON SCHEMA::staging TO dw_etl_executor;

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::silver TO dw_etl_executor;

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::gold TO dw_etl_executor;

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::ops TO dw_etl_executor;
GO
