------------------------------------------- Day 1 -------------------------------------------

select * from amazon_orders;
-- Creating a table (amazon_orders) with columns and it's data type (DDL)
CREATE TABLE amazon_orders
(
order_id INT,
order_date DATE,
product_name VARCHAR(50),
total DECIMAL(10,2),
payment_method VARCHAR(20)
);


--- inserting data in table DML (Data Manupulation language)
INSERT INTO amazon_orders VALUES(1,'2022-10-01', 'Baby Milk', 30.5, 'UPI');
INSERT INTO amazon_orders VALUES(2,'2022-10-02','Baby Powder',210.5, 'Credit Card');
INSERT INTO amazon_orders VALUES(3,'2022-10-01', 'Baby Cream', 30.5, 'UPI'); 
INSERT INTO amazon_orders VALUES(4,'2022-10-02', 'Baby Soap', 310.5, 'Credit Card'); 


-- If you wan't to delete entire table that is you want to drop it.
DROP TABLE amazon_orders;

-- Let's say you want to delete entire data from table,
DELETE FROM amazon_orders;

-- DQL (Data query language)
SELECT * 
FROM amazon_orders
ORDER BY order_date DESC, product_name; -- This will first sort on order_date in descending order and if the date is same then it will sort by name in ascending order



/* We created a table with column 'order_date' which saves the 'date' format in it but I also wants to save time when order is placed.
Here comes the ALTER TABLE command. When we create a table and after sometime we want to change the characteristics of the table,
we can use this command. By using this command, we can change the table without deleting the data.
This is a DDL because we are changing defination of a data. 
*/
ALTER TABLE amazon_orders ALTER COLUMN order_date DATETIME; -- Datetime is new data type

INSERT INTO amazon_orders VALUES(5,'2022-10-01 04:28:30', 'Baby watch', 159, 'UPI');


-- Now you want to add new column to table.
ALTER TABLE amazon_orders ADD COLUMN user_name VARCHAR(20); -- New column is added.


-- You want to drop column
ALTER TABLE amazon_orders DROP COLUMN user_name;


------------------------------------ CONSTRAINTS ---------------------------------------
/* 
Constraints are as follows.

1) NOT NULL - Will not allow null to be inserted in a table

2) CHECK - let's say I am accepting only 2 payment methods which are UPI and CREDIT CARD then by using CHECK we can
            check for payment methods. This will not allow any other 3rd method. This works on integers also

3) UNIQUE - When you want a value of a particular column to be unique, we use UNIQUE constraint. NULL value is allowed but you can insert only one NULL value. You can have multiple unique keys

4) DEFAULT - If you don't pass a value on a column which has DEFAULT constraint, then it will take a default value

5) PRIMARY KEY - It is a UNIQUE KEY with NOT NULL constraint. Meaning you cannot have NULL in a primary key. It can be a combination of more than one columns also and We cannot have multiple primary keys in a table. 

*/

CREATE TABLE a_orders 
(
order_id INT NOT NULL UNIQUE,
order_date DATE,
product_name VARCHAR(50),
total DECIMAL(10,2),
payment_method VARCHAR(20) CHECK (payment_method IN ('UPI','CREDIT CARD')) DEFAULT 'UPI',
discount INT CHECK (discount <= 20),
category VARCHAR(20) DEFAULT 'Mens Wear'
PRIMARY KEY (order_id)
);

INSERT INTO a_orders VALUES(NULL, '2022-10-22', NULL, 15, 'UPI'); -- Because we set NOT NULL constraint on order_id, this statement will give an error

INSERT INTO a_orders VALUES(1,'2022-10-02', NULL,15, 'Internet Banking') -- Because we set CHECK constraint on payment_method, this statement will give an error

INSERT INTO a_orders VALUES(1,'2022-10-05', NULL, 150, 'UPI'); -- Because we set UNIQUE constraint on order_id, this statement will give an error

INSERT INTO a_orders VALUES(3,'2022-10-02', NULL, 15, 'Internate Banking',15); -- This will give an error. Even though you have DEFAULT constraint on category, you are still passing 6 values in 7 columns

-- What if you want insert values in a particular columns and not in all columns?
INSERT INTO a_orders(order_id, order_date, product_name,total, payment_method, discount) 
VALUES(4,'2022-10-02', NULL, 15, 'Internate Banking',15); -- Here we never gave value of "category" but it will take a default value. 

INSERT INTO a_orders(order_id, order_date, product_name,total, payment_method, category) 
VALUES(5,'2022-10-02', NULL, 15, 'Internate Banking', 'Kids wear'); -- Here we are not giving value for "discount" so it will take a NULL value

INSERT INTO a_orders(order_id, order_date, product_name, total) 
VALUES(6,'2022-10-02', 'Shirt', 15); -- The DEFAULT constraints on "payment_method" and "category" will insert a value in this statement

INSERT INTO a_orders(order_id, order_date, product_name, total, payment_method) 
VALUES(6,'2022-10-02', 'Shirt', 15, DEFAULT); -- We can also put "default" to insert a default value

INSERT INTO a_orders(order_id, order_date, product_name, total, payment_method) 
VALUES(NULL,'2022-10-02', 'Shirt', 15, DEFAULT) -- This will give an error because we set order_id as a primary key. If you only have UNIQUE constraint, we can insert NULL value but only one time

INSERT INTO a_orders(order_id, order_date, product_name, total, payment_method) 
VALUES(2,'2022-10-02', 'Shirt', 15, DEFAULT) -- This will give an error because primary key i.e. order_id must be UNIQUE and NOT NULL and here the UNIQUE constraint is not getting satisfied

------------------- DELETE STATEMENT -------------------

-- I don't want to delete all the data but I want to delete a specific data, How can I do that?

DELETE FROM a_orders -- This will delete all the data in a table

-- Delete a specific data with WHERE statement

DELETE 
FROM a_orders
WHERE order_id = 2 -- We can use this WHERE statement to delete a particular data. 
/* When we use WHERE, the database will go row by row and match the condition, in this case it is order_id = 2.
When this condition is satisfied, it will delete the record. 
*/ 

DELETE 
FROM a_orders
WHERE product_name = 'Shirts'

------------ UPDATE STATEMENT ---------------

/* When you want to update a data because data can change over time. How to do that?
*/

UPDATE a_orders
SET discount = 10 -- This will update discount of all rows to 10.

-- What if you want to update a specific row?

UPDATE a_orders
SET discount = 18
WHERE order_id = 2  

-- Order of execution is UPDATE a_orders ---> WHERE order_id=2 ----> SET discount = 18

-- Updating two columns at a same time
UPDATE a_orders
SET discount = 18, payment_method = 'Credit Card'
WHERE order_id = 2

----------------------------------------------- DAY 2 ------------------------------------------------------

----- SELECT STATEMENT ------

SELECT TOP 5 order_date, quantity
FROM orders
WHERE quantity >= 5
ORDER BY quantity;  -- Order of E   FROM --> WHERE --> ORDER BY --> SELECT --> TOP 5

SELECT *
FROM orders
WHERE order_date < '2018-06-21'
ORDER BY order_date DESC;

SELECT *
FROM orders
WHERE order_date BETWEEN '2020-12-08' AND '2020-12-10'
ORDER BY order_date DESC;

SELECT *
FROM orders 
WHERE quantity IN (3,5) --- 'IN' means 'OR'

SELECT *
FROM orders 
WHERE quantity NOT IN ('First Class', 'Same Day');

SELECT * 
FROM orders 
WHERE ship_date > 'First Class'; -- This is based on ASCII value

--------------- Filter on a multiple columns --------------------

SELECT *
FROM orders 
WHERE ship_mode = 'First Class' AND segment = 'Consumer';

SELECT * 
FROM orders
WHERE ship_mode = 'First Class' OR segment = 'Consumer';

SELECT *
FROM orders 
WHERE ship_mode IN ('First Class','Same day'); 

SELECT * 
FROM orders
WHERE quantity > 5 AND order_date < '2020-10-06'

------------- Creating NEW COLUMNS for output -------------

SELECT *, profit/sales as ratio 
FROM orders --- This will not change original table. New columns 'ratio' will come in output

SELECT *, profit/sales AS ratio, GETDATE()
FROM orders -- GETDATE() function returns current date

---------------------- Pattern Matching LIKE operator ------------------------

-- I want customers who's name starts with 'C'. 
SELECT *
FROM orders 
WHERE customer_name LIKE 'C%'; -- Here % means you can have anything after 'C'

SELECT order_id, order_date, customer_name
FROM orders 
WHERE customer_name LIKE 'Chris%';

SELECT *
FROM orders 
WHERE customer_name LIKE '%Schild'; -- Name ends with 'Schild'

SELECT * 
FROM orders 
WHERE customer_name LIKE '%t'; -- Name ends with 't'.

-- I want all the customers who's starting with anything, ending with anything but in between they should have 'ven'.
SELECT *
FROM orders 
WHERE customer_name LIKE '%ven%';

SELECT *
FROM orders 
WHERE customer_name LIKE 'A%a' -- You can have anything in between 'A' 'a'.

------ What if database is case sensitive? We can use UPPER() function to make all caps and then search for it

SELECT order_id, order_date, customer_id, customer_name, UPPER(customer_name)
FROM orders
WHERE UPPER(customer_name) LIKE 'A%A'

SELECT *
FROM orders 
WHERE UPPER(customer_name) LIKE '_L%' -- means 2nd charecter must be 'L'

SELECT *
FROM orders
WHERE UPPER(customer_name) LIKE '_L%' ESCAPE '%' -- If you want to find '%' in the name

-- The should starts with 'C' and in the second position I want 'a' or 'l' then we have to use [al]
SELECT *
FROM orders 
WHERE customer_name LIKE 'C[al]%';

-- What if you don't want your second character to be [al]
SELECT *
FROM orders 
WHERE customer_name LIKE 'C[^al]%';

-- What if you want a second character between 'a' and 'o'
SELECT *
FROM orders 
WHERE customer_name LIKE 'C[a-o]%'

SELECT *
FROM orders 
WHERE order_id LIKE 'CA-202[1-2]%';

----------------------------------- WORKING with NULL -------------------------------

SELECT *
FROM orders 
WHERE city IS NULL; 

SELECT *
FROM orders 
WHERE city IS NOT NULL;


--------------------------------- Aggregate Functions ------------------------------------

/* All aggregate function gives a single line output. This is an IMP information
*/

SELECT COUNT(*) as cnt 
FROM orders;

SELECT SUM(sales) as total_sales
FROM orders;

SELECT MAX(sales) as max_sales, MIN(sales) as min_sales, AVG(sales) as avg_sales
FROM orders;

----------------------------- GROUP BY -------------------------------------

SELECT region, SUM(sales), MAX(sales)
FROM orders 
GROUP BY region; -- By using GROUP BY, we are indirectly using DISTINCT because there is "group" for every region

SELECT category, region, SUM(sales), MAX(sales)
FROM orders 
GROUP BY region, category; -- Now the data is grouped on region and category means it is a combination of both and each combination is unique

-- Q) What will happen here?

SELECT category, region, SUM(sales) as total_sales
FROM orders 
GROUP BY region;

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


-------------------- Filtering on aggregated values ----------------------

SELECT sub_category, SUM(sales) as total_sales 
FROM orders 
WHERE profit > 50
GROUP BY sub_category
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC -- Order of execution FROM --> WHERE --> GROUP BY --> HAVING --> SELECT --> ORDER BY



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

 
----------------------------- DAY 3 ----------------------------

SELECT * FROM orders; -- 9994 rows
SELECT * FROM returns; -- 296 rows    

---------------- JOINS

-- 1) INNER JOIN (The INNER JOIN keyword returns only rows with a match in both tables.)

SELECT o.order_id, o.order_date, return_reason
FROM orders o
INNER JOIN returns r 
ON o.order_id = r.order_id;  -- 800 rows


SELECT DISTINCT o.order_id
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id; -- 296 rows. All the "order_id" in "returns" table are present in "orders" and all are unique that's why 296 rows

SELECT DISTINCT r.order_id
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id; -- Same as above

SELECT DISTINCT o.*, return_reason
FROM orders o 
INNER jOIN returns r 
ON o.order_id = r.order_id; -- SO we joined two tables in "order_id" but 1 order might contain more than 1 product and each product have different "product_id". Now let's assume that
-- in 1 "order_id" there are 3 products. Maybe only 1 product is return and not all but if we joined on "order_id" it says that all the product of that order have been returned. So
-- if we want to find only returned prodcut, "inner join" is not good option.



-- 2) LEFT JOIN (The LEFT JOIN keyword returns all records from the left table (table1), and the matching records from the right table (table2). The result is 0 records from the right side, if there is no match.)

-- Q) I want all the records which are not present in returns table meaning I want records which are not being return (Interview question)

SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret 
FROM orders o 
LEFT JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL;

-- How much sales I lost because of return orders?
SELECT r.return_reason, SUM(sales) as total_sales
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id
GROUP BY return_reason;

SELECT SUM(sales) as total_sales
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id;

----------------------------- FOR CROSS JOIN ----------------------------------

/* In cross join you will get (number of records in 1 table)*(number of records in another) as number of output.
*/
create table employee(
emp_id int,
emp_name varchar(20),
dept_id int,
salary int,
manager_id int,
emp_age int
);


insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);
select * from employee;


create table dept(
dep_id int,
dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');
select * from dept;

SELECT * FROM employee  -- 10 records
SELECT * FROM dept  --  4 rows


--- New syntax.
SELECT *
FROM employee, dept 
ORDER BY employee.emp_id; -- 40 records. (10*4) because of cross-join.

SELECT *
FROM employee
INNER JOIN dept 
ON 1=1 
ORDER BY employee.emp_id; -- same query as above.

SELECT *
FROM employee
LEFT JOIN dept 
ON 1=1
ORDER BY employee.emp_id;

SELECT *
FROM employee e 
INNER JOIN dept d
ON e.dept_id = d.dep_id;

SELECT *
FROM employee e 
LEFT JOIN dept d
ON e.dept_id = d.dep_id;

SELECT e.emp_id, e.emp_name, e.dept_id,d.dep_id, d.dep_name
FROM employee e
FULL OUTER JOIN dept d
ON e.dept_id = d.dep_id ------- Whatever common in left both table will come and also whatever unique in both tables will also come. 11 rows.

/* FULL OUTER JOIN is very different from UNION ALL because UNION ALL will not join the records from both tables even though they have common joining ID and 
if you take a COUNT of that query, then in this case it will be 14 but count of FULL OUTER JOIN is 11 */


CREATE TABLE people
(
manager VARCHAR(20),
region VARCHAR(10)
)
DROP TABLE people
INSERT INTO people
VALUES('Ankit','West')
,('Deepak','East')
,('Vishal','Central')
,('Sanjay','South')


SELECT * FROM people
SELECT * FROM orders

SELECT o.order_id , o.product_id, r.return_reason, p.manager
FROM orders o
INNER JOIN returns r ON o.order_id = r.order_id
INNER JOIN people p ON p.region = o.region
-- You can also use the returns table if there is the same column. AND the result of first inner join will be inner joined with people table


SELECT * FROM employee; -- manager_id is referring to employee_id. 

-- I want to know the manager name
SELECT e1.emp_id,e1.emp_name AS emp_name ,e2.emp_id AS manager_id,e2.emp_name AS manager_name
FROM employee e1
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id; 

-- Find the employee whose salary is greater than his/her manager
SELECT e1.emp_id, e1.emp_name, e2.emp_id AS manager_id, e2.emp_name AS manager_name, e1.salary AS emp_sal, e2.salary AS man_sal
FROM employee e1
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id;

SELECT e1.emp_id, e1.emp_name, e2.emp_id AS manager_id, e2.emp_name AS manager_name, e1.salary AS emp_sal, e2.salary AS man_sal
FROM employee e1
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id
WHERE e1.salary > e2.salary;

----------------------------- STRING Functions ---------------------------------

-- STRING_AGG (Basically aggreagte string using group_by clause)

SELECT STRING_AGG(emp_name, ',') AS list_of_employees
FROM employee

SELECT dept_id, STRING_AGG(emp_name, ',') AS list_of_employees -- separated by ','
FROM employee
GROUP BY dept_id;

SELECT dept_id, STRING_AGG(emp_name, ':') WITHIN GROUP (ORDER BY emp_name) AS list_of_employees
FROM employee
GROUP BY dept_id;

SELECT dept_id, STRING_AGG(emp_name, ':') WITHIN GROUP (ORDER BY salary DESC) AS list_name 
FROM employee
GROUP BY dept_id;

-------------------------------- DATE Functions ----------------------------------

SELECT order_id, order_date
FROM orders;

----- DATEPART function :- extracting year, month and day from date.

SELECT order_id, order_date, DATEPART(year, order_date) AS year_of_orders
FROM orders;

SELECT order_id, DATEPART(month, order_date) AS month_of_order, DATEPART(week, order_date) AS week_of_order, DATEPART(WEEKDAY, order_date) AS day_of_orders
FROM orders

/* yyyy - Year
q - Quarter
m - Month
y - Day of year
d - Day
w - Weekday
ww - Week of year
h - Hour
n - Minute
s - Second */


--------- DATEADD Function :- Add and sustract something from date

SELECT order_id, order_date,
DATEADD(day,5,order_date) as day_of_orders -- Adding 5 days in order_date
FROM orders;

SELECT order_id, order_date,
DATEADD(week,5,order_date) AS week_of_orders
FROM orders;

SELECT order_id, order_date, 
DATEADD(week, -5, order_date) as day_of_orders
FROM orders; -- remove 5 weeks from order_date

--------------- DATEDIFF function :- Difference between two dates

SELECT order_id, order_date,
DATEDIFF(day, order_date, ship_date) AS days_diff_in_day
FROM orders;

SELECT order_id, order_date,
DATEDIFF(week,order_date,ship_date) AS weeks_diff
FROM orders;

----------------------- CASE WHEN FUNCTION --------------------------

/* CASE statements are executed from TOP to BOTTOM. If one condition is satisfied then it will stop. */

SELECT order_id, profit,
CASE 
WHEN profit < 100 THEN 'Low Profit'
WHEN profit < 250 THEN 'Medium Profit'
WHEN profit < 400 THEN 'High Profit'
ELSE 'Very high profit'
END AS profit_category
FROM orders
ORDER BY profit DESC;

/*  There won't be any 'low profit' because we put medium profit above 'low profit' */
SELECT order_id, profit,
CASE 
WHEN profit < 250 THEN 'Medium Profit'
WHEN profit < 100 THEN 'Low Profit'
WHEN profit < 400 THEN 'High Profit'
ELSE 'Very high profit'
END  AS profit_category
FROM orders
ORDER BY profit DESC;


------------------------------------ DAY 4 ------------------------------------

--------  STRING functions

-- 1) LEN
SELECT order_id, customer_name,
LEN(customer_name) AS len_of_cus,
LEN('   Claire Gute       ') AS len_with_space -- It is counting spaces before 'Claire' also but not counting after 'Gute'.
FROM orders

-- 2) LEFT, RIGHT :- give number of characters (space also included and starts from 1)
SELECT order_id, customer_name,
LEFT(customer_name,4) AS left_char,
RIGHT(customer_name,6) AS right_char
FROM orders

-- 3) SUBSTRING :- If you want string in between
SELECT order_id, customer_name,
SUBSTRING(customer_name,4,5) -- starts from 4th character and give me 5 more including 4th letter
FROM orders 

-- 4) CHARINDEX :- It gives posistion of the character. 
SELECT order_id, customer_name,
CHARINDEX(' ', customer_name) AS space_position, -- Gives 1st occurrence.
CHARINDEX('C', customer_name) AS C_position,
CHARINDEX('c', customer_name) AS c_position, -- case sensitive
CHARINDEX('n', customer_name) AS n_position, -- If it is repeating, then it will give the position of the first occurrence.
CHARINDEX('n', customer_name,5) AS from_5th_to_find_n_position,
CHARINDEX('n', customer_name,11) AS from_11th_to_find_n_position,
CHARINDEX('n',customer_name,CHARINDEX('n', customer_name)+1) AS from_second_position_onwards
FROM orders

-- 5) CONCAT :- Attach two columns
SELECT order_id, customer_name,
CONCAT(order_id, customer_name) AS concated_without_space,
CONCAT(order_id, ' ', customer_name) AS concated_with_space,
(order_id+customer_name) AS by_using_sign,
(order_id+' '+customer_name) AS adding_space_also
FROM orders 

-- 6) REPLACE 
SELECT order_id, customer_name,
REPLACE(order_id, 'CA','PB') AS replaced_CA_to_PB_in_order_id,
REPLACE(customer_name, 'A','B') AS A_is_replaced_with_B
FROM orders

-- 7) TRANSLATE :- It will replace character by character
SELECT order_id, customer_name,
TRANSLATE(customer_name, 'AG','TA') AS A_with_T_and_G_with_A -- case sensitive
FROM orders

-- 8) REVERSE 
SELECT order_id, customer_name,
REVERSE(customer_name) AS reversed_name
FROM orders

-- TRIM 
SELECT TRIM('  Siddhesh     ') AS removed_sapce,
TRIM(' Siddhesh Daphane     '         ) AS doesnt_remove_inbetween_space
FROM orders

--- All IMP string functions
SELECT 'Siddhesh Daphane',
LEFT('Siddhesh Daphane',4) AS left_char,
RIGHT('Siddhesh Daphane', 6) AS right_char,
SUBSTRING('Siddhesh Daphane', 4, 5) AS char_in_between,
SUBSTRING('Siddhesh Daphane', 4, 4) AS year_in_order_id,  -- 4 is included here.
CHARINDEX(' ', 'Siddhesh Daphane') AS space_position,
CHARINDEX('S', 'Siddhesh Daphane') AS C_position,
CHARINDEX('s', 'Siddhesh Daphane') AS C_position, -- case sensitive
CHARINDEX('d', 'Siddhesh Daphane') AS n_position, -- If it is repeating, then it will give the position of the first occurrence.
CHARINDEX('d', 'Siddhesh Daphane',5) AS from_5th_to_find_n_position,
CHARINDEX('d', 'Siddhesh Daphane',11) AS from_11th_to_find_n_position,
CHARINDEX('d', 'Siddhesh Daphane',CHARINDEX('n', customer_name)+1) AS from_second_position_onwards,
CONCAT('My name is', 'Siddhesh Daphane') AS concated_without_space, -- Attached without space
CONCAT('My name is',' ', 'Siddhesh Daphane') AS concated_with_space,
('My name is'+'Siddhesh Daphane') AS by_using_sign,
('My name is'+' '+ 'Siddhesh Daphane') AS adding_space_also,
REPLACE('Siddhesh Daphane', ' ','+') AS space_is_replaced_with_sign, -- Case Sensitive
TRANSLATE('Siddhesh Daphane','AG','TA') AS A_with_T_and_G_with_A,
REVERSE('Siddhesh Daphane') AS reversed_name,
TRIM(' Siddhesh    ') AS removed_spaces,
TRIM(' Siddhesh Daphane    '    ) AS Doesnt_remove_in_between_spaces
FROM orders

---- NULL handling functions

SELECT order_id, city
FROM orders
WHERE city is NULL;

-- ISNULL function --> replace the null value with what you gave

SELECT order_id, city,
ISNULL(city,'unknown') AS new_city
FROM orders;

-- COALESCE ------> Can take multiple values and it takes first not null values
SELECT order_id, city, state, 
COALESCE(city,state,region,'unknown') -- If city is null, it will take State value, if state is NULL, it will take region value and if everything is null then it will take unknown value that we gave
FROM orders
WHERE city IS NULL;

-------------------------------- CAST and ROUND Function ---------------------------------
SELECT top 5 order_id, sales,
CAST(sales as INT) AS sales_int,
ROUND(sales,1) AS rounded_value
FROM orders;  


--------------------------------- SET functions or Queries ------------------------------

-- 1) UNION ALL - It will just combine the data. We will get all the rows from both columns.

CREATE TABLE orders_west 
(
order_id int,
region varchar(10),
sales int 
)


CREATE TABLE orders_east
(
order_id int,
region varchar(10),
sales int 
)


INSERT INTO order_west values(1, 'west', 100), (2, 'west', 200)
INSERT INTO order_west values(3, 'east', 100)

INSERT INTO order_east values(3, 'east', 100), (2, 'east', 300)
INSERT INTO order_west values(1, 'west', 100)

/* Data type and number of columns must be same in both select statement.  */

SELECT * FROM order_west
UNION ALL 
SELECT * FROM order_east

-- UNION --> Will remove the duplicate 
SELECT * FROM order_west
UNION 
SELECT * FROM order_east


-- INTERSECT ---> Will give common record. 
SELECT * FROM order_west
INTERSECT
SELECT * FROM order_east

-- We can use on any column. Name can be different but data type and number of columns must be same
SELECT order_id, sales
FROM order_west
INTERSECT 
SELECT order_id, sales
FROM order_east

-- Output will be nothing because we are INTERSECTING sales to order_id. But this query will not give an error. 
SELECT sales, order_id
FROM order_west
INTERSECT 
SELECT order_id, sales
FROM order_east 


-- EXCEPT --> Showing records without any common in both tables. 

SELECT * FROM order_west
EXCEPT
SELECT * FROM order_east -- This only shows the record in one table i.e. order_west


-- This query gives the ouput from both tables. 
(SELECT *
FROM order_west
INTERSECT 
SELECT *
FROM order_east)
UNION ALL
(SELECT * FROM order_west
EXCEPT
SELECT * FROM order_east) 

-- NULL also get returned in output in INTERSECT
SELECT *, NULL FROM order_west
INTERSECT
SELECT *, NULL FROM order_east


-- UNION ALL ------> Gives all the values
-- UNION ----------> Removes the duplicates and then gives the output
-- INTERSECT ------> Gives common records only. (This also removes the duplicates)
-- EXCEPT ---------> Give the record which are not common in both tables


/* Only UNION ALL will give duplicates and all other will remove the dublicates */


----------------------------- DAY 5 ----------------------------------


----------------------- CONSTRAINTS -------------------------------

select * from employee
select * from dept

-- REFERENCES :- Basically I am referencing primary key of the of 'dept' table which is 'dept_id'
CREATE TABLE emp 
(
emp_id INT,
emp_name VARCHAR(10),
dept_id INT references dept(dept_id)
)

--  I am altering the table because primary key was not defined and it should be NOT NULL because of primary key. 
ALTER TABLE dept ALTER COLUMN dep_id INT NOT NULL
ALTER TABLE dept ADD CONSTRAINT primary_key PRIMARY KEY(dep_id)


INSERT INTO emp VALUES (1,'Siddhesh',100)
INSERT INTO emp VALUES (1,'Siddhesh')
INSERT INTO emp VALUES (1,'Siddhesh',500) -- This will give an error because of reference constraint. The error is becasue of 500 because it is not present in 'dept' table.

SELECT * from emp 

----------------- IDENTITY ------------------

/* So if you don't have primary key in a particular table, then we can use IDENTITY to generate the keys.
In this case, identity(1,1) means start with 1 and increament by 1.   */ 

drop table dept1 
CREATE TABLE dept1
(
id INT identity(1,1), -- first '1' is starting and second '1' is increament by. 
dep_id INT,
dep_name VARCHAR(10) 
)

INSERT INTO dept1(dep_id, dep_name) VALUES (100,'HR')
INSERT INTO dept1(dep_id, dep_name) VALUES (200,'Analytics')
INSERT INTO dept1(dep_id, dep_name) VALUES (300,'RnD')
INSERT INTO dept1 VALUES (400,'ML') -- Don't need to give names of columns. It identify itself.

select * from dept1 

------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE items 
(
  sub_category varchar(30),
  order_date DATE,
  sales INT
);



INSERT INTO items VALUES ('chairs','2019-01-01',100);
INSERT INTO items VALUES ('chairs','2019-10-10',200);
INSERT INTO items VALUES ('bookcases','2019-01-01',300);
INSERT INTO items VALUES ('bookcases','2020-10-10',400);

SELECT sub_category, SUM(sales) as total_sales, MAX(order_date)
FROM items
GROUP BY sub_category
HAVING MAX(order_date) > '2020-01-01'
ORDER BY total_sales DESC;

select * from items;

SELECT sub_category, SUM(sales) as total_sales, MAX(order_date)
FROM items
WHERE (order_date) > '2020-01-01'
GROUP BY sub_category
ORDER BY total_sales DESC;





select * from orders;
select * from returns;


SELECT o.order_id, o.order_date, return_reason
FROM orders o
INNER JOIN returns r 
ON o.order_id = r.order_id;




------------------------ SUB-QUERY --------------------------------

