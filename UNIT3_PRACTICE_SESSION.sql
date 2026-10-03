-- =========================================================
-- EMPLOYEE DETAILS DATABASE
-- =========================================================

CREATE DATABASE EmployeeDB;
USE EmployeeDB;


-- =========================================================
-- PART 1: TABLE CREATION
-- =========================================================

DROP VIEW IF EXISTS vw_Employee_Details;
DROP TABLE IF EXISTS Employee_Projects;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;


-- 1. DEPARTMENTS TABLE
CREATE TABLE Departments
(
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);


-- 2. EMPLOYEES TABLE
CREATE TABLE Employees
(
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50) NOT NULL,
    Age INT,
    Salary DECIMAL(10,2),
    Department_ID INT,
    
    FOREIGN KEY (Department_ID)
    REFERENCES Departments(Department_ID)
);


-- 3. PROJECTS TABLE
CREATE TABLE Projects
(
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(50) NOT NULL,
    Department_ID INT,
    Budget DECIMAL(12,2),
    
    FOREIGN KEY (Department_ID)
    REFERENCES Departments(Department_ID)
);


-- 4. EMPLOYEE_PROJECTS TABLE
CREATE TABLE Employee_Projects
(
    Employee_ID INT,
    Project_ID INT,
    Hours_Worked INT,
    
    PRIMARY KEY (Employee_ID, Project_ID),
    
    FOREIGN KEY (Employee_ID)
    REFERENCES Employees(Employee_ID),
    
    FOREIGN KEY (Project_ID)
    REFERENCES Projects(Project_ID)
);


-- =========================================================
-- PART 2: INSERT SAMPLE DATA
-- =========================================================

-- Departments

INSERT INTO Departments VALUES
(1, 'IT', 'Hyderabad'),
(2, 'HR', 'Bangalore'),
(3, 'Finance', 'Mumbai'),
(4, 'Marketing', 'Chennai'),
(5, 'Research', 'Delhi');


-- Employees

INSERT INTO Employees VALUES
(101, 'Rahul', 25, 55000, 1),
(102, 'Priya', 28, 65000, 1),
(103, 'Arjun', 30, 75000, 2),
(104, 'Sneha', 26, 60000, 3),
(105, 'Kiran', 32, 85000, 1),
(106, 'Anjali', 24, 50000, 4),
(107, 'Ravi', 35, 90000, 3),
(108, 'Meena', 29, 70000, NULL);


-- Projects

INSERT INTO Projects VALUES
(201, 'Banking System', 1, 500000),
(202, 'Recruitment Portal', 2, 300000),
(203, 'Finance Analysis', 3, 450000),
(204, 'Marketing Campaign', 4, 250000),
(205, 'AI Research', 5, 600000);


-- Employee Projects

INSERT INTO Employee_Projects VALUES
(101, 201, 120),
(102, 201, 150),
(103, 202, 100),
(104, 203, 130),
(105, 201, 160),
(106, 204, 90),
(107, 203, 140),
(102, 205, 80);


-- =========================================================
-- PART 3: JOIN OPERATIONS
-- =========================================================


-- ---------------------------------------------------------
-- 3.1 NATURAL JOIN
-- ---------------------------------------------------------

SELECT
    Employee_ID,
    Employee_Name,
    Salary,
    Department_Name,
    Location
FROM Employees
NATURAL JOIN Departments;


-- ---------------------------------------------------------
-- 3.2 EQUI-JOIN
-- ---------------------------------------------------------

SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Salary,
    d.Department_Name
FROM Employees e
JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- ---------------------------------------------------------
-- 3.3 INNER JOIN
-- ---------------------------------------------------------

SELECT
    e.Employee_Name,
    d.Department_Name,
    e.Salary
FROM Employees e
INNER JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- ---------------------------------------------------------
-- 3.4 LEFT OUTER JOIN
-- Includes all employees
-- ---------------------------------------------------------

SELECT
    e.Employee_ID,
    e.Employee_Name,
    d.Department_Name
FROM Employees e
LEFT OUTER JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- ---------------------------------------------------------
-- 3.5 RIGHT OUTER JOIN
-- Includes all departments
-- ---------------------------------------------------------

SELECT
    e.Employee_Name,
    d.Department_Name
FROM Employees e
RIGHT OUTER JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- ---------------------------------------------------------
-- 3.6 OUTER JOIN
-- MySQL does not support FULL OUTER JOIN directly.
-- This simulates FULL OUTER JOIN using UNION.
-- ---------------------------------------------------------

SELECT
    e.Employee_Name,
    d.Department_Name
FROM Employees e
LEFT JOIN Departments d
ON e.Department_ID = d.Department_ID

UNION

SELECT
    e.Employee_Name,
    d.Department_Name
FROM Employees e
RIGHT JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- ---------------------------------------------------------
-- 3.7 JOIN EMPLOYEES WITH PROJECTS
-- ---------------------------------------------------------

SELECT
    e.Employee_Name,
    p.Project_Name,
    ep.Hours_Worked
FROM Employees e
INNER JOIN Employee_Projects ep
ON e.Employee_ID = ep.Employee_ID
INNER JOIN Projects p
ON ep.Project_ID = p.Project_ID;


-- =========================================================
-- PART 4: QUERY PERFORMANCE
-- =========================================================


-- Check execution plan of a JOIN

EXPLAIN
SELECT
    e.Employee_Name,
    d.Department_Name,
    e.Salary
FROM Employees e
INNER JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- Another performance check

EXPLAIN
SELECT
    e.Employee_Name,
    p.Project_Name
FROM Employees e
JOIN Employee_Projects ep
ON e.Employee_ID = ep.Employee_ID
JOIN Projects p
ON ep.Project_ID = p.Project_ID;


-- =========================================================
-- PART 5: SET OPERATIONS
-- =========================================================


-- ---------------------------------------------------------
-- 5.1 UNION
-- Employees working in IT or Finance
-- ---------------------------------------------------------

SELECT Employee_Name
FROM Employees
WHERE Department_ID = 1

UNION

SELECT Employee_Name
FROM Employees
WHERE Department_ID = 3;


-- ---------------------------------------------------------
-- 5.2 INTERSECTION
-- Employees earning above 60000 AND belonging to IT
-- ---------------------------------------------------------

SELECT Employee_ID, Employee_Name
FROM Employees
WHERE Salary > 60000

INTERSECT

SELECT Employee_ID, Employee_Name
FROM Employees
WHERE Department_ID = 1;


-- ---------------------------------------------------------
-- 5.3 DIFFERENCE / EXCEPT
-- Employees in IT but not in Finance
-- ---------------------------------------------------------

SELECT Employee_ID, Employee_Name
FROM Employees
WHERE Department_ID = 1

EXCEPT

SELECT Employee_ID, Employee_Name
FROM Employees
WHERE Department_ID = 3;


-- =========================================================
-- PART 6: NESTED SUBQUERIES
-- =========================================================


-- ---------------------------------------------------------
-- 6.1 Nested Subquery
-- Employees earning more than the average salary
-- ---------------------------------------------------------

SELECT
    Employee_ID,
    Employee_Name,
    Salary
FROM Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
);


-- ---------------------------------------------------------
-- 6.2 Nested Subquery
-- Employees working in IT department
-- ---------------------------------------------------------

SELECT
    Employee_ID,
    Employee_Name,
    Salary
FROM Employees
WHERE Department_ID =
(
    SELECT Department_ID
    FROM Departments
    WHERE Department_Name = 'IT'
);


-- ---------------------------------------------------------
-- 6.3 Nested Subquery using IN
-- Employees working in departments located in Hyderabad
-- ---------------------------------------------------------

SELECT
    Employee_Name,
    Salary
FROM Employees
WHERE Department_ID IN
(
    SELECT Department_ID
    FROM Departments
    WHERE Location = 'Hyderabad'
);


-- =========================================================
-- PART 7: CORRELATED SUBQUERIES
-- =========================================================


-- ---------------------------------------------------------
-- 7.1 Correlated Subquery
-- Employees earning more than the average salary
-- of their own department
-- ---------------------------------------------------------

SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Salary,
    e.Department_ID
FROM Employees e
WHERE e.Salary >
(
    SELECT AVG(e2.Salary)
    FROM Employees e2
    WHERE e2.Department_ID = e.Department_ID
);


-- ---------------------------------------------------------
-- 7.2 Correlated Subquery
-- Employees having the highest salary in their department
-- ---------------------------------------------------------

SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Salary,
    e.Department_ID
FROM Employees e
WHERE e.Salary =
(
    SELECT MAX(e2.Salary)
    FROM Employees e2
    WHERE e2.Department_ID = e.Department_ID
);


-- =========================================================
-- PART 8: NORMAL VIEW
-- =========================================================


DROP VIEW IF EXISTS vw_Employee_Details;

CREATE VIEW vw_Employee_Details AS
SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Age,
    e.Salary,
    d.Department_Name,
    d.Location
FROM Employees e
LEFT JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- Query the View

SELECT *
FROM vw_Employee_Details;


-- Query only selected employees from the View

SELECT
    Employee_Name,
    Department_Name,
    Salary
FROM vw_Employee_Details
WHERE Salary > 60000;


-- =========================================================
-- PART 9: MATERIALIZED VIEW EQUIVALENT
-- =========================================================

-- MySQL does not support CREATE MATERIALIZED VIEW.
-- We create a table to store the result.

DROP TABLE IF EXISTS mv_Employee_Salary;

CREATE TABLE mv_Employee_Salary AS
SELECT
    e.Employee_ID,
    e.Employee_Name,
    d.Department_Name,
    e.Salary
FROM Employees e
LEFT JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- Query the Materialized View Table

SELECT *
FROM mv_Employee_Salary;


-- ---------------------------------------------------------
-- REFRESH MATERIALIZED VIEW
-- ---------------------------------------------------------

TRUNCATE TABLE mv_Employee_Salary;

INSERT INTO mv_Employee_Salary
SELECT
    e.Employee_ID,
    e.Employee_Name,
    d.Department_Name,
    e.Salary
FROM Employees e
LEFT JOIN Departments d
ON e.Department_ID = d.Department_ID;


-- Check refreshed data

SELECT *
FROM mv_Employee_Salary;