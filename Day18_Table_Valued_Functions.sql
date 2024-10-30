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