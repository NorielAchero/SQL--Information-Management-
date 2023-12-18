-- SCRIPT 1
--#SET TERMINATOR ~
CREATE PROCEDURE SHOWSTATE (state VARCHAR (2))
DYNAMIC RESULT SETS 1
BEGIN
    BEGIN
        DECLARE C1 CURSOR WITH RETURN FOR
            SELECT custNo, custName, address, payTerm
            FROM customer
            WHERE address LIKE '%' || UPPER(state) || '%' ;

            OPEN c1;
    END;
END~
--##SET TERMINATOR ;

-- SCRIPT 1
CALL showState ('CA');


-- SCRIPT 2
--#SET TERMINATOR ~
CREATE PROCEDURE displayTrans (tzNum VARCHAR(8))|
DYNAMIC RESULT SETS 1
    BEGIN
        BEGIN
            DECLARE dt CURSOR WITH RETURN FOR
            SELECT s. transNo, s. salesDate, p.prodCode, p.description, p.unit, sd.quantity
            FROM sales s
            LEFT JOIN salesDetail sd
            ON s. transNo = sd. transNo
            LEFT JOIN product p
            ON sd. prodCode = p-prodCode
            WHERE s. transNo = trNum;

            OPEN dt;
        END;
    END~
--#SET TERMINATOR  

-- SCRIPT 2.
CALL displayTrans ('TR000039');


-- SCRIPT 3
--#SET TERMINATOR ~
CREATE FUNCTION get_total_payment (trNum VARCHAR(8))
        RETURNS DOUBLE
        NO EXTERNAL ACTION
        BEGIN ATOMIC
    DECLARE totalPayment DOUBLE;
    SET totalPayment = (SELECT sum(amount)
                        FROM payment
                        WHERE transNo = trNum);
    RETURN totalPayment;
    END~
--#SET TERMINATOR ;

-- SCRIPT 3
VALUES get_total_payment ('TR000092');


--#SET TERMINATOR ~
CREATE PROCEDURE payment_short()
DYNAMIC RESULT SETS 1
    BEGIN
        BEGIN
            DECLARE ps CURSOR WITH RETURN FOR

            SELECT s. transNo, c.custName, SUM("TOTAL SALES") "TOTAL SALES",
            get_total_payment (s. transNo) "TOTAL PAYMENT", SUM ("TOTAL SALES") - get_total_payment (s. transNo) "DIFFERENCE"
            FROM sales s
            LEFT JOIN customer c
            ON s. custNo = c. custNo
            LEFT JOIN total_Sales3_VIEW tsv
            ON s. transNo = tsv. transNo
            GROUP BY s. transNo, c.custName;

            OPEN ps;
    END;
END ~
--#SET TERMINATOR ;

-- 1ST VIEW
CREATE VIEW total_Sales1_VIEW AS
SELECT s. transNo, s. salesDate, ph.efflate, p.prodCode, sd.quantity
FROM product p
RIGHT JOIN priceHist ph
ON p. prodCode = ph. prodCode
LEFT JOIN salesDetail sd
ON p. prodCode = sd. prodCode
LEFT JOIN sales s
ON sd. transNo = s. transNo
WHERE s.salesDate >= ph.effDate;


-- 2ND VIEW
CREATE VIEW total_Sales2_VIEW AS
SELECT ts1. transNo, ts1.salesDate, MAX(ts1.effDate) "LATEST_EFFDATE" , ts1.prodCode, ts1 quantity
FROM total_Sales1_VIEW ts1
GROUP BY ts1. transNo, ts1. salesDate, ts1. prodCode, ts1 quantity;


-- 3RD VIEW
CREATE VIEW total_Sales3_VIEW AS
SELECT ts2. transNo, p.prodCode, p.description, p.unit, SUM(ph.unitPrice * ts2.quantity) "TOTAL SALES"
FROM product p
LEFT JOIN total_Sales2_VIEW ts2
ON p. prodCode = ts2. prodCode
LEFT JOIN priceHist ph
ON p. prodCode = ph. prodCode
WHERE ts2. latest_effdate = ph.effdate
GROUP BY ts2. transNo, p.prodCode, p.description, p.unit;