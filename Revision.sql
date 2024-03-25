-- Day 1 

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