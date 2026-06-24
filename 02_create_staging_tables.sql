/*
================================================================================
SCRIPT: 02_create_staging_tables.sql
PURPOSE: Creates SQL Server staging tables used by the Python bronze loader.
==============================================================================
*/

 USE HR_Analytics;
  GO

IF OBJECT_ID(N'staging.crm_Recruitment', N'U') IS NULL
BEGIN
    CREATE TABLE staging.crm_Recruitment (
        Req_ID VARCHAR(255) NULL,
        Candidate_ID VARCHAR(255) NULL,
        Employee_ID VARCHAR(255) NULL,
        Pipeline_Status VARCHAR(255) NULL,
        Vacancy_Start_Date VARCHAR(255) NULL,
        Hire_Date VARCHAR(255) NULL,
        Days_to_Fill VARCHAR(255) NULL,
        Sourcing_Channel VARCHAR(255) NULL,
        Sourcing_Cost VARCHAR(255) NULL,
        Cost_of_Vacancy VARCHAR(255) NULL,
        Total_Acquisition_Cost VARCHAR(255) NULL,
        Skill_Score VARCHAR(255) NULL,
        Culture_Score VARCHAR(255) NULL,
        Potential_Score VARCHAR(255) NULL,
        LQI VARCHAR(255) NULL,
        True_LQI VARCHAR(255) NULL,
        Bias_Flag VARCHAR(255) NULL,
        Gender VARCHAR(255) NULL,
        Ethnicity VARCHAR(255) NULL,
        Age_Band VARCHAR(255) NULL,
        Education_Level VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NULL,
        source_file NVARCHAR(4000) NULL,
        source_row_number INT NULL,
        loaded_at DATETIME2(6) NULL,
        row_hash VARBINARY(32) NULL
    );
END;
GO


IF OBJECT_ID(N'staging.crm_Employee_Master', N'U') IS NULL
BEGIN
    CREATE TABLE staging.crm_Employee_Master (
        Employee_ID VARCHAR(255) NULL,
        Candidate_ID VARCHAR(255) NULL,
        Hire_Date VARCHAR(255) NULL,
        Department VARCHAR(255) NULL,
        Role VARCHAR(255) NULL,
        Base_Salary VARCHAR(255) NULL,
        Manager_ID VARCHAR(255) NULL,
        Manager_Effect VARCHAR(255) NULL,
        Is_Bad_Manager VARCHAR(255) NULL,
        Is_Biased_Manager VARCHAR(255) NULL,
        Gender VARCHAR(255) NULL,
        Ethnicity VARCHAR(255) NULL,
        Age_Band VARCHAR(255) NULL,
        Education_Level VARCHAR(255) NULL,
        Skill_Score VARCHAR(255) NULL,
        Culture_Score VARCHAR(255) NULL,
        Potential_Score VARCHAR(255) NULL,
        LQI VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NULL,
        source_file NVARCHAR(4000) NULL,
        source_row_number INT NULL,
        loaded_at DATETIME2(6) NULL,
        row_hash VARBINARY(32) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.crm_Performance_Timeseries', N'U') IS NULL
BEGIN
    CREATE TABLE staging.crm_Performance_Timeseries (
        Employee_ID VARCHAR(255) NULL,
        Quarter_Label VARCHAR(255) NULL,
        Quarter_Number VARCHAR(255) NULL,
        Quarter_Date VARCHAR(255) NULL,
        Tenure_Quarters VARCHAR(255) NULL,
        KPI_Achievement VARCHAR(255) NULL,
        Quality_of_Work VARCHAR(255) NULL,
        Skill_Acquisition_Score VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NULL,
        source_file NVARCHAR(4000) NULL,
        source_row_number INT NULL,
        loaded_at DATETIME2(6) NULL,
        row_hash VARBINARY(32) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.crm_Lifecycle_Retention', N'U') IS NULL
BEGIN
    CREATE TABLE staging.crm_Lifecycle_Retention (
        Employee_ID VARCHAR(255) NULL,
        Employment_Status VARCHAR(255) NULL,
        Hire_Date VARCHAR(255) NULL,
        Termination_Date VARCHAR(255) NULL,
        Total_Tenure_Months VARCHAR(255) NULL,
        Comp_vs_Market VARCHAR(255) NULL,
        Final_Salary VARCHAR(255) NULL,
        Avg_KPI_Career VARCHAR(255) NULL,
        Promotion_Count VARCHAR(255) NULL,
        Last_Promotion_Date VARCHAR(255) NULL,
        Exit_Reason VARCHAR(255) NULL,
        Attrition_Risk_Score VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NULL,
        source_file NVARCHAR(4000) NULL,
        source_row_number INT NULL,
        loaded_at DATETIME2(6) NULL,
        row_hash VARBINARY(32) NULL
    );
END;
GO

IF OBJECT_ID(N'staging.crm_Monthly_Pulse_Timeseries', N'U') IS NULL
BEGIN
    CREATE TABLE staging.crm_Monthly_Pulse_Timeseries (
        Employee_ID VARCHAR(255) NULL,
        Year_Month VARCHAR(255) NULL,
        Pulse_Date VARCHAR(255) NULL,
        Month_Number VARCHAR(255) NULL,
        Monthly_Pulse_Score VARCHAR(255) NULL,
        Culture_Band VARCHAR(255) NULL,
        batch_id UNIQUEIDENTIFIER NULL,
        source_file NVARCHAR(4000) NULL,
        source_row_number INT NULL,
        loaded_at DATETIME2(6) NULL,
        row_hash VARBINARY(32) NULL
    );
END;
GO

