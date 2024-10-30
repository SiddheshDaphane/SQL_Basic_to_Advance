-- Defining an inline Table-valued fucntion


select * from orders;

USE namasteSQL
GO 

CREATE FUNCTION OrdersQuantity
(
    @Quantity INT
)
RETURNS TABLE
AS 
RETURN 
    SELECT customer_name, order_id, quantity
    FROM orders 
    WHERE quantity > @Quantity


GO
SELECT customer_name, order_id, quantity
FROM dbo.OrdersQuantity(5)


SELECT customer_name, order_id, quantity
FROM dbo.OrdersQuantity(10)

SELECT COUNT(DISTINCT customer_name) AS number_of_customers
FROM dbo.OrdersQuantity(5)



select * from returns
----- Multi-Statement Table-valued functions 


USE namasteSQL
GO 

ALTER FUNCTION SegmentandState
(
    @Quantity INT
)
RETURNS @t TABLE
(
    CustomerName VARCHAR(MAX),
    Order_id VARCHAR(MAX),
    Product_info VARCHAR(MAX)
)
AS 
BEGIN 
    INSERT INTO @t
        SELECT customer_name, order_id, 'Purchased'
        FROM orders 
        WHERE quantity > @Quantity

    INSERT INTO @t
        SELECT o.customer_name, r.order_id, 'Returned'
        FROM returns r 
        INNER JOIN orders o 
        ON r.order_id = o.order_id 
        WHERE o.quantity > @Quantity

    RETURN
END

GO
SELECT *
FROM dbo.SegmentandState(5)

SELECT *
FROM dbo.SegmentandState(12)