-- SQL SCRIPT 1: Create a view that counts the number of hires for each month.
-- Sort the list by year then by month with its number of hires.

CREATE VIEW hires0FMonth_VIEW AS
SELECT *
FROM (SELECT YEAR(e.hireDate) "YEAR", MONTH(e.hireDate) "MONTH", COUNT(MONTH(e.hireDate)) "EMPLOYEES HIRED"
FROM employee e
GROUP BY YEAR(e.hireDate), MONTH(e.hireDate)
ORDER BY 1, 2) v;

SELECT *
FROM hires0fMonth_VIEW;


-- SQL SCRIPT 2: Formulate a view that counts that number of sales
-- transactions a customer has entered. You must display the customer number,
-- customer name, and the total number of sales transactions. Sort the list from
-- highest to lowest count.

CREATE VIEW salesTransaction_VIEW AS
SELECT *
FROM (SELECT c.custNo, c.custName, COUNT(s.transNo) "NUMBER OF TRANSACTION"
    FROM customer c
    LEFT JOIN sales s
    ON c. custNo = s. custNo
    GROUP BY c.custNo, c. custName
    ORDER BY 3 DESC) st;

SELECT *
FROM salesTransaction_VIEW;


-- SQL SCRIPT 3: What is the average salary of each job position?
-- Exclude manager, vice president, and president from the generated list.
-- Your view must display the job code, job description, and the average salary of each job.
CREATE VIEW averageSalary0fJob_VIEW AS
SELECT j.jobCode, j. jobDesc, AVG(jh.salary) "AVERAGE SALARY"
FROM job j
LEFT JOIN jobHistory jh
ON j. jobCode = jh. jobCode
GROUP BY j. jobCode, j. jobDesc
HAVING j.jobDesc NOT IN ('Manager', 'Vice president', 'President');

SELECT *
FROM averageSalary0fJob_VIEW;


-- SOL SCRIPT 4: Design a view will determine products that have undergone price changes.
-- Sort the list from highest to lowest count which also displays the product code and product description.
-- Exclude products that have по price change…
CREATE VIEW priceChange_VIEW AS
SELECT *
FROM (SELECT p.prodCode, p.description, COUNT(ph.effDate) "PRICE CHANGE"
    FROM product p
    LEFT JOIN priceHist ph
    ON p.prodCode = ph.prodCode
    GROUP BY p.prodCode, p.description|
    HAVING COUNT (ph.effDate) > 1
    ORDER BY 3 DESC) pc;

SELECT *
FROM priceChange_VIEW;

-- SQL SCRIPT 5: What is the current price of each product?
-- Create a view that displays the product code, product description,
-- unit, and its current price.
CREATE VIEW currentPrice_VIEW AS
SELECT p.prodCode, p.description, p.unit, ph.unitPrice "CURRENT PRICE"
FROM product р
LEFT JOIN priceHist ph
ON p.prodCode = ph.prodCode
RIGHT JOIN (SELECT prodCode, MAX(effDate) recentUpdate
        FROM priceHist
        GROUP BY prodCode) ph2
ON p.prodCode = ph2.prodCode AND ph.effdate = ph2.recentUpdate;

SELECT *
FROM currentPrice_VIEW;


-- SQL SCRIPT 6: Determine the current number of employees per each department.
-- Your view should contain the department code, department name, and the number
-- of employees a department has. Do not include separated (with SEPDATE values) employees
CREATE VIEW employeeCount_VIEW AS
SELECT d.deptCode, d.deptName, COUNT (jh.deptCode) "EMPLOYEE COUNT"
FROM department d
LEFT JOIN jobHistory jh
ON d.deptCode = jh.deptCode
LEFT JOIN employee e
ON e. empNo = jh. empNo
WHERE sepdate IS NULL
GROUP BY d.deptCode, d.deptName;

SELECT *
FROM employeeCount_VIEW;

-- SQL SCRIPT 7: Who among the employees received the most number of promotions?
-- The view must contain the employee number, employee name (combined last name and first name) .
-- Sort the list with the most number of promotions. Do not include separated employees.
CREATE VIEW numberOfPromotions_VIEW AS
SELECT *
FROM(SELECT e.empNo, e.lastName || ',' || e.firstName "NAME", COUNT (jh. jobCode) "NUMBER OF PROMOTION"
    FROM employee e
    LEFT JOIN jobHistory jh
    ON e. empNo = jh. empNo
    WHERE e.sepDate IS NULL
    GROUP BY e.empNo, e.lastName || ', ' || e. firstName
    ORDER BY 3 DESC) np;

SELECT *
FROM number0fPromotions_VIEW;

-- SQL SCRIPT 8: What is the most bought product of the company?
-- Your view must list the highest to lowest including the product code,
-- product description, and unit, total_quantity.
CREATE VIEW totalQuantity_VIEW AS
SELECT *
FROM (SELECT p. prodCode, p.description, p.unit, SUM(sd.quantity) "TOTAL QUANTITY"
    FROM salesDetail sd
    RIGHT JOIN product p
    ON sd. prodCode = p. prodCode
    GROUP BY p.prodCode, p. description, p.unit
    ORDER BY 4 DESC) tq;

SELECT *
FROM totalQuantity_VIEW;


-- SQL SCRIPT 9: What is the total sales of each product? 
-- 1ST VIEW
CREATE VIEW totalSales1_VIEW AS
SELECT s.transNo, s.salesDate, ph.effDate, p.prodCode, sd.quantity
FROM product p
RIGHT JOIN priceHist ph
ON p. prodCode = ph.prodCode
LEFT JOIN salesDetail sd
ON p.prodCode = sd.prodCode
LEFT JOIN sales s
ON sd.transNo = s. transNo
WHERE s.salesDate >= ph.effDate;

SELECT *
FROM totalSales1_VIEW;


-- 2ND VIEW
CREATE VIEW totalSales2_VIEW AS
SELECT ts1. transNo, ts1.salesDate, MAX(ts1.effDate) "LATEST_EFFDATE" , ts1.prodCode, ts1.quantity
FROM totalSales1_VIEW †s1
GROUP BY ts1. transNo, ts1. salesDate, ts1 prodCode, ts1 quantity;

SELECT *
FROM totalSales_VIEW;

-- 3RD VIEW
CREATE VIEW totalSales3_VIEW AS
SELECT p.prodCode, p.description, p.unit, SUM(ph.unitPrice * ts2.quantity) "TOTAL SALES"|
FROM product p
LEFT JOIN totalSales2_VIEW ts2
ON p.prodCode = ts2. prodCode
LEFT JOIN priceHist ph
ON p.prodCode = ph.prodCode
WHERE ts2. latest_effdate = ph.effdate
GROUP BY p.prodCode, p.description, p.unit;

SELECT *
FROM totalSales3 VIEW:

--SQL SCRIPT 10: Who is the customer that contributed the sales of the company? Sort your list from highes
-- to lowest including the customer code, name, and its total sales.
-- 1st VIEW|
CREATE VIEW contributionSale1_VIEW AS
SELECT c.custNo, c.custName, s. transNo, s.salesDate, ph.effDate, p.prodCode, sd.quantity
FROM customer c
LEFT JOIN sales s
ON c.custNo = s.custNo
LEFT JOIN salesDetail sd
ON s. transNo = sd. transNo
LEFT JOIN product p
ON sd.prodCode = p.prodCode
LEFT JOIN priceHist ph
ON p-prodCode = ph.prodCode
WHERE s.salesDate ›= ph.effDate;

SELECT *
FROM contributionSale1_ VIEW;

-- 2ND VIEW
CREATE VIEW contributionSale2_VIEW AS
SELECT cbs1.custNo, cbs1.custName, cbsl.transNo, cbsi.salesDate, MAX(cbs1.offDate) "LATEST_EFFDATE" , cbs1. prodCode, cbs1. quantity
FROM contributionSale1_VIEW cbs1
GROUP BY cbs1.custNo, cbsi.custName, cbsl.transNo, cbsl. salesDate, cbsi.prodCode, cbs1. quantity:|

SELECT *
FROM contributionSale2_VIEW;

-- 3RD VIEW
CREATE VIEW contributionSale3_VIEW AS
SELECT *
FROM (SELECT c.custNo, c.custName, SUM(ph.unitPrice * cbs2.quantity) "TOTAL CONTRIBUTION"
    FROM customer c
    LEFT JOIN contributionSale2_VIEW cbs2
    ON c. custNo = cbs2. custNo
    LEFT JOIN priceHist ph
    ON cbs2. prodCode = ph. prodCode
    WHERE cbs2.latest_effdate = ph.effdate
    GROUP BY c. custNo, c. custName
    ORDER BY 3 DESC) cbs3;

SELECT *
FROM contributionSale3_VIEW;