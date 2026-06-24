USE HR_Analytics;
GO

-- crm_Recruitment
IF OBJECT_ID('bronze.crm_Recruitment', 'U') IS NOT NULL
    DROP TABLE bronze.crm_Recruitment;
GO

CREATE TABLE bronze.crm_Recruitment (
    bronze_record_id        BIGINT IDENTITY(1,1) NOT NULL 
        CONSTRAINT pk_bronze_crm_recruitment PRIMARY KEY,

   -- Keys
    Req_ID                  VARCHAR(50),    
    Candidate_ID            VARCHAR(50),    
    Employee_ID             VARCHAR(50),   

    -- Pipeline
    Pipeline_Status         VARCHAR(50),    
    Vacancy_Start_Date      DATE,            
    Hire_Date               DATE,          
    Days_to_Fill            INT,           

    -- Sourcing
    Sourcing_Channel        VARCHAR(100),    
    Sourcing_Cost           DECIMAL(18, 2),    
    Cost_of_Vacancy         DECIMAL(18, 2),  
    Total_Acquisition_Cost  DECIMAL(18, 2),    

    -- Scores
    Skill_Score             DECIMAL(5, 2),   
    Culture_Score           DECIMAL(5, 2),   
    Potential_Score         DECIMAL(5, 2),  
    LQI                     DECIMAL(5, 2),   
    True_LQI                DECIMAL(5, 2),   
    Bias_Flag               BIT,            

    -- Demographics
    Gender                  VARCHAR(10),    
    Ethnicity               VARCHAR(50),     
    Age_Band                VARCHAR(20),     
    Education_Level         VARCHAR(50),     


    data_source             VARCHAR(50)  DEFAULT 'CRM_RECRUITMENT_CSV',
    loaded_at               DATETIME     DEFAULT GETDATE()
);
GO

-- crm_Employee_Master
IF OBJECT_ID('bronze.crm_Employee_Master', 'U') IS NOT NULL
    DROP TABLE bronze.crm_Employee_Master;
GO

CREATE TABLE bronze.crm_Employee_Master (
    bronze_record_id        BIGINT IDENTITY(1,1) NOT NULL 
        CONSTRAINT pk_bronze_crm_Employee_Master PRIMARY KEY,

      Employee_ID             VARCHAR(20),    
    Candidate_ID              VARCHAR(20),     

    -- Employment Details
    Hire_Date               DATE,            
    Department              VARCHAR(100),   
    Role                    VARCHAR(100),    
    Base_Salary            DECIMAL(18, 2),     
    Manager_ID             VARCHAR(20),     
    Manager_Effect         DECIMAL(10,4),   
    Is_Bad_Manager         BIT,             
    Is_Biased_Manager      BIT,            

    -- Demographics
    Gender                  VARCHAR(10),    
    Ethnicity               VARCHAR(50),    
    Age_Band                VARCHAR(20),     
    Education_Level         VARCHAR(50),     
    Skill_Score             DECIMAL(5, 2),  
    Culture_Score           DECIMAL(5, 2),   
    Potential_Score         DECIMAL(5, 2),   
    LQI                     DECIMAL(5, 2),   


    data_source             VARCHAR(50)  DEFAULT 'CRM_EMPLOYEE_MASTER_CSV',
    loaded_at               DATETIME     DEFAULT GETDATE()
);
GO


IF OBJECT_ID('bronze.crm_Performance_Timeseries', 'U') IS NOT NULL
    DROP TABLE bronze.crm_Performance_Timeseries;
GO

CREATE TABLE bronze.crm_Performance_Timeseries (
    bronze_record_id         BIGINT IDENTITY(1,1) NOT NULL 
        CONSTRAINT pk_bronze_crm_Performance_Timeseries PRIMARY KEY,

   Employee_ID             VARCHAR(20),     
    Quarter_Date            DATE,           

    -- Time Dimensions
    Quarter_Label           VARCHAR(10),  
    Quarter_Number          INT,           
    Tenure_Quarters         INT,             

    -- Performance Metrics
    KPI_Achievement         DECIMAL(5, 4),    
    Quality_of_Work         DECIMAL(5, 4),  
    Skill_Acquisition_Score DECIMAL(5, 4), 
    data_source              VARCHAR(50)  DEFAULT 'CRM_PERFORMANCE_TIMESERIES_CSV',
    loaded_at                DATETIME     DEFAULT GETDATE()
);
GO

-- crm_Lifecycle_Retention 
IF OBJECT_ID('bronze.crm_Lifecycle_Retention', 'U') IS NOT NULL
    DROP TABLE bronze.crm_Lifecycle_Retention;
GO

CREATE TABLE bronze.crm_Lifecycle_Retention (
    bronze_record_id      BIGINT IDENTITY(1,1) NOT NULL 
        CONSTRAINT pk_bronze_crm_Lifecycle_Retention PRIMARY KEY,

   Employee_ID             VARCHAR(50),

    -- Lifecycle Details
    Employment_Status       VARCHAR(50),       
    Hire_Date               DATE,            
    Termination_Date        DATE,            
    Total_Tenure_Months     INT,            

    -- Compensation & Performance
    Comp_vs_Market          DECIMAL(5, 1),   
    Final_Salary            DECIMAL(18, 2),  
    Avg_KPI_Career          DECIMAL(5, 4),    
    Promotion_Count         INT,
    Last_Promotion_Date     DATE,          

    -- Attrition
    Exit_Reason             VARCHAR(255),    
    Attrition_Risk_Score    DECIMAL(5, 1),    

    data_source           VARCHAR(50)  DEFAULT 'CRM_LIFECYCLE_RETENTION_CSV',
    loaded_at             DATETIME     DEFAULT GETDATE()
);
GO

-- crm_Monthly_Pulse_Timeseries
IF OBJECT_ID('bronze.crm_Monthly_Pulse_Timeseries', 'U') IS NOT NULL
    DROP TABLE bronze.crm_Monthly_Pulse_Timeseries;
GO

CREATE TABLE bronze.crm_Monthly_Pulse_Timeseries (
    bronze_record_id     BIGINT IDENTITY(1,1) NOT NULL 
        CONSTRAINT pk_bronze_crm_Monthly_Pulse_Timeseries PRIMARY KEY,

   Employee_ID             VARCHAR(20),    
    Pulse_Date              DATE,         

    -- Time Dimensions
    Year_Month              VARCHAR(7),    
    Month_Number            INT,             
    -- Pulse Metrics
    Monthly_Pulse_Score     DECIMAL(5, 1),     
    Culture_Band            VARCHAR(50),     


    data_source          VARCHAR(50)  DEFAULT 'CRM_MONTHLY_PULSE_TIMESERIES_CSV',
    loaded_at            DATETIME     DEFAULT GETDATE()
);
GO
