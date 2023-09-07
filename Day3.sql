------------------------- SELECT STATEMENT ----------------------------

SELECT *
FROM orders;


SELECT TOP 5 *
FROM orders
ORDER BY order_date DESC; -- Order of execution FROM ---> ORDER BY ----> SELECT ----> TOP 5 *


------ DISTINCT :- To get select distinct values from a column
SELECT DISTINCT ship_mode
FROM orders;

SELECT DISTINCT ship_mode, segment
FROM orders; -- This gives all the distinct combination of ship_mode and segment. It does not act on individual level

SELECT DISTINCT *
FROM orders; -- This give all the distinct combination of all the columns. 


---------------------- FILTERS ---------------------------

-- Filtering data using WHERE condition on various data types
SELECT *
FROM orders
WHERE ship_mode = 'First Class';

SELECT *
FROM orders
WHERE order_date = '2020-12-08';

SELECT *
FROM orders
WHERE quantity = 5;

SELECT TOP 5 order_date, quantity
FROM orders
WHERE quantity >= 5
ORDER BY quantity; -- Order of execution FROM ----> WHERE ----> ORDER BY ------> SELECT TOP 5

SELECT TOP 5 order_date, quantity
FROM orders
WHERE quantity >= 5
ORDER BY quantity DESC;

SELECT order_date, quantity
FROM orders
WHERE quantity != 5
ORDER BY quantity DESC;

SELECT *
FROM orders
WHERE order_date < '2018-08-25'
ORDER BY order_date DESC; 

SELECT *
FROM orders
WHERE order_date BETWEEN '2020-12-08' AND '2020-12-10'
ORDER BY order_date DESC;  -- Both dates are included in the output. 

SELECT *
FROM orders
WHERE quantity BETWEEN 3 AND 5
ORDER BY quantity DESC;

SELECT *
FROM orders
WHERE ship_mode IN ('First Class', 'Same Day');

SELECT *
FROM orders
WHERE quantity IN (3,5) 

SELECT *
FROM orders
WHERE ship_mode NOT IN ('First Class', 'Same Day');

SELECT *
FROM orders
WHERE ship_mode > 'First Class'; -- This is based on ASCII value

-- Filter on a multiple columns
SELECT order_date, ship_mode, segment
FROM orders
WHERE ship_mode = 'First Class' AND segment = 'Consumer';

SELECT order_date, ship_mode, segment
FROM orders
WHERE ship_mode = 'First Class' OR segment = 'Consumer';

SELECT order_date, ship_mode, segment
FROM orders
WHERE ship_mode = 'First Class' OR ship_mode = 'Same Day' -- IN statement and OR statement is same

SELECT *
FROM orders
WHERE quantity > 5 AND order_date < '2020-11-08' -- Both conditions will apply because of AND


-------------------- CREATING NEW COLUMNS ---------------------

SELECT *, profit/sales AS ration 
FROM orders 

/* This doesn't change the table. New column will be added in the out and not in the table 
*/

SELECT *, profit/sales AS ration, GETDATE() 
FROM orders  -- GETDATE is a function which returns current date

------------------- Pattern Matching LIKE operator ----------------------

-- I want customers who's name starts with 'C'. Here % means you can have anything after 'C'
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C%'

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'Chris%'

-- If you want a name ending with schild
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '%Schild' 

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '%t' 


-- I want all the customers who's starting with anything, ending with anything but in between they should have 'ven'.
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '%ven%' 

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'A%a' 

/* The database is case sensitive meaning capital and small letter will matter in the output. 
But I want to do case insensitive search and also don't want to change the case sensitivity of a database. 
For this kind of search, we use UPPER function. */

SELECT order_id, order_date, customer_name, UPPER(customer_name) as name_upper
FROM orders
WHERE UPPER(customer_name) LIKE 'A%A' -- UPPER funcstion will make all the customer_name upper case and the search becomes case insensitive 



SELECT order_id, order_date, customer_name, UPPER(customer_name) as name_upper
FROM orders
WHERE UPPER(customer_name) LIKE '_L%' -- '_L' means the 2nd character must be 'L' and after that we can have anything because of %

SELECT order_id, order_date, customer_name, UPPER(customer_name) as name_upper
FROM orders
WHERE UPPER(customer_name) LIKE '_L%' ESCAPE '%' -- If you want to find '%' in a string then you have to use escape word to find it.

-- The should starts with 'C' and in the second position I want 'a' or 'l' then we have to use [al]
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[al]%'

-- What if you don't want your second character to be [al] 
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[^al]%';

-- What if you want a second character between 'a' and 'o'
SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[a-o]%';

SELECT order_id, order_date, customer_name
FROM orders
WHERE order_id LIKE 'CA-202[1-2]%';