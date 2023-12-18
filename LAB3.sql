-- SQL SCRIPT 1

SELECT empNo, lastName, firstNme, midInit
FROM emp
WHERE midInit IS NULL;

--SQL SCRIPT 2
SELECT CONCAT (CONCAT(lastname, ' , '), firstNme) "Name", birthdate
FROM emp
ORDER BY lastName;

-- SOL SCRIPT 3
SELECT empNo, lastName, firstNme, hireDate
FROM emp
WHERE YEAR (hireDate) BETWEEN 1990 AND 2000
ORDER BY hireDate;

-- SQL SCRIPT 4
SELECT workDept, lastName, firstNme, salary
FROM emp
WHERE salary BETWEEN 30000 AND 50000
ORDER BY workDept, lastName;

-- SQL SCRIPT 5--
SELECT workbept, empNo, CONCAT (CONCAT (lastname,', '), firstNme) "name",
salary, salary + (0.1*salary) "New Salary"
FROM emp
WHERE salary BETWEEN 35000 AND 40000
ORDER BY workDept, lastName;


