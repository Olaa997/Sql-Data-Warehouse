CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    BEGIN TRY
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

 PRINT '>> Truncating and Loading: silver.crm_Recruitment';
        TRUNCATE TABLE silver.crm_Recruitment;
        INSERT INTO silver.crm_Recruitment (
            Req_ID, Candidate_ID, Employee_ID, Pipeline_Status, Vacancy_Start_Date, 
            Hire_Date, Days_to_Fill, Sourcing_Channel, Sourcing_Cost, Cost_of_Vacancy, 
            Total_Acquisition_Cost, Skill_Score, Culture_Score, Potential_Score, 
            LQI, True_LQI, Bias_Flag, Gender, Ethnicity, Age_Band, Education_Level
        )
        SELECT 
            Req_ID, 
            Candidate_ID, 
            Employee_ID, 
            Pipeline_Status, 
            TRY_CAST(Vacancy_Start_Date AS DATE), 
            TRY_CAST(Hire_Date AS DATE), 
            TRY_CAST(Days_to_Fill AS INT), 
            Sourcing_Channel, 
            TRY_CAST(REPLACE(REPLACE(Sourcing_Cost, '$', ''), ',', '') AS DECIMAL(18,2)), 
            TRY_CAST(REPLACE(REPLACE(Cost_of_Vacancy, '$', ''), ',', '') AS DECIMAL(18,2)), 
            TRY_CAST(REPLACE(REPLACE(Total_Acquisition_Cost, '$', ''), ',', '') AS DECIMAL(18,2)), 
            TRY_CAST(Skill_Score AS DECIMAL(10,2)), 
            TRY_CAST(Culture_Score AS DECIMAL(10,2)), 
            TRY_CAST(Potential_Score AS DECIMAL(10,2)), 
            TRY_CAST(LQI AS DECIMAL(10,2)), 
            TRY_CAST(True_LQI AS DECIMAL(10,2)), 
            CASE WHEN Bias_Flag = 'TRUE' THEN 1 ELSE 0 END, 
            Gender, 
            Ethnicity, 
            Age_Band, 
            Education_Level
        FROM bronze.crm_Recruitment;

         -- Load silver.employee_master
        PRINT '>> Truncating and Loading: silver.employee_master';
        TRUNCATE TABLE silver.crm_Employee_Master;
        INSERT INTO silver.crm_Employee_Master (
            Employee_ID, Candidate_ID, Hire_Date, Department, Role, Base_Salary, 
            Manager_ID, Manager_Effect, Is_Bad_Manager, Is_Biased_Manager, 
            Gender, Ethnicity, Age_Band, Education_Level, Skill_Score, 
            Culture_Score, Potential_Score, LQI
        )
        SELECT 
            Employee_ID, 
            Candidate_ID, 
            TRY_CAST(Hire_Date AS DATE), 
            Department, 
            Role, 
            TRY_CAST(REPLACE(REPLACE(Base_Salary, '$', ''), ',', '') AS DECIMAL(18,2)), 
            Manager_ID, 
            TRY_CAST(Manager_Effect AS DECIMAL(10,4)), 
            CASE WHEN Is_Bad_Manager = 'TRUE' THEN 1 ELSE 0 END, 
            CASE WHEN Is_Biased_Manager = 'TRUE' THEN 1 ELSE 0 END, 
            Gender, 
            Ethnicity, 
            Age_Band, 
            Education_Level, 
            TRY_CAST(Skill_Score AS DECIMAL(10,2)), 
            TRY_CAST(Culture_Score AS DECIMAL(10,2)), 
            TRY_CAST(Potential_Score AS DECIMAL(10,2)), 
            TRY_CAST(LQI AS DECIMAL(10,2))
        FROM bronze.crm_Employee_Master;


        -- Load silver.performance_timeseries
        PRINT '>> Truncating and Loading: silver.performance_timeseries';
        TRUNCATE TABLE silver.crm_Performance_Timeseries;
        INSERT INTO silver.crm_Performance_Timeseries (
            Employee_ID, Quarter_Label, Quarter_Number, Quarter_Date, 
            Tenure_Quarters, KPI_Achievement, Quality_of_Work, Skill_Acquisition_Score
        )
        SELECT 
            Employee_ID, 
            Quarter_Label, 
            TRY_CAST(Quarter_Number AS INT), 
            TRY_CAST(Quarter_Date AS DATE), 
            TRY_CAST(Tenure_Quarters AS INT), 
            TRY_CAST(KPI_Achievement AS DECIMAL(10,4)), 
            TRY_CAST(Quality_of_Work AS DECIMAL(10,4)), 
            TRY_CAST(Skill_Acquisition_Score AS DECIMAL(10,4))
        FROM bronze.crm_Performance_Timeseries;

        -- Load silver.lifecycle_retention
        PRINT '>> Truncating and Loading: silver.crm_Lifecycle_Retention';
        TRUNCATE TABLE silver.crm_Lifecycle_Retention;
        INSERT INTO silver.crm_Lifecycle_Retention (
            Employee_ID, Employment_Status, Hire_Date, Termination_Date, 
            Total_Tenure_Months, Comp_vs_Market, Final_Salary, Avg_KPI_Career, 
            Promotion_Count, Last_Promotion_Date, Exit_Reason, Attrition_Risk_Score
        )
        SELECT 
            Employee_ID, 
            Employment_Status, 
            TRY_CAST(Hire_Date AS DATE), 
            TRY_CAST(Termination_Date AS DATE), 
            TRY_CAST(Total_Tenure_Months AS INT), 
            TRY_CAST(REPLACE(Comp_vs_Market, '%', '') AS DECIMAL(10,4)) / 100.0, 
            TRY_CAST(REPLACE(REPLACE(Final_Salary, '$', ''), ',', '') AS DECIMAL(18,2)), 
            TRY_CAST(Avg_KPI_Career AS DECIMAL(10,4)), 
            TRY_CAST(Promotion_Count AS INT), 
            TRY_CAST(Last_Promotion_Date AS DATE), 
            Exit_Reason, 
            TRY_CAST(Attrition_Risk_Score AS DECIMAL(10,2))
        FROM bronze.crm_Lifecycle_Retention;

         PRINT '>> Truncating and Loading: silver.crm_Monthly_Pulse_Timeseries';
        TRUNCATE TABLE silver.crm_Monthly_Pulse_Timeseries;
        INSERT INTO silver.crm_Monthly_Pulse_Timeseries (
            Employee_ID, Year_Month, Pulse_Date, Month_Number, 
            Monthly_Pulse_Score, Culture_Band
        )
        SELECT 
            Employee_ID, 
            Year_Month, 
            TRY_CAST(Pulse_Date AS DATE), 
            TRY_CAST(Month_Number AS INT), 
            TRY_CAST(Monthly_Pulse_Score AS DECIMAL(10,2)), 
            Culture_Band
        FROM bronze.crm_Monthly_Pulse_Timeseries;

          PRINT '================================================';
        PRINT 'Silver Layer Load Completed Successfully';
        PRINT '================================================';
    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING SILVER LAYER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT '================================================';
    END CATCH
END
GO

USE HR_Analytics;
EXEC silver.load_silver;
SELECT COUNT(*) AS crm_Recruitment_Count        FROM silver.crm_Recruitment;
SELECT COUNT(*) AS crm_Employee_Master_Count     FROM silver.crm_Employee_Master;
SELECT COUNT(*) AS crm_Performance_Count         FROM silver.crm_Performance_Timeseries;
SELECT COUNT(*) AS crm_Lifecycle_Count           FROM silver.crm_Lifecycle_Retention;
SELECT COUNT(*) AS crm_Monthly_Pulse_Count       FROM silver.crm_Monthly_Pulse_Timeseries;
