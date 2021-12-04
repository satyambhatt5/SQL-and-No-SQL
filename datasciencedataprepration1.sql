show databases;


Use classicmodels;
select *from customers;
select *from offices;
select * from employees;
select *from orderdetails;
select *from orders;
select *from payments;
select *from productlines;
select *from products;
--dataser profile 
select *
from customers 
natural join orders;

--velocity 

--DAYOFYEAR
--https://www.tutorialspoint.com/sql/sql-date-functions.htm#function_day
--https://intellipaat.com/blog/tutorial/sql-tutorial/sql-formatting/
SELECT LAST_DAY(orderdate) AS orderday
FROM orders;

Select 
DAYOFYEAR(orderdate) AS orderday,
dayofweek(orderdate) as dayofweek,
DAYOFMONTH(orderdate) as dayofmonth,
DAYNAME(orderdate) as dayname,
MONTHNAME(orderdate) as monthname,
QUARTER(orderdate) as quarter,
week(orderdate) as week,
weekday(orderdate) as weekdays,
YEAR(orderdate) as year
FROM orders;

SELECT NOW();
















