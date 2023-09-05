-- This is DDL (Data defination language). DDL is a part of SQL. The name itself suggests that you are defining the data that is data about data that is metadata. like dataypes and all

-- Creating a table (amazon_orders) with columns and it's data types
CREATE TABLE amazon_orders
(
order_id INT,
order_date DATE,
product_name VARCHAR(50),
total DECIMAL(10,2),
payment_method VARCHAR(20)
);

/*
data types --
INT ---> integer (1,2,3,4,5,6)
DATE ----> Date format ('2020-11-01') We can change this format also.
VARCHAR ----> String ('Baby Milk')
DECIMAL(10,2) -----> float (11.2,2.3,33.1) NOW(10,2) means, there will be 2 numbers out of 10 after decimal points which means to the left you can have 8 numbers 


Q) After creating it is saying "dbo.amazon_orders", What is dbo?
Ans = "dbo" is a schema. Schema means in the computer terms, it is a folder in a drive.
In PC, we have "C" drive and within that drive we have different folders. That folder is Schema in database
"dbo" is a default schema within this nasamteSQL database.
So different departments of a company will save their data in different schemas. 
*/


-- This is DML(Data Manipulation language). When you insert a data in a table then you use DML because you are changing the data but it doesn't change the defination of it

-- inserting data in table
INSERT INTO amazon_orders VALUES(1,'2022-10-01', 'Baby Milk', 30.5, 'UPI'); 
INSERT INTO amazon_orders VALUES(2,'2022-10-02', 'Baby Powder', 310.5, 'Credit Card'); 
INSERT INTO amazon_orders VALUES(3,'2022-10-01', 'Baby Cream', 30.5, 'UPI'); 
INSERT INTO amazon_orders VALUES(4,'2022-10-02', 'Baby Soap', 310.5, 'Credit Card'); 

-- Let's say, you don't want this "amazon_order" table, then we have "DROP" statement (deleting a table)
DROP TABLE amazon_orders;

-- Let's say you uploaded a wrong data but you want to keep the table, then we have "DELETE" statement (deleting data)
DELETE FROM amazon_orders; -- "Red line" because of "DROP" statement.

-- This is DQL(Data query language). When you just want to see the data from database then you query that database and that's why it DQL

-- Selecting all the data from amazon_orders table
SELECT *
FROM amazon_orders;

-- Selecting a column from a table
SELECT order_date
FROM amazon_orders;

-- Selecting a multiple columns from a table
SELECT order_date, product_name
FROM amazon_orders ;

-- You don't have to give column name in a order. Any order will give you data back
SELECT product_name, order_date
FROM amazon_orders ;

-- If you have a million records than running SELECT * is not efficient and thats why we have "TOP" command
SELECT TOP 5 *
FROM amazon_orders;

-- What if you want to see data in a particular order? Like lastest order to oldest order. For that we have ORDER BY clause
SELECT * 
FROM amazon_orders
ORDER BY order_date; -- so the data is sorted on order_date in ascending order. You can use different column here

SELECT * 
FROM amazon_orders
ORDER BY order_date DESC; -- It is sorted in descending order

SELECT * 
FROM amazon_orders
ORDER BY product_name DESC; -- You can also sort on "string" data type i.e. VARCHAR

SELECT * 
FROM amazon_orders
ORDER BY order_date DESC, product_name; -- This will first sort on order_date in descending order and if the date is same then it will sort by name in ascending order

-- I have inserted a database and saved it as "orders" for future queries