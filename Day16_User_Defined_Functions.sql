------------- Creating Scalar function ---------------- 

select * from orders

SELECT customer_id, order_date,
    DATENAME(DW, order_date) + ' ' +
    DATENAME(D, order_date) + ', ' +
    DATENAME(M, order_date) + ' ' +
    DATENAME(YY, order_date) AS long_date
FROM orders


-------------------- Creating a new scalar function -----------------------
-- scalar function means it returns only 1 value of any data time. 
GO

CREATE FUNCTION fnLongDate
        (
            @FullDate AS DATETIME
        )
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN DATENAME(DW, @FullDate) + ' ' +
    DATENAME(D, @FullDate) + ', ' +
    DATENAME(M, @FullDate) + ' ' +
    DATENAME(YY, @FullDate)
END

GO
SELECT customer_id, order_date, dbo.fnLongDate(order_date) AS Long_Date -------- USE schema name before function name. 
FROM orders


------------------------------------------- Modifying function using ALTER key word -----------------------------------


GO

ALTER FUNCTION fnLongDate
        (
            @FullDate AS DATETIME
        )
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN DATENAME(DW, @FullDate) + ' ' +
    DATENAME(D, @FullDate) +
    CASE
        WHEN DAY(@FullDate) IN (1,21,31) THEN 'st'
        WHEN DAY(@FullDate) IN (2,22) THEN 'nd'
        WHEN DAY(@FullDate) IN (3,23) THEN 'rd'
        ELSE 'th'
    END + ' ' +
    DATENAME(M, @FullDate) + ' ' +
    DATENAME(YY, @FullDate)
END

GO
SELECT customer_id, order_date, dbo.fnLongDate(order_date) AS Long_Date -------- USE schema name before function name. 
FROM orders




select * from orders

-- We can create complex functions also according to our need. 