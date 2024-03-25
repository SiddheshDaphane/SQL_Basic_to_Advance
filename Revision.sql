-- Day 1 
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