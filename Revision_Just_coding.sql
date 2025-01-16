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



-------------------------- Aggreagation with window functions -----------------------

select * from employee;


SELECT emp_id, emp_age, dept_id, salary,
SUM(salary) OVER(PARTITION BY dept_id) AS without_order_by,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id) AS with_order_by,
SUM(salary) OVER(ORDER BY emp_id) AS only_order_by
FROM employee



SELECT emp_id, dept_id, salary,
AVG(salary) OVER(PARTITION BY dept_id) AS without_order_by,
AVG(salary) OVER(PARTITION BY dept_id ORDER BY emp_id) AS with_order_by,
AVG(salary) OVER(ORDER BY emp_id) AS only_order_by
FROM employee


SELECT emp_id, dept_id, salary, 
SUM(salary) OVER(PARTITION BY dept_id) AS sum,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id) AS cumsum,
SUM(salary) OVER(ORDER BY dept_id) AS dept_cumsum,
SUM(salary) OVER(ORDER BY emp_id) AS emp_cumsum
FROM employee


----------------------------- PRECEDING and CURRENT ROW --------------------------------

SELECT emp_id, dept_id, salary,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS rolling_salary
FROM employee

SELECT emp_id, dept_id, salary,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS rolling_salary
FROM employee

SELECT emp_id, dept_id, salary,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_sum_salary
FROM employee

SELECT emp_id, dept_id, salary,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_sum_salary
FROM employee

-------------------------- FIRST VALUE and LAST VALUE ----------------------------

SELECT emp_id, dept_id, salary,
FIRST_VALUE(salary) OVER(ORDER BY salary) AS first_value,
LAST_VALUE(salary) OVER(ORDER BY salary) AS last_value
FROM employee 


SELECT emp_id, dept_id, salary,
FIRST_VALUE(salary) OVER(ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_value,
LAST_VALUE(salary) OVER(ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_value
FROM employee 


select * from orders;
--- print top 5 selling product from each category by sell

with cet1 AS (
SELECT category, product_id, SUM(sales) AS t_sales
FROM orders
GROUP BY category, product_id )
, cte2 AS (
SELECT category, product_id, t_sales,
RANK() OVER(PARTITION BY category ORDER BY t_sales desc) AS rn
FROM cet1 )
SELECT *
FROM cte2 
WHERE rn <= 5



-- 1- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
-- In case a department has less than 3 employees then print the details of highest salaried employee in that department.

select * from employee

GO
WITH cte1 AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary desc) AS rnk,
COUNT(1) OVER(PARTITION BY dept_id) AS no_of_emp
FROM employee )
SELECT *
FROM cte1
WHERE rnk = 3 OR (no_of_emp < 3 and rnk=1)


-- 2) write a query to find top 3 and bottom 3 products by sales in each region.

select * from orders

WITH cte1 AS (
SELECT region, product_id, SUM(sales) AS t_sales
FROM orders
GROUP BY region, product_id )
, cte2 AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY t_sales desc) AS rnk_01,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY t_sales) AS rnk_02
FROM cte1 )
SELECT region, product_id, t_sales,
CASE WHEN rnk_01 <= 3 THEN 'Top 3' ELSE 'Bottom 3' END AS top_bottom
FROM cte2
WHERE rnk_01 <=3 OR rnk_02 <= 3;


-- 3- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.

select * from orders

WITH cte1 AS (
SELECT sub_category, TRIM(CONCAT(YEAR(order_date), MONTH(order_date))) AS ym, SUM(sales) AS t_sales
FROM orders
GROUP BY sub_category, TRIM(CONCAT(YEAR(order_date), MONTH(order_date))))
, cte2 AS (
SELECT *,
LAG(t_sales,1) OVER(PARTITION BY sub_category ORDER BY ym) as prev_sales
FROM cte1 )
SELECT *, (t_sales - prev_sales)/(prev_sales) AS mom_growth
FROM cte2
WHERE ym = '20201'
ORDER BY mom_growth desc


-- 4) 4- write a query to print top 3 products in each category by year over year sales growth in year 2020. (IMP problem)

WITH cte1 AS (
SELECT category, product_id, YEAR(order_date) as o_year, SUM(sales) AS t_sales
FROM orders
GROUP BY category, product_id, YEAR(order_date))
, cte2 AS (
SELECT *,
LAG(t_sales,1) OVER(PARTITION BY category, product_id ORDER BY o_year) AS prev_sales
FROM cte1 )
, cte3 AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY category ORDER BY (t_sales - prev_sales)/prev_sales desc) as rn
FROM cte2
WHERE o_year = '2020')
SELECT *
FROM cte3 
WHERE rn <= 3

-- 1- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.

select * from orders;

WITH cte1 AS (
SELECT category, product_id, YEAR(order_date) AS o_year, MONTH(order_date) AS o_month, SUM(sales) AS t_sales
FROM orders
GROUP BY category, product_id, YEAR(order_date), MONTH(order_date))
, cte2 AS (
SELECT *,
SUM(t_sales) OVER(PARTITION BY category, product_id ORDER BY o_year, o_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS rolling_3_sales
FROM cte1)
, cte3 AS (
SELECT *, 
DENSE_RANK() OVER(PARTITION BY category ORDER BY rolling_3_sales DESC) AS rnk
FROM cte2
WHERE o_year = 2020 AND o_month = 1 )
SELECT *
FROM cte3 
WHERE rnk <= 3


-- 2- write a query to find products for which month over month sales has never declined.

WITH cte1 AS (
SELECT product_id, YEAR(order_date) as yo, MONTH(order_date) mo, SUM(sales) AS t_sales
FROM orders 
GROUP BY product_id, YEAR(order_date), MONTH(order_date))
, cte2 AS (
SELECT *,
LAG(t_sales,1,0) OVER(PARTITION BY product_id ORDER BY yo, mo) AS prev_sales
FROM cte1)
SELECT COUNT(DISTINCT product_id)
FROM cte2 
WHERE product_id NOT IN (SELECT product_id FROM cte2 WHERE t_sales < prev_sales GROUP BY product_id)


