------------- Method 1 (Creating a TEMP table)

-- Temp tables are local meaning if I close this query window, they will drop and I have to create again. We can have global Temp table by using
-- '##' instead of '#'. 


select * from orders


SELECT order_id, customer_name INTO #TempSteveTable
FROM orders
WHERE customer_name LIKE 'Steve%';

SELECT * FROM #TempSteveTable;



-------------- Method 2 (Creating a TEMP table)

CREATE TABLE #TempCusTable
(
    order_id VARCHAR(MAX),
    customer_name VARCHAR(MAX)
)
INSERT INTO #TempCusTable
SELECT order_id, customer_name
FROM orders 
WHERE customer_name LIKE 'Claire%';

SELECT * FROM #TempCusTable;





----------------------------- TABLE variable ----------------------------------------

-- TABLE variable life is only till query is executing which means you can add WHERE clause or other clause after creating table varibale
-- and then run it again, it will not give you any error. This is a big advantage of TABLE variable. 



DECLARE @TempPeople AS TABLE
(
    order_id VARCHAR(MAX),
    customer_name VARCHAR(MAX)
)
INSERT INTO @TempPeople
SELECT order_id, customer_name
FROM orders


SELECT * FROM @TempPeople