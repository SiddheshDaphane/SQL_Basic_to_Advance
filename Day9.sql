--------------------------------------- SUB-QUERY ----------------------------------------------------

SELECT AVG(sales) 
FROM orders;

/* If you look at the orders table, then you can find that it has multiple rows with the same order_id.
Let's break it down. 

   order_id	product_id	sales            ----->  Now let's break down the AVG of this table. There are three rows having sales,
        1	  100	     500             ----->  500,700,600 respectively. If we take the AVG of this in SQL, then it will be 600 because it will take AVG of sales column, but 
        1	  200	     700             ----->  order_id is repeating which means 600 is wrong value for AVG.
        2	  300	     600             ----->  The AVG should be (1200+600)/2 = (1800)/2 = 900. 

By the above logic, the first query i.e. "SELECT AVG(sales)  FROM orders;" is giving us a wrong value. So the nect question is, how can we get correct output? Can we use JOINS
to get the correct output? INNER JOIN will have same output. Can we use UNION? It will not work. 
Basically, we have calculate distinct order_id and take their sums and then divide it by the count of distinct order_id. Can we do this in single query? Let's assume that we use 
distinct and group by clause, GROUP BY will group according to order_id but how can we add them and take their count to divide for AVG? There is no option but to write different queries
to get the correct AVG values. So basically, I want an intermidiate result which hold the data on which I can get the correct output. There is no way for me to get correct value of 
AVG i.e. 900 from a single query. 

  */


(SELECT order_id, SUM(sales) as order_sales
FROM orders 
GROUP BY order_id) AS orders_aggregated; 


-- Find avg order value
SELECT AVG(order_sales) AS avg_order_value
FROM
(SELECT order_id, SUM(sales) as order_sales
FROM orders 
GROUP BY order_id) AS orders_aggregated; 


-- Find order with sales more than avg order value
SELECT order_id 
FROM orders 
GROUP BY order_id 
HAVING SUM(sales) > (SELECT AVG(order_sales) AS avg_order_value
FROM
(SELECT order_id, SUM(sales) as order_sales
FROM orders 
GROUP BY order_id) AS orders_aggregated); 
