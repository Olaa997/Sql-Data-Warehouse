/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_Employee
-- =============================================================================
 USE HR_Analytics
 GO
-------facts
DROP TABLE IF EXISTS gold.fact_Recruitment;
DROP TABLE IF EXISTS gold.fact_Performance;
DROP TABLE IF EXISTS gold.fact_Lifecycle_Retention;
DROP TABLE IF EXISTS gold.fact_Monthly_Pulse;
-------dimensions
DROP TABLE IF EXISTS gold.dim_Date;
DROP TABLE IF EXISTS gold.dim_Employees;
DROP TABLE IF EXISTS gold.dim_Candidate;
DROP TABLE IF EXISTS gold.dim_Manager;
DROP TABLE IF EXISTS gold.dim_Sourcing;
DROP TABLE IF EXISTS gold.dim_Department;
GO

-- ============================================================
-- dim_Date
-- ============================================================
CREATE TABLE gold.dim_Date (
    Date_Key        INT             NOT NULL CONSTRAINT pk_gold_dim_Date PRIMARY KEY,
    Full_Date       DATE            NULL,
    Year            INT             NULL,
    Quarter         INT             NULL,
    Quarter_Label   VARCHAR(10)     NULL,
    Month           INT             NULL,
    Month_Name      VARCHAR(20)     NULL,
    Week            INT             NULL,
    Day             INT             NULL,
    Is_Weekend      BIT             NULL,
    meta_created_at DATETIME2(6)    NOT NULL CONSTRAINT df_gold_dim_Date_created_at DEFAULT SYSUTCDATETIME()
);

CREATE INDEX ix_gold_dim_Date_Full_Date    ON gold.dim_Date(Full_date);
CREATE INDEX ix_gold_dim_Date_Year         ON gold.dim_Date(Year);
CREATE INDEX ix_gold_dim_Date_Month        ON gold.dim_Date(Month);
CREATE INDEX ix_gold_dim_Date_Quarter      ON gold.dim_Date(Quarter);
GO

-- ============================================================
-- dim_Employee
-- ============================================================
CREATE TABLE gold.dim_Employee (
    Employee_Key        INT             IDENTITY(1,1)   NOT NULL CONSTRAINT pk_gold_dim_Employee PRIMARY KEY,
    Employee_ID         VARCHAR(20)     NULL,
    Candidate_ID        VARCHAR(20)     NULL,
    Hire_Date           DATE            NULL,
    Department          VARCHAR(100)    NULL,
    Role                VARCHAR(100)    NULL,
    Base_Salary         DECIMAL(18, 2)  NULL,
    Manager_ID          VARCHAR(20)     NULL,
    Manager_Effect      DECIMAL(10, 4)  NULL,
    Is_Bad_Manager      BIT             NULL,
    Is_Biased_Manager   BIT             NULL,
    Gender              VARCHAR(10)     NULL,
    Ethnicity           VARCHAR(50)     NULL,
    Age_Band            VARCHAR(20)     NULL,
    Education_Level     VARCHAR(50)     NULL,
    Skill_Score         DECIMAL(5, 2)   NULL,
    Culture_Score       DECIMAL(5, 2)   NULL,
    Potential_Score     DECIMAL(5, 2)   NULL,
    LQI                 DECIMAL(5, 2)   NULL,
    meta_created_at     DATETIME2(6)    NOT NULL CONSTRAINT df_gold_dim_Employee_created_at DEFAULT SYSUTCDATETIME()
);

CREATE INDEX ix_gold_dim_Employee_Employee_ID   ON gold.dim_Employee(Employee_id);
CREATE INDEX ix_gold_dim_Employee_Department    ON gold.dim_Employee(Department);
CREATE INDEX ix_gold_dim_Employee_Role          ON gold.dim_Employee(Role);
CREATE INDEX ix_gold_dim_Employee_Gender        ON gold.dim_Employee(Gender);
CREATE INDEX ix_gold_dim_Employee_Ethnicity     ON gold.dim_Employee(Ethnicity);
GO

-- ============================================================
-- fact_Recruitment
-- ============================================================
CREATE TABLE gold.fact_Recruitment (
    Recruitment_Key         INT             IDENTITY(1,1)   NOT NULL CONSTRAINT pk_gold_fact_Recruitment PRIMARY KEY,
    Employee_Key            INT             NULL,
    Hire_Date_Key           INT             NULL,
    Vacancy_Start_Date_Key  INT             NULL,
    Req_ID                  VARCHAR(20)     NULL,
    Candidate_ID            VARCHAR(20)     NULL,
    Pipeline_Status         VARCHAR(50)     NULL,
    Days_to_Fill            INT             NULL,
    Sourcing_Channel        VARCHAR(100)    NULL,
    Sourcing_Cost           DECIMAL(18, 2)  NULL,
    Cost_of_Vacancy         DECIMAL(18, 2)  NULL,
    Total_Acquisition_Cost  DECIMAL(18, 2)  NULL,
    Skill_Score             DECIMAL(5, 2)   NULL,
    Culture_Score           DECIMAL(5, 2)   NULL,
    Potential_Score         DECIMAL(5, 2)   NULL,
    LQI                     DECIMAL(5, 2)   NULL,
    True_LQI                DECIMAL(5, 2)   NULL,
    Bias_Flag               BIT             NULL,
    Gender                  VARCHAR(10)     NULL,
    Ethnicity               VARCHAR(50)     NULL,
    Age_Band                VARCHAR(20)     NULL,
    Education_Level         VARCHAR(50)     NULL,
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_gold_fact_Recruitment_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_gold_fact_Recruitment_dim_Employee    FOREIGN KEY (Employee_key)           REFERENCES gold.dim_Employee(Employee_key),
    CONSTRAINT fk_gold_fact_Recruitment_dim_Date_hire   FOREIGN KEY (Hire_Date_Key)          REFERENCES gold.dim_Date(Date_key),
    CONSTRAINT fk_gold_fact_Recruitment_dim_Date_vac    FOREIGN KEY (Vacancy_Start_Date_Key) REFERENCES gold.dim_Date(Date_Key)
);

CREATE INDEX ix_gold_fact_Recruitment_Employee_Key  ON gold.fact_Recruitment(Employee_Key);
CREATE INDEX ix_gold_fact_Recruitment_Hire_Date_Key ON gold.fact_Recruitment(Hire_date_Key);
CREATE INDEX ix_gold_fact_Recruitment_Pipeline      ON gold.fact_Recruitment(Pipeline_Status);
CREATE INDEX ix_gold_fact_Recruitment_Sourcing      ON gold.fact_Recruitment(Sourcing_Channel);
GO

-- ============================================================
-- fact_Performance
-- ============================================================
CREATE TABLE gold.fact_Performance (
    Performance_Key         INT             IDENTITY(1,1)   NOT NULL CONSTRAINT pk_gold_fact_Performance PRIMARY KEY,
    Employee_Key            INT             NULL,
    Quarter_Date_Key        INT             NULL,
    Quarter_Label           VARCHAR(10)     NULL,
    Quarter_Number          INT             NULL,
    Tenure_Quarters         INT             NULL,
    KPI_Achievement         DECIMAL(5, 4)   NULL,
    Quality_of_Work         DECIMAL(5, 4)   NULL,
    Skill_Acquisition_Score DECIMAL(5, 4)   NULL,
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_gold_fact_Performance_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_gold_fact_Performance_dim_Employee FOREIGN KEY (Employee_key)    REFERENCES gold.dim_Employee(Employee_key),
    CONSTRAINT fk_gold_fact_Performance_dim_Date     FOREIGN KEY (Quarter_Date_Key) REFERENCES gold.dim_Date(Date_Key)
);

CREATE INDEX ix_gold_fact_Performance_Employee_Key      ON gold.fact_Performance(Employee_Key);
CREATE INDEX ix_gold_fact_Performance_Quarter_Date_Key  ON gold.fact_Performance(Quarter_Date_Key);
CREATE INDEX ix_gold_fact_Performance_Quarter_Label     ON gold.fact_Performance(Quarter_Label);
GO

-- ============================================================
-- fact_Lifecycle_Retention
-- ============================================================
CREATE TABLE gold.fact_Lifecycle_Retention (
    Attrition_Key           INT             IDENTITY(1,1)   NOT NULL CONSTRAINT pk_gold_fact_Lifecycle_Retention PRIMARY KEY,
    Employee_Key            INT             NULL,
    Hire_Date_Key           INT             NULL,
    Termination_Date_Key    INT             NULL,
    Last_Promotion_Date_Key INT             NULL,
    Employment_Status       VARCHAR(50)     NULL,
    Total_Tenure_Months     INT             NULL,
    Comp_vs_Market          DECIMAL(5, 1)   NULL,
    Final_Salary            DECIMAL(18, 2)  NULL,
    Avg_KPI_Career          DECIMAL(5, 4)   NULL,
    Promotion_Count         INT             NULL,
    Exit_Reason             VARCHAR(255)    NULL,
    Attrition_Risk_Score    DECIMAL(5, 1)   NULL,
    meta_created_at         DATETIME2(6)    NOT NULL CONSTRAINT df_gold_fact_Lifecycle_Retention_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_gold_fact_Lifecycle_Retention_dim_Employee          FOREIGN KEY (Employee_Key)            REFERENCES gold.dim_Employee(Employee_Key),
    CONSTRAINT fk_gold_fact_Lifecycle_Retention_dim_Date_Hire         FOREIGN KEY (Hire_Date_Key)           REFERENCES gold.dim_Date(Date_Key),
    CONSTRAINT fk_gold_fact_Lifecycle_Retention_dim_Date_Termination  FOREIGN KEY (Termination_Date_Key)    REFERENCES gold.dim_Date(Date_Key),
    CONSTRAINT fk_gold_fact_Lifecycle_Retention_dim_Date_Promotion    FOREIGN KEY (Last_Promotion_Date_Key) REFERENCES gold.dim_Date(Date_Key)
);

CREATE INDEX ix_gold_fact_Lifecycle_Retention_Employee_Key         ON gold.fact_Lifecycle_Retention(Employee_Key);
CREATE INDEX ix_gold_fact_Lifecycle_Retention_Hire_Date_Key        ON gold.fact_Lifecycle_Retention(Hire_date_Key);
CREATE INDEX ix_gold_fact_Lifecycle_Retention_Termination_Date_Key ON gold.fact_Lifecycle_Retention(Termination_Date_Key);
CREATE INDEX ix_gold_fact_Lifecycle_Retention_Employment_Status    ON gold.fact_Lifecycle_Retention(Employment_Status);
CREATE INDEX ix_gold_fact_Lifecycle_Retention_Exit_Reason          ON gold.fact_Lifecycle_Retention(Exit_Reason);
GO

-- ============================================================
-- fact_Pulse
-- ============================================================
CREATE TABLE gold.fact_Monthly_Pulse (
    Pulse_Key           INT             IDENTITY(1,1)   NOT NULL CONSTRAINT pk_gold_fact_Monthly_Pulse PRIMARY KEY,
    Employee_Key        INT             NULL,
    Pulse_Date_Key      INT             NULL,
    Year_Month          VARCHAR(7)      NULL,
    Month_Number        INT             NULL,
    Monthly_Pulse_Score DECIMAL(5, 1)   NULL,
    Culture_Band        VARCHAR(50)     NULL,
    meta_created_at     DATETIME2(6)    NOT NULL CONSTRAINT df_gold_fact_Monthly_Pulse_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT fk_gold_fact_Monthly_Pulse_dim_Employee  FOREIGN KEY (Employee_Key)  REFERENCES gold.dim_Employee(Employee_Key),
    CONSTRAINT fk_gold_fact_Monthly_Pulse_dim_Date      FOREIGN KEY (Pulse_Date_Key) REFERENCES gold.dim_Date(Date_Key)
);

CREATE INDEX ix_gold_fact_Monthly_Pulse_Employee_Key    ON gold.fact_Monthly_Pulse(Employee_Key);
CREATE INDEX ix_gold_fact_Monthly_Pulse_Pulse_Date_Key  ON gold.fact_Monthly_Pulse(Pulse_Date_Key);
CREATE INDEX ix_gold_fact_Monthly_Pulse_Culture_Band    ON gold.fact_Monthly_Pulse(Culture_Band);
GO
GO


