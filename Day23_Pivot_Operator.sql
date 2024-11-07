select * from orders

SELECT *
FROM
    (SELECT state, order_id, YEAR(order_date) AS order_year, DATENAME(MM, order_date) AS month_name, MONTH(order_date) AS month_number
    FROM orders) AS BaseData
PIVOT (
    COUNT(order_id)
    FOR state
    IN ([New Hampshire],
        [Massachusetts],
        [Arizona],
        [Kansas],
        [District of Columbia],
        [Tennessee],
        [Iowa],
        [New Jersey],
        [New Mexico],
        [Illinois],
        [Minnesota],
        [South Dakota],
        [California],
        [Kentucky],
        [Oregon],
        [Connecticut],
        [Maine],
        [Mississippi],
        [Rhode Island],
        [Vermont],
        [Montana],
        [West Virginia],
        [Nebraska],
        [Missouri],
        [Nevada],
        [Washington],
        [Maryland],
        [Indiana],
        [Delaware],
        [Oklahoma],
        [Louisiana],
        [New York],
        [Georgia],
        [Michigan],
        [Pennsylvania],
        [Texas],
        [North Dakota],
        [North Carolina],
        [Virginia],
        [Wyoming],
        [South Carolina],
        [Colorado],
        [Alabama],
        [Wisconsin],
        [Idaho],
        [Florida],
        [Arkansas],
        [Utah],
        [Ohio])
) AS PivotTable
ORDER BY order_year, month_number

-- Getting the list for the PIVOT function which I put in above. IMP step. 
SELECT DISTINCT(QUOTENAME(state)) + ','
FROM orders





----------------------------------------------- Dynamic Pivot Table --------------------------------------------------------------

-- Output will be same but if the new 'state' gets added or removed from the database then we don't have to enter it manually. This query
-- will take care of it and that's why this is Dyanmic.



DECLARE @ColumnNames NVARCHAR(MAX) = ''
DECLARE @SQL NVARCHAR(MAX) = ''

SELECT @ColumnNames += QUOTENAME(state) + ','
FROM (SELECT DISTINCT state FROM orders) AS DistinctStates;

SET @ColumnNames = LEFT(@ColumnNames, LEN(@ColumnNames)-1)

SET @SQL =
    'SELECT *
    FROM
        (SELECT state, order_id, YEAR(order_date) AS order_year, DATENAME(MM, order_date) AS month_name, MONTH(order_date) AS month_number
        FROM orders) AS BaseData
    PIVOT (
        COUNT(order_id)
        FOR state
        IN (' + @ColumnNames +
        ')
    ) AS PivotTable
    ORDER BY order_year, month_number'


EXECUTE sp_executesql @SQL