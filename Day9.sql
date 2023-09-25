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

Remember, When you sub-query in FROM statement, then you have to use allisae but if you are using sub-query in a condition meaning in WHERE or HAVING clause, then you don't have to 
use aalisae.

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
GROUP BY in a query, it means you are using aggregate function. Which means you have numercial output which means, we have to use HAVING and not WHERE clause. 
allisae */
-- Let's verify above query. 
select order_id, SUM(sales) from orders where order_id = 'CA-2020-107328' GROUP BY order_id




select * from employee
select *  from dept 
delete from dept where dep_id = 500 -- Let's remove 500 from dept table. 


-- Let's put some department which are not present in dept table for learning purpose

UPDATE employee SET dept_id=700 WHERE dept_id = 500 -- We have a employee who's department is not present in dept table.


-- Q)2  I want the employee who's department not in dept table. 

/*  There are multiple ways to solve this question and I have solved in every possible way.

1) Sub-query. -----> Now I want the dept_id which is not present the 'dept' table meaning this is a condition. Which means that it will come in WHERE clause. Why not having?
because we are using any aggregate function. Now we have a condition about dept_id, which means in WHERE clause we will have to use dept_id.
One thing is very IMP here. When we are using sub-query, the result or outpur of the sub-query is very imp. It must match the column on which you are making condition. 
In this solution, the sub-query is returning 'dep_id' from 'dept' table and we are chaking that condition on 'dept_id' from 'employee' table. In 'WHERE' clause, we are using 
NOT IN and that's why it is okay to sub-query or inner query to return list of output. If you run inner query then you will get an out of 100,200,300,400. Because we are using
NOT IN, we are not getting error but if use any '>' or '<' operator then it will give an error because both of them expect 1 value only but we are getting list of values and 
that's why we will get an error. 


2) LEFT JOIN. ------> We can also solve this question using LEFT JOIN which is easy and not hard to understand. Only reason I am using LEFT JOIN because we want the employee who's
department is not present in dept table. 

 */

-- 1) Sub-query
SELECT * 
FROM employee
WHERE dept_id NOT IN (SELECT dep_id FROM dept) -- The output of the sub-query that is inner query must have same as dept_id because we are looking for dept_id in the sub-query. 
-- The inner query giving list of dep_id i.e. 100,200,300,400. Because we are using NOT IN, it is not giving error because NOT IN expect multiple input, What if we use '>' or '<'
-- Let try.

SELECT * 
FROM employee
WHERE dept_id > (SELECT dep_id FROM dept) --  This will give an error because it expect only 1 value from the inner query because it is comparing the values in it. If you have 
-- multiple values as a input to dept_id while using '>' or '<' then it cannot process and throws an error. 


-- 2) LEFT JOIN
SELECT * 
FROM employee e 
LEFT JOIN dept d 
ON e.dept_id = d.dep_id
WHERE dept_id NOT IN (100,200,300,400)


/* Below both query is very IMP. 
One query have a sub-query or inner query in SELECT statement and another query have two sub-query or inner query in SELECT and WHERE statement. 
1) The 1st query tell us that you can have inner-query in SELECT statement also meaning we have inner-query in SELECT, FROM, WHERE, HAVING till now. The output of 1st query is 9100.

2) The secong query is interesting because it has 2 inner query. Now the output of that query is interesting and it is same as above query that is 9100. This can be explain by the 
order of execution. 
SELECT inner query ---> WHERE inner query ----> FROM ----> WHERE ----> SELECT statement. 
This is very IMP observation. 
 */

SELECT *, (SELECT AVG(salary) FROM employee)
FROM employee -- Output is 9100


SELECT *, (SELECT AVG(salary) AS avg_salary FROM employee)
FROM employee
WHERE dept_id NOT IN (SELECT dep_id FROM dept)  -- Output is 9100. AVG salary is 9100 and didn't change even though we have only 1 employee becasue of the order of execution. 
-- 1st the inner query in the SELECT will run, then inner query in WHERE and then main query. 