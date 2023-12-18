-- SCRIPT 1
SELECT payterm, COUNT (custname) "CUSTOMER COUNT"
FROM customer
WHERE address LIKE '%CA%'
GROUP BY payterm;

-- SCRIPT 2
SELECT gender, COUNT (gender) "GENDER COUNT"
FROM personnel
GROUP BY gender;

-- SCRIPT 3
SELECT transNo, SUM(quantity) "TOTAL QUANTITY"
FROM receiptDetail
GROUP BY transNo
ORDER BY SUM(quantity) DESC;

-- SCRIPT 4 --
SELECT YEAR (payDate) "YEAR", transNo, SUM(amount) "TOTAL PAYMENT"
FROM payment
WHERE amount >= 1000
GROUP BY YEAR (payDate), transNo
ORDER BY YEAR(payDate) DESC, SUM(amount) DESC;

-- SCRIPT 5 --
SELECT prodCode, COUNT(unitPrice) "MULTIPLE CHANGES"
FROM priceHist
GROUP BY prodCode
HAVING COUNT (unitPrice) > 1
ORDER BY COUNT(unitPrice) DESC;