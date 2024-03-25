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


ALTER TABLE amazon_orders ALTER COLUMN order_date DATETIME -- Datetime is new data type

INSERT INTO amazon_orders VALUES(5,'2022-10-01 04:28:30', 'Baby watch', 159, 'UPI');

-- Now you want to add new column to table.

ALTER TABLE amazon_orders ADD COLUMN user_name VARCHAR(20) -- New column is added.