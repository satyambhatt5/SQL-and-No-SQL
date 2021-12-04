
SHOW DATABASES;
USE classicmodels;
#SELECT [ ALL | DISTINCT | DISTINCTROW ]
#      [ HIGH_PRIORITY ]
#      [ STRAIGHT_JOIN ]
#      [ SQL_SMALL_RESULT | SQL_BIG_RESULT ] [ SQL_BUFFER_RESULT ]
#      [ SQL_CACHE | SQL_NO_CACHE ]
#      [ SQL_CALC_FOUND_ROWS ]
#expressions
#FROM tables
#[WHERE conditions]
#[GROUP BY expressions]
#[HAVING condition]
#[ORDER BY expression [ ASC | DESC ]]
#[LIMIT [offset_value] number_rows | LIMIT number_rows OFFSET offset_value]
#[PROCEDURE procedure_name]
#[INTO [ OUTFILE 'file_name' options 
#       | DUMPFILE 'file_name'
 #      | @variable1, @variable2, ... @variable_n]
#[FOR UPDATE | LOCK IN SHARE MODE];


SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM products;
SELECT * FROM productlines;
SELECT * FROM payments;
SELECT * FROM orders;
SELECT * FROM orderdetails;
##Select customer name from customer. Sort by customer name (122)
#List each of the different status that an order may be in (6)
#List firstname and lastname for each employee. Sort by lastname then firstname (23)
#List all the employee job titles (7)
#List all products along with their product scale (110)

select customername
from customers
order by customername;

select DISTINCT  status 
from orders
order by status;

select firstname ,lastname 
from employees
ORDER BY lastname,firstname;

select DISTINCT jobtitle 
from employees;

SELECT ProductName, ProductScale
FROM products;


#List all the territories where we have offices (4)
select distinct territory   
from offices
where territory !='NA';

#List orders made between June 16, 2014 and July 7, 2014
SELECT orderNumber
from orders
where orderDate between '2004-06-16' and '2004-07-07';

#List products that we need to reorder (quantityinstock < 1000)
select productname
from products 
where quantityinstock < 1000;
#List all orders that shipped after the required date
select ordernumber
from orders
where shippeddate > requiredDate;
#List all customers who have the word 'Mini' in their name
select customername
from customers
where customername like '%Mini%';
#List all products supplied by 'Highway 66 Mini Classics'
select count(productVendor)
from products
where productVendor = 'Highway 66 Mini Classics';

#List all product not supplied by 'Highway 66 Mini Classics'
select count(productvendor)
from products
where productvendor != 'Highway 66 Mini Classics';


select employeenumber
from employees
where reportsTo IS NULL;

#-- Natural Join A NATURAL JOIN is a JOIN operation that creates an implicit join clause for you based on the common 
#columns in the two tables being joined. Common columns are columns that have the same name in both tables.
#A NATURAL JOIN can be an INNER join, a LEFT OUTER join, or a RIGHT OUTER join. The default is INNER join.
#NATURAL JOIN OR JOIN   =    INNER JOIN  *IT means that we take common in both 
#NATURAL LEFT JOIN OR LEFT OUTER JOIN = LEFT JOIN    *we will take all from left and common from right  
#NATURAL RIGHT JOIN OR RIGHT OUTER JOIN = RIGHT JOIN *we will take all from right and common from left 
#SELF JOIN #IT TAKES THE VALUE FROM THE SAME TABLE 
#CROSS JOIN #MAKE A CONNECION FROM THE EACH TABLE AND MAKE NEW TABLEN

# Display every order along with the details of that order for order numbers 10270, 10272, 10279 (23)

SELECT 
ordernumber,productcode,quantityordered,priceeach,orderlinenumber
from Orders
natural join orderdetails
where ordernumber in (10270,10272,10279);

#List of productlines and vendors that supply the products in that productline.
select DISTINCT productline, productvendor
from products
natural join productlines;

#select customers that live in the same state as one of our offices (26
#SELECT distinct count(customername)
#from customers
#inner join (employees natural join offices as eo)
#on eo.state = customers.state;

select distinct count(customername)
from customers
join (employees natural join offices as eo)
on eo.state = customers.state;

#select customerName, orderDate, quantityOrdered, productLine, productName
# for all orders made and shipped in 2005

select customername, orderdate, quantityordered, productline, productname
from orders
natural join customers
natural join orderdetails
natural join products
where orderdate between '2005-01-01' and '2005-12-31'
and shippedDate BETWEEN '2005-01-01' and '2005-12-31';

#-- Outer Join-- 23.	List products that didn't sell (1)
select productname,orderNumber
from products
LEFT OUTER join orderdetails
on products.productCode=orderdetails.productCode
where ordernumber is null;

##List all customers and their sales rep even if they DO NOT   have a sales rep

SELECT DISTINCT customerName, salesRepEmployeeNumber
FROM customers
LEFT OUTER JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber;

#-- Aggregate Functions
#-- 25.	Find the total of all payments made by each customer (98)

select customername,sum(amount) as TotalPayment
FROM CUSTOMERS 
NATURAL JOIN payments
GROUP BY customername; 

#--Find the largest payment made by a customer
Select customername,MAX(AMOUNT) as MaxPayment
from customers
NATURAL JOIN payments;

--FIND THE AVG PAYMENT MADE BY A CUSTOMER 
SELECT CUSTOMERNAME,AVG(AMOUNT) as AvgPayment
FROM CUSTOMERS
NATURAL JOIN payments

#-- 28.	What is the total number of products per product line (7)
select productname,count(productline) as NumberOfProducts
from products
group by productline;

#--What is the number of orders per status (6)

select status,count(status) as NumberOfOrders
from orders
group by status;

#--List all offices and the number of employees working in each office
select officeCode,count(employeenumber) as NumberOfEmployees
from employees
group by officeCode;

#--List the total number of products per product line where number of products > 3 
select productline,count(productcode) as NumberOfProducts
from products
GROUP BY PRODUCTLINE
HAVING NumberOfProducts >3
ORDER BY NumberOfProducts DESC;

-- 32.List the orderNumber and order total for all orders that totaled more than $60,000.00.
select ordernumber,sum(priceeach*quantityordered) as Total
from orderdetails
group by ordernumber
having Total > 60000;
-- Computations
-- 33.	List the products and the profit that we have made on them.  
--      The profit in each order for a given product is (priceEach - buyPrice) * quantityOrdered.  
--      List the product's name and code with the total profit that we have earned selling that product.  
--      Order the rows descending by profit. 
--      Only show those products whose profit is greater than $60,000.00.

select productname,productcode,sum(priceeach-buyprice)*quantityordered as TotalProfit
from products
natural join orderdetails
GROUP BY productcode,productname
HAVING TotalProfit > 60000
ORDER BY TotalProfit DESC;

-- 34.	List the average of the money spent on each product across all orders 
--      where that product appears when the customer is based in Japan.  
--      Show these products in descending order by the average expenditure (45)

select productcode,avg(priceeach*quantityordered) as Avgexpend
from customers
natural join orders
natural join orderdetails
where country = 'Japan'
group by productcode
order by Avgexpend DESC;

-- 35.	What is the profit per product (MSRP-buyprice) (110)
Select productname,productcode,(msrp-buyprice) as ProfitperProduct
from products;

-- 36.	List the Customer Name and their total orders (quantity * priceEach) 
--      across all orders that the customer has ever placed with us,
--      in descending order by order total 
--      for those customers who have ordered more than $100,000.00 from us.
select customername,sum(quantityordered*priceeach) as TotalOrders
from customers  
Natural JOIN orders
natural join orderdetails
GROUP BY customername
HAVING Totalorders > 100000
ORDER BY TotalOrders DESC;

-- Set Operations
-- 37.	List all customers who didn't order in 2005 (78)
---- LISTS ALL THE customers even if they did not order a Product
select distinct count(customername)
from customers as c 
left outer join orders as o 
on c.customerNumber=o.customerNumber;


SELECT customerName From Customers
EXCEPT
SELECT DISTINCT customerName 
From Customers NATURAL JOIN Orders
WHERE YEAR(orderDate) = 2005;

-- 38.	List all people that we deal with (employees and customer contacts). 
--      Display first name, last name, company name (or employee) (145)
select  'Employee'  as"companyname" ,lastname as "Last name",firstname as "first name"
from employees
union
select customername as "companyname",contactlastname as "Last name",contactfirstname as "first name"
from customers;


-- 39.	List the last name, first name, and employee number of all of the employees who do not have any customers.  
--      Order by last name first, then the first name. (8)
----    SET OPERATION ANSWER FOR #39:

SELECT DISTINCT lastName, firstName, EmployeeNumber 
FROM Employees E INNER JOIN Customers C
ON E.employeeNumber = C.salesrepemployeenumber
ORDER BY lastname, firstname;

SELECT E.lastname, E.firstName, E.employeeNumber 
FROM Employees E 
LEFT OUTER JOIN Customers C 
ON E.employeeNumber = C.salesrepemployeenumber 
WHERE C.customerNumber IS NULL
ORDER BY lastname, firstname;

-- 40.	List the states and the country that the state is part of that have 
--      customers but not offices, 
--      offices but not customers,
--      or both one or more customers and one or more offices all in one query.  
--      Designate which state is which with the string 'Customer', 'Office', or 'Both'.  
--      If a state falls into the "Both" category, do not list it as a Customer or an Office state.
--      Order by the country, then the state.
--      Give the category column (where you list 'Customer', 'Office', or 'Both') a header of "Category"
--      and exclude any entries in which the state is null. (19)

-- 41.	List the Product Code and Product name of every product that has never been 
--      in an order in which the customer asked for more than 48 of them.  
--      Order by the Product Name.  (8)

select state,country
from customers
INNER JOIN (offices Natural JOIN   employees )
ON customers.salesrepemployeenumber = employees.employeenumber;

--41
select distinct productcode,productname
from orderdetails natural join products
where quantityordered > 48;

-- 42.	List the first name and last name of any customer who ordered any products
--      from either of the two product lines 'Trains' or 'Trucks and Buses'.
--      Do not use an "or".
--      Instead perform a union.  
--      Order by the customer�s name.  (61)
select distinct contactfirstname ,contactlastname
from customers 
natural join orders
natural join orderdetails
natural join products
where productline = 'Trains'

UNION

select distinct  contactfirstname ,contactlastname
from customers
natural join orders
natural join orderdetails
natural join products
where productline = 'Trucks and Buses'
ORDER BY contactlastname,contactfirstname;

-- Subqueries
-- 44.	What product that makes us the most money (qty*price) (1)
SELECT productName
FROM Products NATURAL JOIN OrderDetails
GROUP BY productName
HAVING SUM(quantityOrdered*priceEach) = 
(
    SELECT MAX(LIST_OF_PRODUCT_TOTALS.productTotal)
    FROM
    (
        SELECT  productCode, sum(quantityOrdered*priceEach) AS productTotal
        FROM  OrderDetails
        GROUP BY productCode
    ) AS LIST_OF_PRODUCT_TOTALS
);

-- 45.	List the product lines and vendors for product lines which are supported by < 5 vendors (3)
SELECT productLine, productVendor
FROM Products
WHERE productLine = 
(SELECT productLine FROM Products
GROUP BY productLine
HAVING count(productVendor) < 5);


-- 47.	Find the first name and last name of all customer contacts
--      whose customer is located in the same state as the San Francisco office

Select contactfirstname,contactlastname

from customers

where  state = ( select distinct state from customers where city ='San Francisco');

--What is the customer and sales person of the highest priced order?
SELECT customerName, salesRepEmployeeNumber
FROM Customers

WHERE customerNumber =
(
    SELECT customerNumber
    FROM Orders
    WHERE orderNumber = 
    (
        SELECT orderNumber
        FROM OrderDetails
        GROUP BY orderNumber
        HAVING sum(priceEach*quantityOrdered) =
        (
            SELECT MAX(OrderTotals.orderTotal)
            FROM 
            (
                SELECT sum(priceEach*quantityOrdered) AS orderTotal
                FROM OrderDetails
                GROUP BY orderNumber
            ) AS OrderTotals
        )
    )
);
-- 49.	What is the order number and the cost of the order for the most expensive orders?
--      Note that there could be more than one order which all happen to add up to the same cost,
--      and that same cost could be the highest cost among all orders
Select orderNumber, sum(priceEach*quantityOrdered)
from orderdetails
group by orderNumber
having sum(priceEach*quantityOrdered) =
(
    SELECT MAX(OrderTotals.orderTotal)
    FROM 
    (
        SELECT sum(priceEach*quantityOrdered) AS orderTotal
        FROM OrderDetails
        GROUP BY orderNumber
    )      AS OrderTotals
);

---- 50.	What is the name of the customer, the order number,
----     and the total cost of the most expensive orders? (1)
SELECT customerName, orderNumber, sum(priceEach*quantityOrdered) AS "Order Total"
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails
WHERE customerNumber =
(
    SELECT customerNumber
    FROM Orders
    WHERE orderNumber = 
    (
        SELECT orderNumber
        FROM OrderDetails
        GROUP BY orderNumber
        HAVING sum(priceEach*quantityOrdered) =
        (
            SELECT MAX(OrderTotals.orderTotal)
            FROM 
            (
                SELECT sum(priceEach*quantityOrdered) AS orderTotal
                FROM OrderDetails
                GROUP BY orderNumber
            ) AS OrderTotals
        )
    )
)
AND orderNumber =
(
    SELECT orderNumber
    FROM OrderDetails
    GROUP BY orderNumber
    HAVING sum(priceEach*quantityOrdered) =
    (
        SELECT MAX(OrderTotals.orderTotal)
        FROM 
        (
            SELECT sum(priceEach*quantityOrdered) AS orderTotal
            FROM OrderDetails
            GROUP BY orderNumber
        ) AS OrderTotals
    )
)
GROUP BY customerName, orderNumber;

-- 51.	Perform the above query using a view. (1)
----    YOU NEED TO RUN BOTH QUERIES BELOW:
----    However, in derby, there is no "OR REPLACE" so after the first time you
----    create the below view table, theres no way to replace it in the case
----    that some other order becomes the highest price order besides manually
----    dropping the view and running it again

CREATE VIEW V_ORDERNUMBER_OF_HIGHEST_PRICED_ORDER AS
(
    SELECT orderNumber
    FROM OrderDetails
    GROUP BY orderNumber
    HAVING sum(priceEach*quantityOrdered) =
    (
        SELECT MAX(OrderTotals.orderTotal)
        FROM 
        (
            SELECT sum(priceEach*quantityOrdered) AS orderTotal
            FROM OrderDetails
            GROUP BY orderNumber
        ) AS OrderTotals
    )
);

SELECT customerName, orderNumber, sum(priceEach*quantityOrdered) AS "Order Total"
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails
WHERE customerNumber =
(
    SELECT customerNumber
    FROM Orders
    WHERE orderNumber = (SELECT ordernumber FROM V_ORDERNUMBER_OF_HIGHEST_PRICED_ORDER)
)
AND orderNumber = (SELECT ordernumber FROM V_ORDERNUMBER_OF_HIGHEST_PRICED_ORDER)
GROUP BY customerName, orderNumber;

-- 52.	Show all of the customers who have ordered at least one product
--      with the name "Ford" in it, that "Dragon Souveniers, Ltd." has also ordered.  
--      List them in reverse alphabetical order,
--      and do not consider the case of the letters in the customer name in the ordering.
--      Show each customer no more than once. (61)
-- 53.	Which products have an MSRP within 5% of the average MSRP across all products?
--      List the Product Name, the MSRP, and the average MSRP ordered by the product MSRP. (14)
----    Full answer to (#53):

SELECT productName, MSRP, AVG(MSRP)
FROM products
GROUP BY productName, MSRP
HAVING msrp <=1.05*(select avg(msrp) from products)
AND msrp >= 0.95*(select avg(msrp) from products);

---- 58.	List all employees that have the same last name. Make sure each combination is listed only once (5)
select a.firstname, a.lastname,b.firstname, b.lastname
from employees a INNER JOIN employees b
on a.lastname = b.lastname
where a.employeenumber > b.employeenumber;

-- 59.	Select the name of each of two customers who have made at least one payment on the same date as the other.
--      Make sure that each pair of customers only appears once. (46)
----    BASE ANSWER FOR #59 (helpful for understanding):
SELECT A.customernumber, A.paymentdate, B.customernumber, B.paymentdate
FROM Payments A INNER JOIN Payments B
USING (paymentdate)
WHERE A.customernumber > B.CUSTOMERNUMBER;



 
























 



















































