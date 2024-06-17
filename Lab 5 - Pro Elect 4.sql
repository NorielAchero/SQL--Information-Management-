
-- Query 1: Sales Order Shipments by Month and Category Code1

SELECT calMonth, addrCatCodeID, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM INVENTORY_FACT if, DATE_DIM dd, TRANS_TYPE_DIM t, ADDR_CAT_CODE1 a
WHERE if.dateKey = dd.dateKey
    AND if.transTypeKey = t.transTypeKey
    AND if.custVendorKey = a.addrCatCodeKey
    AND t.transTypeKey = 5
    AND dd.calYear = 2011
GROUP BY CUBE (dd.calMonth, a.addrCatCodeID)
ORDER BY dd.calMonth, a.addrCatCodeID;


-- Query 2: Sales Order Shipments by Name, Zip, and Quarter

SELECT dd.calQuarter, cv.zip, cv.name, SUM(if.extCost) AS totalExtendedCost, COUNT (if.inventoryKey) AS inventoryTrasactions
FROM inventory_fact if, date_dim dd, trans_type_dim t, cust_vendor_dim cv
WHERE if.dateKey = dd.dateKey
	AND if.transTypeKey = t.transTypeKey
    AND if.custVendorKey = cv.custVendorKey
    AND t.transTypeKey = 5
    AND dd.calYear IN (2011, 2012)
GROUP BY GROUPING SETS((dd.calQuarter, cv.zip, cv.name), (dd.calQuarter, cv.zip), 
	(dd.calQuarter, cv.name), (cv.zip, cv.name), dd.calQuarter, cv.zip, cv.name, ())
ORDER BY dd.calQuarter, cv.zip, cv.name;


-- Query 3: Transfers by Company and Branch Plant

SELECT companyName, bpName, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM inventory_fact if, company_dim cd, trans_type_dim t, branch_plant_dim bp
WHERE if.branchPlantKey = bp.branchPlantKey
	AND bp.companyKey = cd.companyKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 2
GROUP BY ROLLUP(companyName, bpName)
ORDER BY companyName, bpName;

-- Query 4: Inventory Transactions by Transaction Description, Company, and Branch Plant

SELECT transDescription, companyName, bpName, SUM(if.extCost) AS totalExtendedCost, COUNT (if.inventoryKey) AS inventoryTrasactions
FROM inventory_fact if, company_dim cd, trans_type_dim t, branch_plant_dim bp
WHERE if.branchPlantKey = bp.branchPlantKey
	AND bp.companyKey = cd.companyKey
	AND if.transTypeKey = t.transTypeKey
GROUP BY GROUPING SETS((transDescription, companyName, bpName), (transDescription, companyName), transDescription,() )
ORDER BY transDescription, companyName, bpName;

-- Query 5: Adjustments by Part Number

SELECT calYear, calQuarter, name, SUM(if.extCost) AS totalExtendedCost, COUNT (if.inventoryKey) AS inventoryTrasactions
FROM inventory_fact if, cust_vendor_dim cv, trans_type_dim t, date_dim dd
WHERE if.custVendorKey = cv.custVendorKey
	AND if.dateKey = dd.dateKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 5
	AND dd.calYear IN (2011, 2012)
GROUP BY ROLLUP(calYear, calQuarter), name
ORDER BY calYear, calQuarter, name;

-- Query 6: Rewrite Query 1 without CUBE, ROLLUP, or GROUPING SETS

SELECT calMonth, addrCatCodeID, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM INVENTORY_FACT if, DATE_DIM dd, TRANS_TYPE_DIM t, ADDR_CAT_CODE1 a
WHERE if.dateKey = dd.dateKey
    AND if.transTypeKey = t.transTypeKey
    AND if.custVendorKey = a.addrCatCodeKey
    AND t.transTypeKey = 5
    AND dd.calYear = 2011
GROUP BY dd.calMonth, a.addrCatCodeID
UNION
SELECT calMonth, NULL, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM INVENTORY_FACT if, DATE_DIM dd, TRANS_TYPE_DIM t, ADDR_CAT_CODE1 a
WHERE if.dateKey = dd.dateKey
    AND if.transTypeKey = t.transTypeKey
    AND if.custVendorKey = a.addrCatCodeKey
    AND t.transTypeKey = 5
    AND dd.calYear = 2011
GROUP BY calMonth
UNION
SELECT NULL, addrCatCodeID, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM INVENTORY_FACT if, DATE_DIM dd, TRANS_TYPE_DIM t, ADDR_CAT_CODE1 a
WHERE if.dateKey = dd.dateKey
    AND if.transTypeKey = t.transTypeKey
    AND if.custVendorKey = a.addrCatCodeKey
    AND t.transTypeKey = 5
    AND dd.calYear = 2011
GROUP BY addrCatCodeID
UNION
SELECT NULL, NULL, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM INVENTORY_FACT if, DATE_DIM dd, TRANS_TYPE_DIM t, ADDR_CAT_CODE1 a
WHERE if.dateKey = dd.dateKey
    AND if.transTypeKey = t.transTypeKey
    AND if.custVendorKey = a.addrCatCodeKey
    AND t.transTypeKey = 5
    AND dd.calYear = 2011
ORDER BY calMonth, addrCatCodeID;


-- Query 7: Rewrite Query 3 without CUBE, ROLLUP, or GROUPING SETS

SELECT companyName, bpName, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM inventory_fact if, company_dim cd, trans_type_dim t, branch_plant_dim bp
WHERE if.branchPlantKey = bp.branchPlantKey
	AND bp.companyKey = cd.companyKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 2
GROUP BY companyName, bpName
UNION
SELECT companyName, NULL, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM inventory_fact if, company_dim cd, trans_type_dim t, branch_plant_dim bp
WHERE if.branchPlantKey = bp.branchPlantKey
	AND bp.companyKey = cd.companyKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 2
GROUP BY companyName
UNION
SELECT NULL, NULL, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity
FROM inventory_fact if, company_dim cd, trans_type_dim t, branch_plant_dim bp
WHERE if.branchPlantKey = bp.branchPlantKey
	AND bp.companyKey = cd.companyKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 2
ORDER BY companyName, bpName;

-- Query 8: Sales Order Shipments by Name and Combination of Year and Quarter

SELECT calYear, calQuarter, name, SUM(if.extCost) AS totalExtendedCost, COUNT (if.inventoryKey) AS inventoryTrasactions
FROM inventory_fact if, cust_vendor_dim cv, trans_type_dim t, date_dim dd
WHERE if.custVendorKey = cv.custVendorKey
	AND if.dateKey = dd.dateKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 5
	AND dd.calYear IN (2011, 2012)
GROUP BY CUBE (name, (calYear, calQuarter))
ORDER BY calYear, calQuarter, name;

-- Query 9: Sales Order Shipments by Month and Category Code1 with Group Number

SELECT calMonth, addrCatCode1, SUM(extCost) AS totalExtendedCost, SUM(quantity) AS totalQuantity, 
	GROUPING (calMonth) AS group_Month,
	GROUPING (addrCatCode1) AS group_Addr
FROM INVENTORY_FACT if, DATE_DIM dd, TRANS_TYPE_DIM t, CUST_VENDOR_DIM cv
WHERE if.dateKey = dd.dateKey
	AND if.custVendorKey = cv.custVendorKey
    AND if.transTypeKey = t.transTypeKey
    AND t.transTypeKey = 5
    AND dd.calYear = 2011
GROUP BY CUBE(calMonth, addrCatCode1)
ORDER BY group_Month, group_Addr;
    
    
-- Query 10: Sales Order Shipments with Subtotals by Name and Partial Subtotals by Year and Quarter


SELECT calYear, calQuarter, name, SUM(if.extCost) AS totalExtendedCost, COUNT (if.inventoryKey) AS inventoryTrasactions
FROM inventory_fact if, cust_vendor_dim cv, trans_type_dim t, date_dim dd
WHERE if.custVendorKey = cv.custVendorKey
	AND if.dateKey = dd.dateKey
	AND if.transTypeKey = t.transTypeKey
	AND t.transTypeKey = 5
	AND dd.calYear IN (2011, 2012)
GROUP BY GROUPING SETS(name, ROLLUP(calYear, calQuarter))
ORDER BY calYear, calQuarter, name;











