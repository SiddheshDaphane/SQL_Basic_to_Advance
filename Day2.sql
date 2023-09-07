/* We created a table with column 'order_date' which saves the 'date' format in it but I also wants to save time when order is placed.
Here comes the ALTER TABLE command. When we create a table and after sometime we want to change the characteristics of the table,
we can use this command. By using this command, we can change the table without deleting the data.
This is a DDL because we are changing defination of a data. 
*/

CREATE TABLE amazon_orders
(
order_id INT,
order_date DATE,
product_name VARCHAR(50),
total DECIMAL(10,2),
payment_method VARCHAR(20)
);

ALTER TABLE amazon_orders ALTER COLUMN order_date DATETIME -- Datetime is new data type

SELECT *
FROM amazon_orders 

INSERT INTO amazon_orders VALUES(5,'2022-10-01 04:28:30', 'Baby watch', 159, 'UPI'); 

/* After creating a table you realise that you have forgot to add a column or you want to enhance a table by adding a new column.
ALTER TABLE and ADD COLUMN, will add a new column and it will be diaplayed at the last
*/

ALTER TABLE amazon_orders ADD COLUMN user_name VARCHAR(20) -- Datetime is new data type

SELECT *
FROM amazon_orders 

/* What is NULL? NULL is a special keyword or character in SQL which is UNKNOWN. NULL means UNKNOWN.
If you give 'NULL' like this, it will treated as a string and not a NULL
*/
INSERT INTO amazon_orders VALUES(6,'2022-10-02 10:08:03', NULL, 15, 'UPI',"Siddhesh"); 
INSERT INTO amazon_orders VALUES(7,'2022-10-09 10:08:03', 'NULL', 15, 'UPI',"Shubham"); 

/* After adding a new column in a table, the old INSERT statements will not run because number of columns and number of values 
that we are inserting should be same.
*/

/* Now you added a column but then you realise that you don't need that column, then you use DROP COLUMN statement
*/
ALTER TABLE amazon_orders ADD COLUMN category VARCHAR(20) -- Added a new column to use DROP COLUMN
ALTER TABLE amazon_orders DROP COLUMN category -- deleting a column

SELECT *
FROM amazon_orders 

-- When you alter a datatype of a column, it should be compatible. Meaning you cannot change INT to DATE because that is not possible unless table is empty

---------------- CONSTRAINTS ------------------

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

INSERT INTO a_orders VALUES(NULL,'2022-10-02', NULL, 15, 'UPI'); -- Because we set NOT NULL constraint on order_id, this statement will give an error

INSERT INTO a_orders VALUES(1,'2022-10-02', NULL, 15, 'Internate Banking'); -- Because we set CHECK constraint on payment_method, this statement will give an error

INSERT INTO a_orders VALUES(2,'2022-10-02', NULL, 15, 'Internate Banking',24); -- Because we set CHECK constraint on discount, this statement will give an error

INSERT INTO a_orders VALUES(1,'2022-10-05', NULL, 150, 'UPI'); -- Because we set UNIQUE constraint on order_id, this statement will give an error

INSERT INTO a_orders VALUES(3,'2022-10-02', NULL, 15, 'Internate Banking',15, 'Kids wear'); 
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