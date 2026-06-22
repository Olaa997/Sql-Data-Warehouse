/*
================================================================================
SCRIPT: 03_create_silver_tables.sql
PURPOSE: Creates typed SQL Server silver tables.
================================================================================
*/

USE HR_Analytics;
GO


DROP TABLE IF EXISTS silver.crm_Recruitment;
DROP TABLE IF EXISTS silver.crm_Employee_Master;
DROP TABLE IF EXISTS silver.crm_Performance_Timeseries;
DROP TABLE IF EXISTS silver.crm_Lifecycle_Retention;
DROP TABLE IF EXISTS silver.crm_Monthly_Pulse_Timeseries;
GO


CREATE TABLE silver.crm_Recruitment (
    -- Keys
    Req_ID                  VARCHAR(20)     NOT NULL CONSTRAINT pk_silver_crm_Recruitment PRIMARY KEY,
    Candidate_ID            VARCHAR(20)     NULL,
    Employee_ID             VARCHAR(20)     NULL,

    -- Pipeline
    Pipeline_Status         VARCHAR(50)     NULL,
    Vacancy_Start_Date      DATE            NULL,
    Hire_Date               DATE            NULL,
    Days_to_Fill            INT             NULL,

    -- Sourcing
    Sourcing_Channel        VARCHAR(100)    NULL,
    Sourcing_Cost           DECIMAL(18, 2)  NULL,   
    Cost_of_Vacancy         DECIMAL(18, 2)  NULL,
    Total_Acquisition_Cost  DECIMAL(18, 2)  NULL,  

    -- Scores
    Skill_Score             DECIMAL(5, 2)   NULL,
    Culture_Score           DECIMAL(5, 2)   NULL,
    Potential_Score         DECIMAL(5, 2)   NULL,
    LQI                     DECIMAL(5, 2)   NULL,
    True_LQI                DECIMAL(5, 2)   NULL,
    Bias_Flag               BIT             NULL,

    -- Demographics
    Gender                  VARCHAR(10)     NULL,
    Ethnicity               VARCHAR(50)     NULL,
    Age_Band                VARCHAR(20)     NULL,
    Education_Level         VARCHAR(50)     NULL,

    -- Metadata
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Recruitment_created_at DEFAULT SYSUTCDATETIME(),
    meta_updated_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Recruitment_updated_at DEFAULT SYSUTCDATETIME()
);

CREATE INDEX ix_silver_crm_Recruitment_Candidate_ID  ON silver.crm_Recruitment(Candidate_ID);
CREATE INDEX ix_silver_crm_Recruitment_Employee_ID   ON silver.crm_Recruitment(Employee_ID);
CREATE INDEX ix_silver_crm_Recruitment_Pipeline_Status ON silver.crm_Recruitment(Pipeline_Status);
CREATE INDEX ix_silver_crm_Recruitment_Hire_Date     ON silver.crm_Recruitment(Hire_Date);
GO


CREATE TABLE silver.crm_Employee_Master (
    -- Keys
    Employee_ID             VARCHAR(20)     NOT NULL CONSTRAINT pk_silver_crm_Employee_Master PRIMARY KEY,
    Candidate_ID            VARCHAR(20)     NULL,

    -- Employment Details
    Hire_Date               DATE            NULL,
    Department              VARCHAR(100)    NULL,
    Role                    VARCHAR(100)    NULL,
    Base_Salary            DECIMAL(18, 2)  NULL,   
    Manager_ID             VARCHAR(20)     NULL,
    Manager_Effect         DECIMAL(5, 2)   NULL,
    Is_Bad_Manager         BIT             NULL,
    Is_Biased_Manager      BIT             NULL,

    -- Demographics
    Gender                  VARCHAR(10)     NULL,
    Ethnicity               VARCHAR(50)     NULL,
    Age_Band                VARCHAR(20)     NULL,
    Education_Level         VARCHAR(50)     NULL,
    Skill_Score             DECIMAL(5, 2)   NULL,
    Culture_Score           DECIMAL(5, 2)   NULL,
    Potential_Score         DECIMAL(5, 2)   NULL,
    LQI                     DECIMAL(5, 2)   NULL,

    -- Metadata
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Employee_Master_created_at DEFAULT SYSUTCDATETIME(),
    meta_updated_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Employee_Master_updated_at DEFAULT SYSUTCDATETIME()
);

CREATE INDEX ix_silver_crm_Employee_Master_Candidate_ID ON silver.crm_Employee_Master(Candidate_ID);
CREATE INDEX ix_silver_crm_Employee_Master_Manager_ID   ON silver.crm_Employee_Master(Manager_ID);
CREATE INDEX ix_silver_crm_Employee_Master_Hire_Date    ON silver.crm_Employee_Master(Hire_Date);
CREATE INDEX ix_silver_crm_Employee_Master_Department   ON silver.crm_Employee_Master(Department);
CREATE INDEX ix_silver_crm_Employee_Master_Role         ON silver.crm_Employee_Master(Role);
GO


CREATE TABLE silver.crm_Performance_Timeseries (
    -- Composite Primary Key
    Employee_ID             VARCHAR(20)     NOT NULL,
    Quarter_Date            DATE            NOT NULL,

    -- Time Dimensions
    Quarter_Label           VARCHAR(10)     NULL,
    Quarter_Number          INT             NULL,
    Tenure_Quarters         INT             NULL,

    -- Performance Metrics
    KPI_Achievement         DECIMAL(5, 4)   NULL,  
    Quality_of_Work         DECIMAL(5, 4)   NULL,  
    Skill_Acquisition_Score DECIMAL(5, 4)   NULL,  
    -- Metadata
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Performance_Timeseries_created_at DEFAULT SYSUTCDATETIME(),
    meta_updated_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Performance_Timeseries_updated_at DEFAULT SYSUTCDATETIME(),

    
    CONSTRAINT pk_silver_crm_Performance_Timeseries PRIMARY KEY (Employee_ID, Quarter_Date)
);

CREATE INDEX ix_silver_crm_Performance_Timeseries_Quarter_Label ON silver.crm_Performance_Timeseries(Quarter_Label);
CREATE INDEX ix_silver_crm_Performance_Timeseries_Quarter_Date  ON silver.crm_Performance_Timeseries(Quarter_Date);
GO


CREATE TABLE silver.crm_Lifecycle_Retention (
    -- Keys
    Employee_ID             VARCHAR(20)     NOT NULL CONSTRAINT pk_silver_crm_Lifecycle_Retention PRIMARY KEY,

    -- Lifecycle Details
    Employment_Status       VARCHAR(50)     NULL,   
    Hire_Date               DATE            NULL,
    Termination_Date        DATE            NULL,
    Total_Tenure_Months     INT             NULL,

    -- Compensation & Performance
    Comp_vs_Market          DECIMAL(5, 1)   NULL,   
    Final_Salary            DECIMAL(18, 2)  NULL,
    Avg_KPI_Career          DECIMAL(5, 4)   NULL,   
    Promotion_Count         INT             NULL,
    Last_Promotion_Date     DATE            NULL,

    -- Attrition
    Exit_Reason             VARCHAR(255)    NULL,
    Attrition_Risk_Score    DECIMAL(5, 1)   NULL,   

    -- Metadata
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Lifecycle_Retention_created_at DEFAULT SYSUTCDATETIME(),
    meta_updated_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Lifecycle_Retention_updated_at DEFAULT SYSUTCDATETIME()
);

CREATE INDEX ix_silver_crm_Lifecycle_Retention_Employment_Status ON silver.crm_Lifecycle_Retention(Employment_Status);
CREATE INDEX ix_silver_crm_Lifecycle_Retention_Hire_Date         ON silver.crm_Lifecycle_Retention(Hire_Date);
CREATE INDEX ix_silver_crm_Lifecycle_Retention_Termination_Date  ON silver.crm_Lifecycle_Retention(Termination_Date);
CREATE INDEX ix_silver_crm_Lifecycle_Retention_Exit_Reason       ON silver.crm_Lifecycle_Retention(Exit_Reason);
GO


CREATE TABLE silver.crm_Monthly_Pulse_Timeseries (
    -- Composite Primary Key
    Employee_ID             VARCHAR(20)     NOT NULL,
    Pulse_Date              DATE            NOT NULL,

    -- Time Dimensions
    Year_Month              VARCHAR(7)      NULL,   -- ✅ fixed: '2018-01' is not a full date
    Month_Number            INT             NULL,

    -- Pulse Metrics
    Monthly_Pulse_Score     DECIMAL(5, 1)   NULL,   -- ✅ fixed: was missing entirely
    Culture_Band            VARCHAR(50)     NULL,

    -- Metadata
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Monthly_Pulse_Timeseries_created_at DEFAULT SYSUTCDATETIME(),
    meta_updated_at         DATETIME2(6)    NOT NULL CONSTRAINT df_silver_crm_Monthly_Pulse_Timeseries_updated_at DEFAULT SYSUTCDATETIME(),

    CONSTRAINT pk_silver_crm_Monthly_Pulse_Timeseries PRIMARY KEY (Employee_ID, Pulse_Date)
);

CREATE INDEX ix_silver_crm_Monthly_Pulse_Timeseries_Year_Month   ON silver.crm_Monthly_Pulse_Timeseries(Year_Month);
CREATE INDEX ix_silver_crm_Monthly_Pulse_Timeseries_Culture_Band ON silver.crm_Monthly_Pulse_Timeseries(Culture_Band);
GO
