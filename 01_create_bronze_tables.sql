/*
================================================================================
SCRIPT: 01_create_bronze_tables.sql
PURPOSE: Creates SQL Server bronze tables for raw, string-first data capture.

Bronze tables keep source values as VARCHAR, plus load metadata:
  - batch_id
  - source_file
  - source_row_number
  - loaded_at
  - row_hash
================================================================================
*/
USE HR_Analytics;
GO

IF OBJECT_ID(N'bronze.crm_Recruitment', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.crm_Recruitment (
        bronze_record_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_bronze_crm_recruitment PRIMARY KEY,
        Req_ID VARCHAR(255) NULL,
        Candidate_ID VARCHAR(255) NULL,
        Employee_ID VARCHAR(255) NULL,
        Pipeline_Status VARCHAR(255) NULL,
        Vacancy_Start_Date VARCHAR(255) NULL,
        Hire_Date VARCHAR(255) NULL,
        Days_to_Fill UNIQUEIDENTIFIER NOT NULL,
        Sourcing_Channel NVARCHAR(4000) NOT NULL,
        Sourcing_Cost INT NOT NULL,
        Cost_of_Vacancy DATETIME2(6) NOT NULL,
        Total_Accquisition_Cost VARBINARY(32) NOT NULL,
        Skill_Score DECIMAL(5,2) NOT NULL,
        Culture_Score DECIMAL(5,2) NOT NULL,
        Potential_Score DECIMAL(5,2) NOT NULL,
        LQI DECIMAL(5,2) NOT NULL,
        True_LQI DECIMAL(5,2) NOT NULL,
        Bias_Flag BIT NOT NULL,
        Gender VARCHAR(50) NOT NULL,
        Ethnicity VARCHAR(50) NOT NULL,
        Age_Band VARCHAR(50) NOT NULL,
        Education_Level VARCHAR(50) NOT NULL,
        batch_id UNIQUEIDENTIFIER NOT NULL,
        source_file NVARCHAR(4000) NOT NULL,
        source_row_number INT NOT NULL,
        loaded_at DATETIME2(6) NOT NULL,
        row_hash VARBINARY(32) NOT NULL

    );

        CREATE UNIQUE INDEX ux_bronze_crm_recruitment_req_id
            ON bronze.crm_Recruitment(Req_ID)
            WHERE Req_ID IS NOT NULL;
    END;
        GO

IF OBJECT_ID(N'bronze.crm_Employee_Master', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.crm_Employee_Master (
        bronze_record_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_bronze_crm_Employee_Master PRIMARY KEY,
        Employee_ID VARCHAR(255) NULL,
        Candidate_ID VARCHAR(255) NULL,
        Hire_Date VARCHAR(255) NULL,
        Department VARCHAR(255) NULL,
        Role VARCHAR(255) NULL,
        Base_Salary VARCHAR(255) NULL,
        Manager_ID  VARCHAR(255) NULL,
        Manager_Effect UNIQUEIDENTIFIER NOT NULL,
        Is_Bad_Manager NVARCHAR(4000) NOT NULL,
        Is_Biased_Manager INT NOT NULL,
        Gender VARCHAR(50) NOT NULL,
        Ethnicity VARCHAR(50) NOT NULL,
        Age_Band VARCHAR(50) NOT NULL,
        Education_Level VARCHAR(50) NOT NULL,
        Skill_Score DECIMAL(5,2) NOT NULL,
        Culture_Score DECIMAL(5,2) NOT NULL,
        Potential_Score DECIMAL(5,2) NOT NULL,
        LQI DECIMAL(5,2) NOT NULL,
        True_LQI DECIMAL(5,2) NOT NULL,
        Bias_Flag BIT NOT NULL,
        batch_id UNIQUEIDENTIFIER NOT NULL,
        source_file NVARCHAR(4000) NOT NULL,
        source_row_number INT NOT NULL,
        loaded_at DATETIME2(6) NOT NULL,
        row_hash VARBINARY(32) NOT NULL
    
    );

    CREATE UNIQUE INDEX ux_bronze_crm_Employee_Master_Employee_ID
        ON bronze.crm_Employee_Master(Employee_ID)
        WHERE Employee_ID IS NOT NULL;
END;
GO


IF OBJECT_ID(N'bronze.crm_Performance_Timeseries', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.crm_Performance_Timeseries (
        bronze_record_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_bronze_crm_Performance_Timeseries PRIMARY KEY,
        Employee_ID VARCHAR(255) NULL,
        Quarter_Label VARCHAR(255) NULL,
        Quarter_Number VARCHAR(255) NULL,
        Quarter_Date VARCHAR(255) NULL,
        Tenure_Quarters VARCHAR(255) NULL,
        KPI_Achievments VARCHAR(255) NULL,
        Quality_of_Work VARCHAR(255) NULL,
        Skill_Accquistion_Score VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NOT NULL,
        source_file NVARCHAR(4000) NOT NULL,
        source_row_number INT NOT NULL,
        loaded_at DATETIME2(6) NOT NULL,
        row_hash VARBINARY(32) NOT NULL
        
    );

    CREATE UNIQUE INDEX ux_bronze_crm_Performance_Timeseries_order_product
        ON bronze.crm_Performance_Timeseries(Employee_ID, Quarter_Label)
        WHERE Employee_ID IS NOT NULL AND Quarter_Label IS NOT NULL;
END;
GO

IF OBJECT_ID(N'bronze.crm_Lifecycle_Retention', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.crm_Lifecycle_Retention (
        bronze_record_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_bronze_crm_Lifecycle_Retention PRIMARY KEY,
        Employee_ID VARCHAR(255) NULL,
        Employment_Status VARCHAR(255) NULL,
        Hire_Date VARCHAR(255) NULL,
        Termination_Date VARCHAR(255) NULL,
        Total_Tenure_Months VARCHAR(255) NULL,
        Comp_vs_Market VARCHAR(255) NULL,
        Final_Salary VARCHAR(255) NULL,
        Avg_KPI_Career VARCHAR(255) NULL,
        Promotion_Count VARCHAR(255) NULL,
        Exit_Reason VARCHAR(255) NULL,
        Attrition_Risk_Score VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NOT NULL,
        source_file NVARCHAR(4000) NOT NULL,
        source_row_number INT NOT NULL,
        loaded_at DATETIME2(6) NOT NULL,
        row_hash VARBINARY(32) NOT NULL
    );

    CREATE UNIQUE INDEX ux_bronze_crm_lifecycle_retention_employee_id
        ON bronze.crm_Lifecycle_Retention(Employee_ID)
        WHERE Employee_ID IS NOT NULL;
END;
GO

IF OBJECT_ID(N'bronze.crm_Monthly_Pulse_Timeseries', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.crm_Monthly_Pulse_Timeseries (
        bronze_record_id BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT pk_bronze_crm_Monthly_Pulse_Timeseries PRIMARY KEY,
        Employee_id VARCHAR(255) NULL,
        Year_Month DATE NULL,
        Pulse_Date DATE NULL,
        Month_Number INT NULL,
        Monthly_Pulse_Score DECIMAL(10, 2) NULL,
        Culture_Band_Score DECIMAL(10, 2) NULL,
    
    );

    CREATE UNIQUE INDEX ux_bronze_crm_Monthly_Pulse_Timeseries_employee_id
        ON bronze.crm_Monthly_Pulse_Timeseries(Employee_id)
        WHERE Employee_id IS NOT NULL;
END;
GO
   
