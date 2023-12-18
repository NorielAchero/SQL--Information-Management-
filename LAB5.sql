-- SQL SCRIPT 1: List the transaction number, sales date,
-- product code, description, unit and quantity from the hope database.
-- Sort according to transaction number and product code. Use LEFT JOIN in your solution


SELECT s.transNo, s.salesDate, p.prodCode, p.description, p.unit, sd.quantity
FROM sales s
LEFT JOIN salesDetail sd
ON s.transNo = sd.transNo
LEFT JOIN product p
ON sd.prodCode = p.prodCode
ORDER BY 1, 3:


-- SQL SCRIPT 2: Display the employee number, last name, first name,
-- job description, and effectivity date from the job history of the employee.
-- Sort last name and effectivity date (last date first). Use LEFT JOIN.

SELECT e.empNo, e.lastName, e.firstName, j.jobDesc, jh.effDate
FROM employee e
LEFT JOIN jobHistory jh
ON e.empNo = jh.empNo
LEFT JOIN job j
ON jh. jobCode = j. jobCode
ORDER BY 2, 5 DESC;


-- SQL SCRIPT 3: Show total quantity sold from product table.
-- Display product code, description, unit, quantity. Use RIGHT JOIN.
-- Sort according to the most product sold.

SELECT p.prodCode, p.description, p.unit, SUM(sd.quantity) "TOTAL QUANTITY"
FROM salesDetail sd
RIGHT JOIN product p
ON sd. prodCode = p. prodCode
GROUP BY p.prodCode, p.description, p.unit
ORDER BY 4 DESC;

-- SQL SCRIPT 4: Generate the detailed payments made by
-- customers for specific transactions. Display customer number,
-- customer name, payment date, official receipt no, transaction number
-- and payment amount. Sort according to the customer name. Use LEFT JOIN.

SELECT c.custNo, c.custName, p.payDate, p.ORNo, s.transNo, p.amount
FROM customer c
LEFT JOIN sales s
ON c.custNo = s.custNo
LEFT JOIN payment p
ON s.transNo = p.transNo
ORDER BY 2;

-- SQL SCRIPT 5: What is the current price of each product?
-- Display product code, product description, unit, and its current price.
-- Always assume that NOT ALL products HAVE unit price BUT you need to display
-- it even if it has no unit price on it. DO NOT USE INNER JOIN.
SELECT p.prodCode, p.description, p.unit, ph.unitPrice "CURRENT PRICE"
FROM product p
LEFT JOIN priceHist ph
ON p. prodCode = ph. prodCode
RIGHT JOIN (SELECT prodCode, MAX(effDate) recentUpdate
    FROM priceHist
    GROUP BY prodCode) ph2
ON p.prodCode = ph2.prodCode AND ph.effdate = ph2.recentUpdate;







