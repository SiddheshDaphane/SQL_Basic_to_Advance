-------------------------- Working with NULL -------------------------------
SELECT *
FROM orders

UPDATE orders 
SET city = NULL
WHERE order_id IN ('CA-2020-152156','US-2019-108966')

-- You want to get a record where city is NULL. (We just made changes to it)
SELECT *
FROM orders 
WHERE city - NULL -- This is a wrong solution because NULL cannot be compare 

SELECT *
FROM orders
WHERE city IS NULL -- This will give all the records where city is NULL

SELECT *
FROM orders
WHERE city IS NOT NULL -- This will give records where city is NOT NULL 

-------------------------------- Aggregate Functions ---------------------------------------

/* All aggregate function gives a single line output. This is an IMP information
*/
-- 1) COUNT --> This will give a count 
SELECT COUNT(*) as cnt
FROM orders   -- It gives number of records in the table

-- 2) SUM --> This is use to make a sum of a particular 
SELECT SUM(sales) as total_sales
FROM orders

-- 3) MAX and MIN and AVG --> This gives a max, min and Avg values of a particular 
SELECT MAX(sales) as MAX_sales, MIN(sales) as min_sales, AVG(sales) as avg_sales
FROM orders

---------------------------------- GROUP BY -------------------------------------

SELECT region, SUM(sales) as total_sales,MAX(sales) as MAX_sales, MIN(sales) as min_sales, AVG(sales) as avg_sales, COUNT(*) as cnt
FROM orders 
GROUP BY region -- By using GROUP BY, we are indirectly using DISTINCT because there is "group" for every region

SELECT category,region, SUM(sales) as total_sales,MAX(sales) as MAX_sales, MIN(sales) as min_sales, AVG(sales) as avg_sales, COUNT(*) as cnt
FROM orders 
GROUP BY region, category -- Now the data is grouped on region and category means it is a combination of both and each combination is unique

-- Q) What will happen here? 
SELECT category,region, SUM(sales) as total_sales,MAX(sales) as MAX_sales, MIN(sales) as min_sales, AVG(sales) as avg_sales, COUNT(*) as cnt
FROM orders 
GROUP BY region

/* Answer and Explanation.
Answer --> This query will give an error. 
Explanation --> 
Let's assume that we have data as follow

region   Category          sales
East    technology          100
East    Office Supplies     200

Now when we say "GROUP BY region" the database will group it by region "East", but at the same time category has two values,
Now database is confused. We want to group it by region but what about category. For "East" region there are two categories,
technology and Office supplies. After group by, which category should go to the "East" region? 
And that's why it will give an error.
*/

SELECT TOP 5 category,region, SUM(sales) as total_sales,MAX(sales) as MAX_sales, MIN(sales) as min_sales, AVG(sales) as avg_sales, COUNT(*) as cnt
FROM orders 
WHERE profit > 50
GROUP BY region, category
ORDER BY total_sales DESC -- order of execution FROM --> WHERE --> GROUP BY --> SELECT (columns) --> ORDER BY --> TOP 5


---------------- Filtering on aggregated values ------------------

-- I want total_sales > 100,000 but we cannot use "total_sales" in WHERE clause because of order of execution
SELECT sub_category, SUM(sales) as total_sales
FROM orders
GROUP BY sub_category
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC -- order of execution FROM --> GROUP BY --> HAVING -- SELECT --> ORDER BY


SELECT sub_category, SUM(sales) as total_sales
FROM orders
WHERE profit > 50
GROUP BY sub_category
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC -- order of execution FROM --> WHERE --> GROUP BY --> HAVING --> SELECT --> ORDER BY

 /*
So, we can use HAVING on columns meaning on non-aggregate values but it will not be efficient. Why?
Because if I use HAVING then I will have to use GROUP BY first and on that GROUP BY filters will apply
which is an extra load on the database.
On the other hand, if I use WHERE then database will go row by row and will not have to compute on a group
which will be more efficient.
*/






/*
Following is a sample database


sub-category date sales
chairs '2019-01-01' 100
chairs '2019-10-10' 200
bookcases '2019-01-01' 300
bookcases '2020-10-10' 400


I am running the following query on this database. What will be the output?


SELECT sub-category, SUM(sales) as total_sales, MAX(order_date)
FROM orders
GROUP BY sub-category
HAVING MAX(order_date) > '2020-01-01'
ORDER BY total_sales DESC;


What will be the output?


1)charis, 300, '2019-10-10'
2)bookcase, 400, '2020-10-10'
3)bookcases, 700, '2020-10-10'


Answer :-
So the answer will be 3) bookcases, 700, '202-10-10'
Look at the order of exe. It will go FROM then it will GROUP BY. Once it is grouped by sub_categories
then it will SUM sales which is 700 and then it will give MAX(date)
Important point here is that the database will not go row by row because we are using the GROUP BY function.
It will group it and give collective output.


SELECT sub-category, SUM(sales) as total_sales, MAX(order_date)
FROM orders
WHERE MAX(order_date) > '2020-01-01'
GROUP BY sub-category
ORDER BY total_sales DESC;




Answer is (bookcases '2020-10-10' 400) (Think)
*/


-------------------------- MORE COUNT FUNCTION ---------------------------

SELECT COUNT(DISTINCT region)
FROM orders 

SELECT COUNT(1)
FROM orders  -- By using 1, it is just going to every row and counting 1 (9994) times. It is same as COUNT(*)

SELECT COUNT(city), COUNT(sales) as cnt, COUNT(order_id) as cnnt 
FROM orders -- COUNT doesn't count NULL values 

/*
Important Question.


Following is the database


region sales
'east' 100
'east' NULL
'east' 200


SELECT region, AVG(sales) as avg_sales
FROM orders
GROUP BY region


SELECT region, SUM(sales)/COUNT(region) as x
FROM orders
GROUP BY region


What will be the output of both queries?


The answer is 150 and 100
*/

 