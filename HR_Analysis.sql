CREATE DATABASE HR_Analysis;
GO

USE HR_Analysis;
GO

/* Kiểm tra trùng lặp */
SELECT EmployeeNumber, COUNT(*) as row_number
FROM HR_Data
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

/* Loại bỏ các cột không cần thiết */

CREATE VIEW HR_Data_Cleaned AS
SELECT 
    -- Chọn các cột quan trọng
    EmployeeNumber, Age, Gender, MaritalStatus, Department, JobRole, JobLevel, MonthlyIncome, WorkLifeBalance,
	PercentSalaryHike, DistanceFromHome, OverTime, TotalWorkingYears, NumCompaniesWorked, JobSatisfaction,
    TrainingTimesLastYear, YearsAtCompany, YearsInCurrentRole,  YearsSinceLastPromotion, 
	YearsWithCurrManager, BusinessTravel, EducationField, StockOptionLevel, Attrition,

    -- Chuyển đổi dữ liệu
    CASE WHEN Education = 1 THEN 'Below College' WHEN Education = 2 THEN 'College' WHEN Education = 3 THEN 'Bachelor' WHEN Education = 4 THEN 'Master' ELSE 'Doctor' END AS Education_Label,
    CASE WHEN EnvironmentSatisfaction = 1 THEN 'Low' WHEN EnvironmentSatisfaction = 2 THEN 'Medium' WHEN EnvironmentSatisfaction = 3 THEN 'High' ELSE 'Very High' END AS Env_Satisfaction_Label,
    CASE WHEN JobInvolvement = 1 THEN 'Low' WHEN JobInvolvement = 2 THEN 'Medium' WHEN JobInvolvement = 3 THEN 'High' ELSE 'Very High' END AS Job_Involvement_Label,
    CASE WHEN JobSatisfaction = 1 THEN 'Low' WHEN JobSatisfaction = 2 THEN 'Medium' WHEN JobSatisfaction = 3 THEN 'High' ELSE 'Very High' END AS Job_Satisfaction_Label,
    CASE WHEN PerformanceRating = 1 THEN 'Low' WHEN PerformanceRating = 2 THEN 'Good' WHEN PerformanceRating = 3 THEN 'Excellent' ELSE 'Outstanding' END AS Performance_Label,
    CASE WHEN RelationshipSatisfaction = 1 THEN 'Low' WHEN RelationshipSatisfaction = 2 THEN 'Medium' WHEN RelationshipSatisfaction = 3 THEN 'High' ELSE 'Very High' END AS Relation_Satisfaction_Label,
    CASE WHEN WorkLifeBalance = 1 THEN 'Bad' WHEN WorkLifeBalance = 2 THEN 'Good' WHEN WorkLifeBalance = 3 THEN 'Better' ELSE 'Best' END AS WorkLifeBalance_Label,
	CASE WHEN JobLevel = 1 THEN 'Entry Level' WHEN JobLevel = 2 THEN 'Junior' WHEN JobLevel = 3 THEN 'Senior' WHEN JobLevel = 4 THEN 'Manager' ELSE 'Director' END AS JobLevel_Label,
    
	-- Feature engineering
    CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS Attrition_Count

FROM HR_Data
WHERE EmployeeNumber IS NOT NULL; -- Loại bỏ dòng Null nếu có
GO

/* EDA - Exploratory Data Analysis */
-- Q1. Công ty đang có bao nhiêu người, và tỉ lệ nghỉ việc tổng thể là bao nhiêu?
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(attrition_count) AS Total_Attrition,
    COUNT(*) - SUM(attrition_count) AS Total_Working,
    AVG(attrition_count * 100.0) AS Attrition_Rate
FROM HR_Data_Cleaned;

-- Q2. Bộ phận phòng ban nào đang "chảy máu chất xám" nghiêm trọng nhất?
SELECT Department, 
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
	   AVG(Attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
GROUP BY Department
ORDER BY Attrition_Rate DESC;

-- Q3. Nhóm cấp bậc nào có tỷ lệ nghỉ việc cao nhất?
SELECT JobLevel_Label,
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
	   AVG(attrition_count * 100.0) as attrition_rate
FROM HR_Data_Cleaned
group by JobLevel_Label
order by attrition_rate desc;

-- Q4. Những người Overtime có khả năng nghỉ việc cao hơn không?
SELECT OverTime,
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
       AVG(attrition_count * 100.0) as attrition_rate
FROM HR_Data_Cleaned
GROUP BY overtime
ORDER BY attrition_rate desc;

-- Q5. Trong Sales, Overtime có làm tăng nghỉ việc không?
SELECT Department, OverTime, 
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
	   AVG(attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
WHERE Department = 'Sales'
GROUP BY Department, OverTime
ORDER BY Attrition_Rate desc;

-- Q6. Trong Sales, nhóm tuổi nào nghỉ nhiều nhất?
SELECT Department, 
       CASE WHEN age < 25 THEN 'Under 25'
		    WHEN age BETWEEN 25 and 35 THEN 'From 25 to 35'
			ELSE '35+' 
		END AS age,
		COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
	   AVG(attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
WHERE Department = 'Sales'
GROUP BY Department,
         CASE WHEN age < 25 THEN 'Under 25'
		    WHEN age BETWEEN 25 and 35 THEN 'From 25 to 35'
			ELSE '35+' 
		 END
ORDER BY Attrition_Rate desc;

-- Q7. Trong Sales, chức vụ/vị trí nào dễ nghỉ việc nhất?
SELECT Department, JobRole, 
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
	   AVG(attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
WHERE Department = 'Sales'
GROUP BY Department, JobRole
ORDER BY Attrition_Rate desc;

-- Q8. Trong Sales, thu nhập có liên quan đến nghỉ việc không?
SELECT Department, 
       CASE WHEN MonthlyIncome < 2000 THEN 'Very low'
			WHEN MonthlyIncome BETWEEN 2000 and 5000 THEN 'Low'
			WHEN MonthlyIncome BETWEEN 5000 and 10000 THEN 'Medium'
			ELSE 'High'
		END AS MonthlyIncome,
	   COUNT(EmployeeNumber) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
	   AVG(attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
WHERE Department = 'Sales'
GROUP BY Department,
	     CASE WHEN MonthlyIncome < 2000 THEN 'Very low'
			WHEN MonthlyIncome BETWEEN 2000 and 5000 THEN 'Low'
			WHEN MonthlyIncome BETWEEN 5000 and 10000 THEN 'Medium'
			ELSE 'High'
		END
ORDER BY Attrition_Rate desc;

-- Q9. Những người không có khả năng cân bằng giữa cuộc sống và công việc có phải là nguyên nhân không?
SELECT WorkLifeBalance_Label,
       COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
       AVG(Attrition_Count * 100.0) AS Attrition_Rate
FROM HR_Data_Cleaned
GROUP BY WorkLifeBalance_Label
ORDER BY Attrition_Rate DESC;

-- Q10. Overtime kết hợp với JobSatisfaction ảnh hưởng thế nào?
SELECT OverTime, Job_Satisfaction_Label,
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
       AVG(attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
GROUP BY Overtime, Job_Satisfaction_Label
ORDER BY attrition_rate desc;

-- Q11. Overtime kết hợp với WorkLifeBalance ảnh hưởng thế nào?
SELECT OverTime, WorkLifeBalance_Label,
	   COUNT(*) as Total_Employees,
	   SUM(attrition_count) as Total_Attrition,
       AVG(attrition_count * 100.0) as Attrition_Rate
FROM HR_Data_Cleaned
GROUP BY Overtime, WorkLifeBalance_Label
ORDER BY attrition_rate desc;
