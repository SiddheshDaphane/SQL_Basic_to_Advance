------------- Creating Scalar function ---------------- 

select * from orders

SELECT customer_id, order_date,
    DATENAME(DW, order_date) + ' ' +
    DATENAME(D, order_date) + ', ' +
    DATENAME(M, order_date) + ' ' +
    DATENAME(YY, order_date) AS long_date
FROM orders


-------------------- Creating a new function -----------------------
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
