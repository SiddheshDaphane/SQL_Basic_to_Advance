select * from orders;


-- Let's find the avg of the orders from order's table. (Remember there are multiple rows of same order_id)

select * from orders where order_id = 'CA-2020-152156'

-- 1) Following query is not correct because there are multiple rows of a same order_id. I need to sum sales by order_id and then take avg of that result
select avg(sales) as false_avg_sales
from orders

-- 2)
SELECT AVG(order_sales) as correct_avg_sales
FROM
(select order_id, sum(sales) as order_sales
from orders
GROUP BY order_id) as aggragted_sales 


-- Find the order_id's where sales greater than avg_sales

SELECT order_id, SUM(sales) as sum_sales
FROM orders
GROUP BY order_id
HAVING sum(sales) > 
(SELECT AVG(sum_sales) as avg_sales
FROM
(SELECT order_id, SUM(sales) as sum_sales
FROM orders
GROUP BY order_id) aggreagted_sales)