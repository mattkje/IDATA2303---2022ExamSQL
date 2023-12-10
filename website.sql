CREATE TABLE Employee (Employee_ID INT, First_name VARCHAR(50), Last_name VARCHAR(50), Job_ID VARCHAR(10), Salary INT, Department_ID INT);
INSERT INTO Employee (Employee_ID, First_name, Last_name, Job_ID, Salary, Department_ID)
VALUES (100, 'Steven', 'King', 'AD_VP', 17000, 90),
       (101, 'Neena', 'Kochhar', 'IT_PROG', 9000, 30),
       (102,'Lex','De Hann','FI_ACCOUNT',5000,20),
       (103, 'Alexander','Hunold', 'FI_MGR', 16000, 20),
       (105, 'David','Austin','IT_PROG',8500,30),
       (110,'Ismael','Sciarra','IT_MGR',19000, 30);

CREATE TABLE Location (Location_ID INT, Street_Address VARCHAR(50), Postcode INT, City VARCHAR(20), Province VARCHAR(20), Country VARCHAR(10));
INSERT INTO Location (Location_ID, Street_Address, Postcode, City, Province, Country)
VALUES (9000, '1297 Via Cola di Rie', 98237, 'Rome', NULL, 'IT'),
       (9002, '93091 Calle della Testa', 35796, 'Venice', NULL, 'IT'),
       (9003, '2017 Shinjuku-ku', 2139627, 'Tokyo', 'Tokyo Prefecture', 'JP'),
       (9009, '2014 Jabberwocky Rd', 938562, 'Southlake', 'Texas', 'US'),
       (9023, '2011 Interiors Blvd', 628573, 'South San Fra', 'California', 'US');


CREATE TABLE Department (Department_ID INT, Department_name VARCHAR(20), Manager_ID INT, Location_ID INT);
INSERT INTO Department (Department_ID, Department_name, Manager_ID, Location_ID)
VALUES (10, 'Sales',NULL,9003),
       (20, 'Finance' , 103, 9023),
       (30, 'IT', 110, 9009),
       (90, 'Executive', 100, 9001);

--- Q1: Return the names of the country that contains locations without province information, remove the duplicates.

SELECT Country
FROM Location
WHERE Province IS NULL;

---Q2: Return the name and the number of employees of the two departments “IT” and “Executive”.

SELECT Department.Department_name, COUNT(Employee.Employee_ID) AS Num_Employees
FROM Employee
JOIN Department ON Employee.Department_ID = Department.Department_ID
WHERE Department.Department_name IN ('IT', 'Executive')
GROUP BY Department.Department_name;

--Q3: Return the names of all the departments, their manager names, and their average
--salaries. Sort the output according to the average salary from highest to lowest and the
--department name alphabetically.

SELECT D.Department_name, First_name AS Manager_Name, AVG(Employee.Salary) AS Average_Salary
FROM Employee
JOIN Department D on Employee.Department_ID = D.Department_ID
WHERE D.Manager_ID IS NOT NULL
GROUP BY D.Department_name;

--Q4: Return the employee’s first names and last names, whose department have the least average salary.

SELECT Employee.First_name, Employee.Last_name
FROM Employee
JOIN Department D ON Employee.Department_ID = D.Department_ID
WHERE D.Department_ID = (
    SELECT Employee.Department_ID
    FROM Employee
    JOIN Department ON Employee.Department_ID = Department.Department_ID
    GROUP BY Employee.Department_ID
    ORDER BY AVG(Employee.Salary)
    LIMIT 1
);

--Q5: Increase the salary by 2000 for all the employees working in the same department as the manager “Alexander”.

UPDATE Employee
SET Salary = Salary + 2000
WHERE Department_ID = (
    SELECT Employee.Department_ID
    FROM Employee
    JOIN Department ON Employee.Department_ID = Department.Department_ID
    WHERE Employee.First_name IN ('Alexander')
    );

--Q6: Write a constraint to ensure that every department has less than 950 employees.
-- (Hint: Assertion, no need to create table).

ALTER TABLE Department
ADD CONSTRAINT MaxEmployeesPerDept
CHECK (
    NOT EXISTS (
        SELECT 1
        FROM Employee E
        WHERE E.Department_ID = Department.Department_ID
        GROUP BY E.Department_ID
        HAVING COUNT(*) >= 950
    )
);
