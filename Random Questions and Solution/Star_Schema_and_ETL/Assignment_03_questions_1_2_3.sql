-- Q1) Run northwind.sql to create tables and insert data

SELECT *
FROM categories;

SELECT *
FROM customers;

SELECT *
FROM employees;

SELECT *
FROM order_details;

SELECT *
FROM orders;

SELECT *
FROM products;

SELECT *
FROM shippers;

SELECT *
FROM suppliers;


-- Q2)  Show normalized tables row counts 

SELECT COUNT(*) AS row_count_table_01
FROM categories;

SELECT COUNT(*) AS row_count_table_02
FROM customers;

SELECT COUNT(*) AS row_count_table_02
FROM employees;

SELECT COUNT(*) AS row_count_table_02
FROM order_details;

SELECT COUNT(*) AS row_count_table_02
FROM orders;

SELECT COUNT(*) AS row_count_table_02
FROM products;

SELECT COUNT(*) AS row_count_table_02
FROM shippers;

SELECT COUNT(*) AS row_count_table_02
FROM suppliers;

SELECT SUM(row_counts) AS no_of_rows
FROM (
	(SELECT COUNT(*) AS row_counts 
	FROM categories)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM customers)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM employees)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM order_details)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM orders)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM products)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM shippers)
	UNION ALL
	(SELECT COUNT(*) AS row_counts
	FROM suppliers)) AS counts; 
	
	
select * from employees;

select * from categories;

select * from suppliers;

select * from shippers;

select * from customers;

select o.*, s.* 
from orders o 
INNER join shippers s 
on o.shipper_id = s.shipper_id;


select p.*, s.*
from products p 
LEFT JOIN suppliers s 
ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;

select o.*, c.*
FROM orders o 
INNER JOIN customers c 
ON o.customer_id = c.customer_id;



SELECT 
EXTRACT (year from order_date) as year
FROM orders;

select * 
FROM order_details os 
INNER JOIN orders o 
ON os.order_id = o.order_id;

