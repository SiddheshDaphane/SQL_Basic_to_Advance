--4- write a query to print emp name, salary and dep id of highest salaried employee in each department ;

select * from employee
order by dept_id, salary desc;


select * ,
row_number() over(partition by dept_id order by salary desc) as rn
,rank() over(partition by dept_id order by salary desc) as rnk
,dense_rank() over(partition by dept_id order by salary desc) as d_rnk
from employee;
---to print top 5 selling products from each category by sales

select * 
,rank() over(partition by category order by sales desc) as rn
from orders;

with cat_product_sales as (
select category,product_id,sum(sales) as category_sales
from orders
group by category,product_id )
,rnk_sales as (select *
,rank() over(partition by category order by category_sales desc) as rn
from cat_product_sales)
select * from
rnk_sales
where rn<=5;

with cat_product_sales as (
select category,product_id,sum(sales) as category_sales
from orders
group by category,product_id )
,rnk_sales as (select *
,rank() over(partition by category order by category_sales desc) as rn
from cat_product_sales)
select * from
rnk_sales
where rn<=5;

select * ,
lead(salary,1) over(partition by dept_id order by emp_name desc) as lead_sal
,first_value(salary) over(partition by dept_id order by emp_name desc) as last_value
from employee;

























	








