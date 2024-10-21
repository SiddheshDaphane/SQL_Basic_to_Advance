------------- Method 1 (Creating a TEMP table)

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