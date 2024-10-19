------------------------------ Store procedure revision --------------------------------

select * from orders;


--- Creating a SP 

USE namasteSQL
GO
CREATE PROC spOrderSpec
AS
BEGIN
    SELECT order_id, order_date, customer_id, customer_name, country, category, sales, profit
    FROM orders
END


EXEC spOrderSpec;


------- Changing the procedure. 
GO
ALTER PROC spOrderSpec
AS 
BEGIN
    SELECT order_id, order_date, customer_id, customer_name, country, category, sales, profit
    FROM orders
    ORDER BY customer_name desc
END

EXEC spOrderSpec;


------- Droping the proc

DROP PROC spOrderSpec;



------------------------------------- Store procedures with parameters ---------------------------------

GO
CREATE PROC spOrders(@MinProfit AS INT)
AS 
BEGIN
    SELECT order_id,customer_name, profit
    FROM orders
    WHERE profit > @MinProfit
END


EXEC spOrders 100;

GO
ALTER PROC spOrderPerCountry
            (
                @Tsales AS INT,
                @Tprofit AS INT
            )
AS 
BEGIN
    SELECT customer_name, SUM(sales) AS total_sales_by_customers, SUM(profit) AS total_profit_by_customers
    FROM orders
    GROUP BY customer_name
    HAVING SUM(sales) > @Tsales AND SUM(profit) < @Tprofit
END

EXEC spOrderPerCountry 2000, 0;


GO 
ALTER PROC spCust
            (
                @Sales AS INT,
                @name AS VARCHAR(MAX)
            )
AS 
BEGIN
    SELECT customer_name, SUM(sales) AS total_profit_by_customers
    FROM orders
    WHERE customer_name LIKE '%' + @name + '%'
    GROUP BY customer_name
    HAVING SUM(sales) > @Sales
END 

GO
EXEC spCust @Sales = 10000, @name = 'S';



------ NULL as default value

GO 
ALTER PROC spNul
            (
                @Tsales AS INT = NULL,
                @Tprofit AS INT = NULL,
                @name AS VARCHAR(MAX)
            )
AS 
BEGIN
    SELECT customer_name, SUM(profit) AS total_profit, SUM(sales) AS total_sales
    FROM orders
    WHERE customer_name LIKE @name + '%'
    GROUP BY customer_name
    HAVING (@Tsales IS NULL OR SUM(sales) > @Tsales) AND (@Tprofit IS NULL OR SUM(profit) > @Tprofit)
END


EXEC spNul @name = 'A'; 


------------------------------------------------ Variables ---------------------------------------------------

select * from orders;

DECLARE @Mprofit AS INT 
DECLARE @Msales AS INT 

SET @Mprofit = 1000
SET @Msales = 3000 

SELECT customer_name, sales, profit
FROM orders 
WHERE sales < @Msales AND profit > @Mprofit


----------------------------------------------- Assigning values to a varibale from SELECT statement ---------------------------------------------
GO

DECLARE @Tnum AS INT 
DECLARE @TUnum AS INT 

SET @Tnum = (SELECT COUNT(customer_name) FROM orders) 
SET @TUnum = (SELECT COUNT(DISTINCT customer_name) FROM orders) 

SELECT @Tnum, @TUnum 

PRINT @Tnum 
PRINT @TUnum 

PRINT 'Total number of customers are ' + CAST(@Tnum AS VARCHAR(MAX))
PRINT 'Total number of unique customers are ' + CAST(@TUnum AS VARCHAR(MAX))


------------ Printing many values in a single variable -------------------

GO 

DECLARE @CusName AS VARCHAR(MAX)
SET @CusName = ''

SELECT @CusName = @CusName + customer_name + ', '  ---- This will not print anything
FROM orders
WHERE quantity > 13


PRINT 'Names of the customers are [' + @CusName + ']' 


GO 

DECLARE @name AS VARCHAR(MAX)
SET @name = ''


SELECT @name = @name + customer_name + CHAR(10) + CHAR(13)
FROM orders 
WHERE quantity > 13

print 'Names of Customers are ' +CHAR(13) + @name




GO 

DECLARE @name AS VARCHAR(MAX)
SET @name = ''


SELECT @name = @name + customer_name + CHAR(10)
FROM orders 
WHERE quantity > 13

print 'Names of Customers are ' +CHAR(13) + @name
