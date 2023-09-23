--------------------------------------- SUB-QUERY ----------------------------------------------------

SELECT AVG(sales) 
FROM orders;


(SELECT order_id, SUM(sales) as order_sales
FROM orders 
GROUP BY order_id) AS orders_aggregated; 

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
Now, to get correct AVG, first we need to GROUP BY 'order_id' and take SUM of it. Why? Becasue we to divide SUM by COUNT. So the query is,

(SELECT order_id, SUM(sales) as order_sales
FROM orders 
GROUP BY order_id) AS orders_aggregated; 

Now, we can take the AVG of order_sales becasue order_sales has an SUM of a order_id, GROUP BY order_id. 

So final solution will be to take the AVG of above query. The query is,

                SELECT AVG(order_sales) AS avg_order_value
                FROM
                (SELECT order_id, SUM(sales) as order_sales
                FROM orders 
                GROUP BY order_id) AS orders_aggregated; 

    This query will give us the actual AVG.

  */



-- Find the correct avg order value
SELECT AVG(order_sales) AS avg_order_value -- AVG(order_sales) than AVG(sales) because we alliased it as a order_sales in FROM sub-query. 
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


/*  Look at this query very careful. There are three queries. Let's decode one by one starting from backwords. 

1) SELECT order_id, SUM(sales) as order_sales
   FROM orders 
   GROUP BY order_id) AS orders_aggregated  --------> This query gives SUM of sales grouped by order_id. 
   
2) (SELECT AVG(order_sales) AS avg_order_value
    FROM
        (SELECT order_id, SUM(sales) as order_sales
        FROM orders 
        GROUP BY order_id) AS orders_aggregated);  ---------> This query gives the correct AVG of the sales.
        
3)  SELECT order_id 
    FROM orders 
    GROUP BY order_id 
    HAVING SUM(sales) > (SELECT AVG(order_sales) AS avg_order_value
        FROM
            (SELECT order_id, SUM(sales) as order_sales
            FROM orders 
            GROUP BY order_id) AS orders_aggregated); -----------> This is selecting order_id from orders table which is group by order_id, but why?
If you look at the sub-queries, it is grouped by order_id which means whatever result or output sub-query will give, it will be in grouped format. Now when you are using 
GROUP BY in a query, it means you are using aggregate function. Which means you have numercial output which means, we have to use HAVING and not WHERE clause. */


-- 