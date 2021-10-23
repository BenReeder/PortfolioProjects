-- Creating tables

Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
)

-- Inserting values into tables

Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male'),
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

-- Select Statement: *,Top,Distinct,Count,As,Max,Min

-- Select Everything

Select *
From EmployeeDemographics

-- Select Top 5 Rows of Everything

Select Top 5 *
From EmployeeDemographics

-- Select Distinct Employee ID (all)

Select Distinct (EmployeeID)
From EmployeeDemographics

-- Select Distinct Gender (Two)

Select Distinct (Gender)
From EmployeeDemographics

-- Select Count (Returns number of non-null values in a column)

Select COUNT (LastName)
from EmployeeDemographics

-- Adding in As function to name the returned column

Select COUNT (LastName) AS LastNameCount
from EmployeeDemographics

-- Max,Min,Avg (Max and Min on text: Min returns starting letter closest to A,Max returns starting letter closest to Z,Avg will not work on text)
-- Best for numerical values

Select MAX(LastName)
From EmployeeDemographics

Select MIN(LastName)
From EmployeeDemographics

Select AVG(LastName)
From EmployeeDemographics

-- Where Statment : =,<>,<,>,And,Or,Like,Null,Not Null,In */

-- =

Select * 
From EmployeeDemographics
Where FirstName = 'Jim'

-- <>

Select * 
From EmployeeDemographics
Where FirstName <> 'Jim'

-- <,>

Select * 
From EmployeeDemographics
Where Age < 30 

-- <=, >=

Select * 
From EmployeeDemographics
Where Age >= 30

-- And

Select * 
From EmployeeDemographics
Where Age <= 30 AND Gender = 'Male'

-- Or

Select * 
From EmployeeDemographics
Where Age <= 30 OR Gender= 'Male'


-- Like (S% means starts with S, %S means ends with is, %S% means S anywhere in it)

Select * 
From EmployeeDemographics
Where LastName LIKE '%S'

-- Multiple % (Goes in order meaning has to be an S then an o) Ex. For Scott, S%ott%c% returns nothing
Select * 
from EmployeeDemographics
Where LastName LIKE '%S%o%'

-- Null, Not Null

Select * 
from EmployeeDemographics
Where LastName IS Null

Select * 
from EmployeeDemographics
Where LastName IS Not Null

-- In (Equal signs for multiple things, Multiple AND's)

Select *
From EmployeeDemographics
Where FirstName In ('Jim', 'Michael')

-- Group By (When run first one only shows two genders, but they are all rolled up into it as shown in second chunk)

Select Gender
From EmployeeDemographics
Group By Gender

Select Gender, COUNT(Gender)
From EmployeeDemographics
Group By Gender


-- Shows number of males and females by age


Select Gender, Age, COUNT(Gender)
From EmployeeDemographics
Group By Gender, Age


-- Adds Where, Having
-- Having same as Where statement, just after Group By


Select Gender, COUNT(Gender) As CountGender
From EmployeeDemographics
Where Age > 31
Group By Gender
Having Count(Gender) != 1


-- Order by (starts in ASC, just type desc for descending)
-- Orders entire result order by age 
Select *
from EmployeeDemographics
Order by Age

-- Order by on Gender and Age

Select *
From EmployeeDemographics
Order by Age, Gender


-- Same Thing


Select *
From EmployeeDemographics
Order by 4,5


--Inserting More Values to Show Join Effects


Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Insert into EmployeeSalary VALUES
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)



--Joins
--4 Types (Left, Right, Full Outer, Inner)
--Inner Matches similar values (Venn Diagram Inner)
--Left matches similar on left(first) table, those not in right(second) table return null (Venn Diagram Full Left Circle)
--Same for Right just flipped (VD Right)
--Full Outer Join (Combines all 3: Inner,Left,Then Right, Full Venn Diagram)

Select *
From EmployeeDemographics dem
Join EmployeeSalary sal
ON dem.EmployeeID = sal.EmployeeID

--Avg. Salary and Number of Employees per Job Title

Select JobTitle, AVG(Salary) as AvgSalary, COUNT(JobTitle) as NumOfEmployees
From EmployeeDemographics dem
Join EmployeeSalary sal
ON dem.EmployeeID = sal.EmployeeID
Group By JobTitle
Order By AvgSalary DESC

--Join Merges Two Tables, Union adds them on top of each other (must have same number of columns)

select * 
from EmployeeDemographics
union 
select *
from EmployeeSalary




--CTE's (Common Table Expression)
--Creates "temporary table" that you can query off of
--Is gone when software is closed (Temp Tables Stay)

--Initial CTE Shows Column with Each Person's New Salary
--Second CTE Creates Column Showing Increase In Salary
--From that we can which Job Titles had the biggest Total and Avg Jumps in Salary as well as the Count per Job


With FirstCTE As
(SELECT FirstName,LastName,JobTitle,Salary,
Case 
	When JobTitle = 'Salesman' then (Salary *1.1)
	when JobTitle = 'Receptionist' then (Salary * 1.2)
	else Salary * 1.05
	end as NewSalary

FROM EmployeeSalary Sal
JOIN EmployeeDemographics Dem
on sal.EmployeeID = dem.EmployeeID),



SecondCTE as 

(Select FirstName, LastName, JobTitle,(NewSalary - Salary) as SalaryIncrease
from FirstCTE
)

Select Distinct(JobTitle), SUM(SalaryIncrease) over (partition by JobTitle) as SumOfSalaryIncreasePerJobTitle,
COUNT(JobTitle) over(partition by JobTitle) as CountPerJob,
AVG(SalaryIncrease) over (partition by JobTitle) as AVGofSalaryIncreasePerJobTitle
from SecondCTE
order by SumOfSalaryIncreasePerJobTitle desc

--Shows Employee Names, Gender, and Salary When Salary is over 45000
--

WITH CTE_Employee as 
(Select FirstName, LastName, Gender, Salary,
COUNT(Gender) over (partition by Gender) as TotalGender,
AVG(Salary) over (partition by Gender) as AvgSalary
from EmployeeDemographics dem
join EmployeeSalary sal
on dem.EmployeeID = sal.EmployeeID
WHERE Salary > '45000')

Select * from CTE_Employee

--Creating New Table

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

SELECT *
FROM EmployeeErrors

--Data Cleaning Functions

--Using Trim (Whole String),LTRIM (Trim Left),RTRIM (Trim Right)

SELECT EmployeeID, TRIM(EmployeeID) as IDTRIM
from EmployeeErrors

--Replace

Select LastName, REPLACE(LastName, '- Fired','') as LastNameFixed
from EmployeeErrors

--Substring

Select substring(err.FirstName,1,3), substring(dem.FirstName,1,3)
From EmployeeErrors err
join EmployeeDemographics dem
on Substring(err.FirstName,1,3) = substring(dem.FirstName,1,3)

--Fuzzy Match
--Sometimes Information in all tables might not be the same for example Ben, Benjamin
--People can get matched between tables knowing they are the same person even if some values are updated (Salary, JobTitle, etc.)
--Fuzzy Match columns to use = Last name, age, dob

--Upper and lower

SELECT FirstName, Lower(FirstName)
from EmployeeErrors


--Temp Table(Like CTE, just actually saved)
--Same as create table just use #
-- Can insert just like normal table
-- Or can insert using query (Ex. 2)

CREATE TABLE #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

Insert into #temp_Employee Values (
'1001','HR','45000')

INSERT INTO #temp_Employee
Select * 
from EmployeeSalary




Drop table if exists #Temp_Employee2
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #Temp_Employee2
Select JobTitle, COUNT(JobTitle),AVG(Age),AVG(Salary)
from EmployeeDemographics emp 
join EmployeeSalary sal
on emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * From
#Temp_Employee2


--Stored Procedures
--Stored Set of Steps (Somewhat like Macro in Excel)
--This one creates temp_employee table that shows job title, count in job title, average age, and average salary per job title
--EXEC function executes Stored Procedure
--Can modify in Object Explorer to use EXEC for certain condition (Ex. Salesman)


CREATE PROCEDURE Temp_Employee
AS 

Drop table if exists #temp_Employee
CREATE TABLE #temp_Employee (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #temp_Employee
Select JobTitle, COUNT(JobTitle),AVG(Age),AVG(Salary)
from EmployeeDemographics emp 
join EmployeeSalary sal
on emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * From
#temp_Employee

EXEC Temp_Employee @JobTitle = 'Salesman'


