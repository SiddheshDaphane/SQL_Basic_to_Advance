select column_name, data_type from information_schema.columns where table_name = 'date_dim';
select column_name, data_type from information_schema.columns where table_name = 'employees_dim';
select column_name, data_type from information_schema.columns where table_name = 'customers_dim';
select column_name, data_type from information_schema.columns where table_name = 'shipper_dim';
select column_name, data_type from information_schema.columns where table_name = 'product_supplier_dim';
select column_name, data_type from information_schema.columns where table_name = 'sales_fact';



-- Populating dimension table and fact table.

INSERT INTO date_dim
(date_key,date,year,quarter,month,week,day,is_weekend)
SELECT
	DISTINCT (TO_CHAR (order_date :: DATE, 'yyyMMDD')::integer) as date_key,
	date (order_date) as date,
	EXTRACT (year from order_date) as year,
	EXTRACT (quarter FROM order_date) as quarter,
	EXTRACT (month FROM order_date) as month,
	EXTRACT (day FROM order_date) as day,
	EXTRACT (week FROM order_date) as week,
	(CASE WHEN EXTRACT (ISODOW FROM order_date) IN (6, 7) THEN true ELSE false END) AS is_weekend
FROM orders;

select * from date_dim;


INSERT INTO employees_dim 
(employee_id, last_name, first_name, birth_date, photo, notes)
SELECT 
	employee_id AS employee_id,
	last_name AS last_name,
	first_name AS first_name,
	birth_date AS birth_date,
	photo AS photo,
	notes AS notes
FROM employees

select * from employees_dim;


INSERT INTO shipper_dim
(shipper_id, shipper_name, shipper_phone)
SELECT 
	shipper_id AS shipper_id,
	shipper_name AS shipper_name,
	phone AS shipper_name
FROM shippers;

select * from shipper_dim;



INSERT INTO product_supplier_dim
(product_id,product_name,category_id,category_name,category_description,supplier_id,
 supplier_name,supplier_contact_name,supplier_address,supplier_city,supplier_postal_code,
 supplier_country,supplier_phone,product_unit)

SELECT
	p.product_id AS product_id,
	p.product_name AS product_name,
	c.category_id AS category_id,
	c.category_name AS category_name,
	c.description AS category_description,
	s.supplier_id AS supplier_id,
	s.supplier_name AS supplier_name,
	s.contact_name AS supplier_contact_name,
	s.address AS supplier_address,
	s.city AS supplier_city,
	s.postal_code AS supplier_postal_code,
	s.country AS supplier_country,
	s.phone AS supplier_phone,
	p.unit AS product_unit
FROM products p
INNER JOIN categories c 
ON p.category_id = c.category_id
INNER JOIN suppliers s
ON p.supplier_id = s.supplier_id

select * from product_supplier_dim;




INSERT INTO customers_dim
(customer_id,customer_name,customer_contact_name,customer_address,customer_city,
 customer_postal_code,customer_country)
SELECT 
	customer_id AS customer_id,
	customer_name AS customer_name,
	contact_name AS customer_contact_name,
	address AS customer_address,
	city AS customer_city,
	postal_code AS customer_postal_code,
	country AS customer_country
FROM customers

select * from customers_dim;




CREATE TEMP TABLE vt_ship AS (
	SELECT MAX(s.shipper_id) AS shipper_key, o.shipper_id, o.order_id
FROM orders o 
LEFT JOIN shipper_dim s
ON o.shipper_id = s.shipper_id
GROUP BY o.shipper_id, o.order_id);


INSERT INTO sales_fact
   (order_detail_id ,
    order_id ,
    order_quantity ,
    order_date ,
    date_key ,
    product_key ,
    customer_key ,
    employee_key ,
    shipper_key,
   	product_price
   	)
   select od.order_detail_id ,
    od.order_id ,
    od.quantity ,
    o.order_date ,
    d.date_key  ,
    max(pd.product_supplier_key) as product_key,
    max(c.customer_key) as customer_key,
    max(e.employee_key) as employee_key,
    max(s.shipper_key) as shipper_key,
	p.price AS product_price
	from orders o 
	inner join 
	(order_details od inner join product_supplier_dim pd on od.product_id = pd.product_id)
	on o.order_id = od.order_id
	inner join date_dim d on date (o.order_date) = d.date
	inner join customers_dim c on o.customer_id = c.customer_id
	inner join employees_dim e on o.employee_id = e.employee_id
	inner join shipper_dim s on o.shipper_id = s.shipper_id
	inner join products p on p.product_id= pd.product_id
	group by 1,2,3,4,5,10;




INSERT INTO sales_fact
   (order_detail_id ,
    order_id ,
    order_quantity ,
    order_date ,
    date_key ,
    product_key ,
    customer_key ,
    employee_key ,
    shipper_key,
   	product_price
   	)
   select ord.order_detail_id ,
    ord.order_id ,
    ord.quantity ,
    ord1.order_date ,
    dd.date_key  ,
    max(pd.product_supplier_key) as product_key,
    max(cg.customer_key) as customer_key,
    max(emp.employee_key) as employee_key,
    max(sp.shipper_key) as shipper_key,
	p.price AS product_price
	from orders ord1 
	inner join 
	(order_details ord inner join product_supplier_dim pd on ord.product_id = pd.product_id)
	on ord1.order_id = ord.order_id
	inner join date_dim dd on date (ord1.order_date) = dd.date
	inner join customers_dim cg on ord1.customer_id = cg.customer_id
	inner join employees_dim emp on ord1.employee_id = emp.employee_id
	inner join shipper_dim sp on ord1.shipper_id = sp.shipper_id
	inner join products p on p.product_id= pd.product_id
	group by 1,2,3,4,5,10;



UPDATE sales_fact SET dollar_sales = product_price * order_quantity

select * from sales_fact



-- Show the star schema tables row counts (6 tables)

SELECT COUNT(*) AS total_count FROM employees_dim;
SELECT COUNT(*) AS total_count FROM customers_dim;
SELECT COUNT(*) AS total_count FROM shipper_dim;
SELECT COUNT(*) AS total_count FROM product_supplier_dim;
SELECT COUNT(*) AS total_count FROM date_dim;
SELECT COUNT(*) AS total_count FROM sales_fact;





--Write SQL query from star schema to get rounded dollar sales
--grouped by product category and customer country, ordered by dollar sales descending



SELECT pd.category_name, c.customer_country,round(SUM(dollar_sales)) AS dollar_sales  
FROM sales_fact s
INNER JOIN product_supplier_dim pd 
ON s.product_key = pd.product_supplier_key
INNER JOIN customers_dim c 
ON s.customer_key = c.customer_key
GROUP BY pd.category_name,c.customer_country 
ORDER BY dollar_sales desc;








DELETE FROM sales_fact







