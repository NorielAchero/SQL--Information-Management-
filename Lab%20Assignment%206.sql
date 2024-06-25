-- Query 1: Ranking within the entire result

SELECT name, SUM(extCost) AS TotalCost,
	RANK () OVER (ORDER BY SUM(extCost) DESC) AS TotalCostRank
FROM inventory_fact if, cust_vendor_dim cvd
WHERE if.custVendorKey = cvd.custVendorKey
	AND transTypeKey = 5
GROUP BY name;

-- Query 2: Ranking within a partition

SELECT state, name, SUM(extCost) AS TotalCost,
	RANK () OVER (PARTITION BY state
					ORDER BY SUM(extCost) DESC) TotalCostRank
FROM inventory_fact if, cust_vendor_dim cvd
WHERE if.custVendorKey = cvd.custVendorKey
	AND transTypeKey = 5
GROUP BY state, name
ORDER BY state;	

-- Query 3: Ranking and dense ranking within the entire result

SELECT name, COUNT (*) AS inventoryTransactions,
	RANK () OVER (ORDER BY COUNT (*) DESC) TransRank,
	DENSE_RANK () OVER (ORDER BY COUNT (*) DESC) TransDenseRank
FROM inventory_fact if, cust_vendor_dim cvd
WHERE if.custVendorKey = cvd.custVendorKey
	AND transTypeKey = 5
GROUP BY name;


-- Query 4: Cumulative extended costs for the entire result

SELECT zip, calYear, calMonth,
 	SUM(extCost) AS TotalCost, SUM(SUM(extCost)) OVER
 	(ORDER BY zip, calYear, calMonth
 	ROWS UNBOUNDED PRECEDING) AS cumulativeSales
FROM INVENTORY_FACT if, DATE_DIM dd, CUST_VENDOR_DIM cvd
WHERE if.custVendorKey = cvd.custVendorKey
	AND if.dateKey = dd.dateKey
	AND transTypeKey = 5
GROUP BY zip, calYear, calMonth;	

-- Query 5: Cumulative extended costs for a partition

SELECT zip, calYear, calMonth,
 	SUM(extCost) AS TotalCost, SUM(SUM(extCost)) OVER
 	(PARTITION BY zip, calYear
 	ORDER BY zip, calYear, calMonth
 	ROWS UNBOUNDED PRECEDING) AS cumulativeSales
FROM INVENTORY_FACT if, DATE_DIM dd, CUST_VENDOR_DIM cvd
WHERE if.custVendorKey = cvd.custVendorKey
	AND if.dateKey = dd.dateKey
	AND transTypeKey = 5
GROUP BY zip, calYear, calMonth
ORDER BY zip, calYear, calMonth;

-- Query 6: Ratio to report applied to the entire result

SELECT secondItemID, SUM(extCost) AS TotalCost, 
	RATIO_TO_REPORT(SUM(extCost))
	OVER () AS ratioToReport
FROM INVENTORY_FACT if, ITEM_MASTER_DIM imd
WHERE if.itemMasterKey = imd.itemMasterKey
	AND transTypeKey = 1
GROUP BY secondItemID
ORDER BY SUM(extCost) DESC;

-- Query 7: Ratio to report applied to a partition

SELECT calYear, SecondItemID, SUM(extCost) AS TotalCost,
	RATIO_TO_REPORT(SUM(extCost))
	OVER (PARTITION BY calYear) AS ratioToReport
FROM INVENTORY_FACT if, ITEM_MASTER_DIM imd, DATE_DIM dd
WHERE if.dateKey = dd.dateKey
	AND if.itemMasterKey = imd.itemMasterKey
	AND transTypeKey = 1
GROUP BY calYear, SecondItemID
ORDER BY calYear, SUM(extCost) DESC;

-- Query 8: Cumulative distribution functions for carrying cost of all branch plants
	
SELECT bpName, companyKey, carryingCost, 
	RANK() OVER (ORDER BY carryingCost) AS rank,
	PERCENT_RANK() OVER (ORDER BY carryingCost)  AS percent_rank,
	CUME_DIST() OVER (ORDER BY carryingCost) AS cume_dist
FROM BRANCH_PLANT_DIM;

-- Query 9: Determine worst performing plants

SELECT *
FROM (SELECT bpName, companyKey, carryingCost, 
	CUME_DIST() OVER (ORDER BY carryingCost) AS cume_dist
	FROM branch_plant_dim)
WHERE cume_dist >=0.85;

-- Query 10: Cumulative distribution of extended cost for Colorado inventory

SELECT DISTINCT extCost, CUME_DIST() OVER (ORDER BY extCost) AS cume_dist
FROM inventory_fact if, cust_vendor_dim cvd
WHERE if.custVendorKey = cvd.custVendorKey
	AND cvd.state = 'CO'
ORDER BY extCost;


	
