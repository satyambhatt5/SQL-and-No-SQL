-- Selects
-- 1.	List all the data in the classic models database:
-- a)	Product Lines (7)
SELECT * FROM ProductLines;
-- b)	Product (110);
SELECT * FROM Products;
-- c)	Employees (23)
SELECT * FROM Employees;
-- d)	Offices (7)
SELECT * FROM Offices;
-- e)	Customers (122)
SELECT * FROM Customers;
-- f)	Orders (326)
SELECT * FROM Orders;
-- g)	Orderdetails (2996)
SELECT * FROM OrderDetails;
-- h)	Payments (273)
SELECT * FROM Payments;
-- 2.	Select customer name from customer. Sort by customer name (122)
SELECT customername FROM Customers 
ORDER BY customername ASC;
-- 3.	List each of the different status that an order may be in (6)
SELECT DISTINCT status FROM Orders;
-- 4.	List firstname and lastname for each employee. Sort by lastname then firstname (23)
SELECT firstname, lastname FROM Employees
ORDER BY lastname, firstname;
-- 5.	List all the employee job titles (7)
SELECT DISTINCT jobtitle FROM Employees;
-- 6.	List all products along with their product scale (110)
SELECT productname, productscale FROM Products;
-- 7.	List all the territories where we have offices (4)
SELECT DISTINCT territory FROM Offices;

-- Where Clause
-- 8.	select contact firstname, contact lastname and credit limit for all customers where credit limit > 50000 (85)
SELECT contactfirstname, contactlastname, creditlimit 
FROM Customers 
WHERE creditlimit > 50000;
-- 9.	select customers who do not have a credit limit (0.00) (24)
SELECT contactfirstname, contactlastname
FROM Customers
WHERE creditlimit = 0;
-- 10.	List all offices not in the USA (4)
SELECT officecode
FROM Offices
WHERE country!='USA';
-- 11.	List orders made between June 16, 2014 and July 7, 2014 (8)
SELECT ordernumber
FROM Orders
WHERE orderdate BETWEEN '2014-06-16' AND '2014-07-07';
-- 12.	List products that we need to reorder (quantityinstock < 1000) (12)
SELECT productname
FROM Products
WHERE quantityinstock < 1000;
-- 13.	List all orders that shipped after the required date (1)
SELECT ordernumber
FROM Orders
WHERE shippeddate > requireddate;
-- 14.	List all customers who have the word 'Mini' in their name (10)
SELECT customername
FROM Customers
WHERE customername like '%Mini%';
-- 15.	List all products supplied by 'Highway 66 Mini Classics' (9)
SELECT productname
FROM Products
WHERE productVendor = 'Highway 66 Mini Classics';
-- 16.	List all product not supplied by 'Highway 66 Mini Classics' (101)
SELECT productname
FROM Products
WHERE productvendor != 'Highway 66 Mini Classics';
-- 17.	List all employees that don't have a manager (1)
SELECT employeeNumber, firstname, lastname
FROM Employees
WHERE reportsto IS NULL;

-- Natural Join
-- 18.	Display every order along with the details of that order for order numbers 10270, 10272, 10279 (23)
-- Hint: this can be done two ways. Try both of them. Which is easier if you have a large number of selection criteria?
-- method 1:
SELECT ordernumber, productcode, quantityordered, priceeach, orderlinenumber
FROM Orders NATURAL JOIN OrderDetails
WHERE ordernumber = 10270 OR ordernumber = 10272 OR ordernumber = 10279; 
-- method 2:
SELECT ordernumber, productcode, quantityordered, priceeach, orderlinenumber
FROM Orders NATURAL JOIN OrderDetails
WHERE ordernumber IN(10270, 10272,10279); 
-- 19.	List of productlines and vendors that supply the products in that productline. (65)
-- NOT THE ANSWER (JUST TO MORE CLEARLY SEE THE DUPLICATES):
SELECT productline, productvendor
FROM ProductLines NATURAL JOIN Products
ORDER BY productline, productvendor;
-- ACTUAL ANSWER FOR #19:
SELECT DISTINCT productline, productvendor
FROM ProductLines NATURAL JOIN Products;

-- Inner Join
-- 20.	select customers that live in the same state as one of our offices (26)
SELECT customername
FROM Customers INNER JOIN Offices
ON Customers.state = Offices.state;
-- 21.	select customers that live in the same state as their employee representative works (26)
SELECT DISTINCT customername
FROM Customers INNER JOIN (Employees NATURAL JOIN Offices AS EO)
ON Customers.state = EO.state;

-- Multi-join
-- 22.	select customerName, orderDate, quantityOrdered, productLine, productName for all orders made and shipped in 2015 (444)
SELECT customername, orderdate, quantityordered, productline, productname
FROM Orders NATURAL JOIN Customers NATURAL JOIN OrderDetails NATURAL JOIN Products
WHERE orderdate BETWEEN '2015-01-01' AND '2015-12-31'
AND shippeddate BETWEEN '2015-01-01' AND '2015-12-31';

-- Outer Join
-- 23.	List products that didn't sell (1)
SELECT productname, ordernumber
FROM Products LEFT OUTER JOIN OrderDetails
ON Products.productcode = OrderDetails.productcode
WHERE ordernumber IS NULL;
-- 24.	List all customers and their sales rep even if they don't have a sales rep (122)
SELECT customername, lastname, firstname
FROM Customers LEFT OUTER JOIN Employees
ON Customers.salesrepemployeenumber = Employees.employeenumber;

-- Aggregate Functions
-- 25.	Find the total of all payments made by each customer (98)
SELECT customername, SUM(amount) AS totalpayments
FROM Customers NATURAL JOIN Payments
GROUP BY customername;
-- 26.	Find the largest payment made by a customer (1)
SELECT MAX(amount)
FROM Payments;
-- 27.	Find the average payment made by a customer (1)
SELECT AVG(amount)
FROM Payments;
-- 28.	What is the total number of products per product line (7)
SELECT productline, COUNT(productname) AS numofproducts
FROM Products
GROUP BY productline;
-- 29.	What is the number of orders per status (6)
SELECT status, COUNT(ordernumber)
FROM Orders
GROUP BY status;
-- 30.	List all offices and the number of employees working in each office (7)
SELECT officecode, COUNT(employeenumber)
FROM Employees
GROUP BY officecode;

-- Having
-- 31.	List the total number of products per product line where number of products > 3 (6)
SELECT productline, COUNT(productcode) AS numofproducts
FROM Products
GROUP BY productline
HAVING COUNT(productcode) > 3;
-- 32.	List the orderNumber and order total for all orders that totaled more than $60,000.00.
SELECT ordernumber, SUM(quantityordered*priceeach) AS ordertotal
FROM OrderDetails
GROUP BY ordernumber
HAVING SUM(quantityordered*priceeach) > 60000;

-- Computations
-- 33.	List the products and the profit that we have made on them.  
--      The profit in each order for a given product is (priceEach - buyPrice) * quantityOrdered.  
--      List the product's name and code with the total profit that we have earned selling that product.  
--      Order the rows descending by profit. 
--      Only show those products whose profit is greater than $60,000.00. (11)
SELECT productname, productcode, SUM((priceeach-buyprice) * quantityordered) AS profit
FROM Products NATURAL JOIN OrderDetails
GROUP BY productname, productcode
HAVING SUM((priceeach-buyprice) * quantityordered) > 60000
ORDER BY profit DESC;
-- 34.	List the average of the money spent on each product across all orders 
--      where that product appears when the customer is based in Japan.  
--      Show these products in descending order by the average expenditure (45).
SELECT productcode, AVG(quantityordered*priceeach) AS averageamountspentonproduct
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails
WHERE country = 'Japan'
GROUP BY productcode
ORDER BY averageamountspentonproduct DESC;

-- PROFESSOR SOLUTION (#34):
SELECT productcode, avg(quantityordered*priceeach) "average value"
FROM OrderDetails inner join orders using (ordernumber)
inner join customers cust using (customernumber)
where cust.country = 'Japan'
group by productcode
order by avg(quantityordered*priceeach) desc;
-- 35.	What is the profit per product (MSRP-buyprice) (110)
SELECT productname, (msrp-buyprice)
FROM products;
-- 36.	List the Customer Name and their total orders (quantity * priceEach) 
--      across all orders that the customer has ever placed with us,
--      in descending order by order total 
--      for those customers who have ordered more than $100,000.00 from us. (32)
SELECT customername, SUM(quantityordered*priceeach) AS allorderstotal
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails
GROUP BY customername
HAVING sum(quantityordered*priceeach) > 100000
ORDER BY allorderstotal DESC;

-- PART OF PROFESSOR SOLUTION(#36):
FROM Customer inner join Orders using (customernumber) inner join Orderdetails using (ordernumber);

-- Set Operations
-- 37.	List all customers who didn't order in 2015 (78)
---- LISTS ALL THE customers even if they did not order a Product
SELECT DISTINCT customerName
FROM Customers C LEFT OUTER JOIN Orders O
ON C.customerNumber = O.customerNumber;
---- ANSWER FOR #37:
SELECT customerName From Customers
EXCEPT
SELECT DISTINCT customerName 
From Customers NATURAL JOIN Orders
WHERE YEAR(orderDate) = 2015;
-- 38.	List all people that we deal with (employees and customer contacts). 
--      Display first name, last name, company name (or employee) (145)
SELECT 'Employee' AS "Company Name", lastName AS "Last Name", firstName AS "First Name" 
FROM Employees
UNION
SELECT customerName AS "Company Name", contactLastName AS "Last Name", contactFirstName AS "First Name" 
FROM Customers;
-- 39.	List the last name, first name, and employee number of all of the employees who do not have any customers.  
--      Order by last name first, then the first name. (8)
----    SET OPERATION ANSWER FOR #39:
SELECT lastName, firstName, employeeNumber 
FROM Employees
EXCEPT
SELECT DISTINCT lastName, firstName, employeeNumber 
FROM Employees E INNER JOIN Customers C
ON E.employeeNumber = C.salesrepemployeenumber
ORDER BY lastname, firstname;
----     OUTER JOIN ANSWER FOR #39:
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
SELECT productCode, productName FROM Products
EXCEPT
SELECT DISTINCT productCode, productName FROM OrderDetails NATURAL JOIN Products WHERE quantityOrdered > 48; 
-- 42.	List the first name and last name of any customer who ordered any products
--      from either of the two product lines 'Trains' or 'Trucks and Buses'.
--      Do not use an "or".
--      Instead perform a union.  
--      Order by the customer�s name.  (61)
SELECT DISTINCT contactlastname, contactfirstname
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails NATURAL JOIN Products
WHERE productLine = 'Trains'
UNION
SELECT DISTINCT contactlastname, contactfirstname
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails NATURAL JOIN Products
WHERE productLine = 'Trucks and Buses'
ORDER BY contactlastname, contactfirstname;
-- 43.	List the name of all customers who do not live in the same state and country with any other customer.  
--      Do not use a count for this exercise.  Order by the customer name.

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
WHERE productLine = (SELECT productLine FROM Products
GROUP BY productLine
HAVING count(productVendor) < 5);
-- 46.	List the products in the product line with the most number of products (38)
SELECT productName, productLine
FROM Products
WHERE productLine =
(
    SELECT productLine AS numOfProductsPerProductLine
    FROM Products
    GROUP BY productLine
    HAVING count(productName) = 
    (
        SELECT MAX(COUNTTABLE.numOfProductsPerProductLine) AS maxcount
        FROM 
        (
            SELECT productLine, count(productName) AS numOfProductsPerProductLine
            FROM Products
            GROUP BY productLine
        ) AS COUNTTABLE
    )
);
-- 47.	Find the first name and last name of all customer contacts
--      whose customer is located in the same state as the San Francisco office. (11)
SELECT contactfirstname, contactlastname FROM Customers
WHERE state = ---gw
(
    SELECT DISTINCT state FROM Customers
    WHERE city = 'San Francisco'
);
-- 48.	What is the customer and sales person of the highest priced order? (1)
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
--      and that same cost could be the highest cost among all orders. (1)
SELECT orderNumber, sum(priceEach*quantityOrdered) AS "Order Total"
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
);
-- 50.	What is the name of the customer, the order number,
--      and the total cost of the most expensive orders? (1)
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
SELECT productname, msrp, AVG(msrp) AS "not sure what the difference is but ok"
FROM Products
GROUP BY productname, msrp
HAVING msrp <= 1.05 * (SELECT AVG(msrp) FROM Products) 
AND msrp >= 0.95 * (SELECT AVG(msrp) FROM Products);

----    OR if we dont include the avg(msrp) we dont need to use 'group by' and 'having' (#53):
SELECT productname, msrp
FROM products
where msrp <= 1.05*(SELECT AVG(msrp) FROM Products) AND msrp >= 0.95*(SELECT AVG(msrp) FROM Products);

----    Used to help me understand the problem (#53):
SELECT msrp from Products;
SELECT 1.05*(SELECT AVG(msrp) FROM products) from Products;
SELECT 0.95*(SELECT AVG(msrp) FROM products) from Products;
-- 54.	List all of the customers who have never made a payment on the same date as another customer. (57)
-- 55.	Find customers who have ordered the same thing.
--      Find only those customer pairs who have ordered the same thing as each other at least 201 times (1)

-- Recursion
-- 56.	What is the manager who manages the greatest number of employees (2)
SELECT employeeNumber, lastName, firstName
FROM Employees
WHERE employeeNumber IN
(
    SELECT reportsto
    FROM Employees
    GROUP BY reportsto
    HAVING COUNT(employeeNumber) = 
    (
        SELECT MAX(Manager.numOfEmployeesManaged)
        FROM 
        (
            SELECT reportsto, COUNT(employeeNumber) AS numOfEmployeesManaged
            FROM Employees
            GROUP BY reportsto
        ) AS Manager
    )
);
-- 57.	Select all employees who work for the manager that manages the greatest number of employee (12)
SELECT employeeNumber, lastName, firstName
FROM Employees
WHERE reportsto IN
(
    SELECT reportsto
    FROM Employees
    GROUP BY reportsto
    HAVING COUNT(employeeNumber) = 
    (
        SELECT MAX(Manager.numOfEmployeesManaged)
        FROM 
        (
            SELECT reportsto, COUNT(employeeNumber) AS numOfEmployeesManaged
            FROM Employees
            GROUP BY reportsto
        ) AS Manager
    )
);
-- 58.	List all employees that have the same last name. Make sure each combination is listed only once (5)
SELECT A.lastname, A.firstname, B.lastname, B.firstname
FROM employees A INNER JOIN employees B 
USING (lastname)
WHERE A.employeenumber > B.employeenumber;

-- 59.	Select the name of each of two customers who have made at least one payment on the same date as the other.
--      Make sure that each pair of customers only appears once. (46)
----    BASE ANSWER FOR #59 (helpful for understanding):
SELECT A.customernumber, A.paymentdate, B.customernumber, B.paymentdate
FROM Payments A INNER JOIN Payments B
USING (paymentdate)
WHERE A.customernumber > B.CUSTOMERNUMBER;
----    FULL ANSWER FOR #59:
SELECT Cus_A.customername, Cus_B.customername, A.PAYMENTDATE AS "Common Payment Date"
FROM (Payments A NATURAL JOIN Customers Cus_A) INNER JOIN (Payments B NATURAL JOIN Customers Cus_B) 
USING (paymentdate)
WHERE A.customernumber > B.CUSTOMERNUMBER;
-- 60.	Find customers that share the same state and country.
--      The country must be one of the following: UK, Australia, Italy or Canada.
--      Remember that not all countries have states at all, so you need to substitute
--       a character sting like 'N/A' for the state in those cases so that you can compare the states.
-- 61.	Find all of the customers who have the same sales representative as some other customer,
--      and either customer name has 'Australian' in it.
--      List each of the customers sharing a sales representative, and the name of the sales representative.
--      Order by the name of the first customer, then the second.  Do not show any combination more than once. (9)

-- #1
-- List all employees first name, last name, email, and city who work in any of the California offices
SELECT firstname, lastname, email, city
FROM Employees NATURAL JOIN Offices
WHERE state = 'CA';

-- #2
-- List the order number, order date and shipped date for orders made between June 16, 2014 and July 7, 2014 
-- and shipped between June 20, 2014 and July 31, 2014. 
-- Display the list sorted by shipped date.
SELECT ordernumber, orderdate, shippeddate
FROM Orders
WHERE orderdate BETWEEN '2014-06-16' AND '2014-07-07'
AND shippeddate BETWEEN '2014-06-20' AND '2014-07-31'
ORDER BY shippeddate;

-- #3
-- List all customers and their sales rep even if they don't have a sales rep for all customers who do business in California
SELECT customername, lastname, firstname
FROM Customers C LEFT OUTER JOIN Employees E
ON C.salesrepemployeenumber = E.employeenumber
WHERE state = 'CA';

-- #4
-- For each order, list the order date, the customer name, and the number of products ordered.
-- Do this in descending order by the nubmer of products ordered.
-- Show only those orders that have ordered 17 or more different items.
SELECT orderdate, customername, COUNT(productcode) AS numberofuniqueproducts
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails
GROUP BY orderdate, customername
HAVING COUNT(productcode) > 16
ORDER BY numberofuniqueproducts DESC;

-- #5
-- List the product code, product description and potential profit (quantityinstock*(msrp-buyprice))
-- for all products where we have less than 200 in stock.
-- Make sure you create an alias for the potential profit column.
SELECT productcode, productdescription, SUM(quantityinstock*(msrp-buyprice)) AS totalpotentialprofit
FROM Products
WHERE quantityinstock < 200
GROUP BY productcode, productdescription;


--1

SELECT distinct customername from orders natural join customers
except
SELECT distinct customername from orders natural join customers where orderdate BETWEEN '07/01/2013' AND '11/30/2013'
union
SELECT distinct customername from orders natural join customers where orderdate BETWEEN '07/01/2014' AND '11/30/2014'
union
SELECT distinct customername from orders natural join customers where orderdate BETWEEN '07/01/2015' AND '11/30/2015';


--2
SELECT contactlastname, customername from customers where contactlastname in 
(
    SELECT lastname from employees
)
ORDER BY customername;

--3

SELECT productname, (quantityinstock*msrp) as value from products where (quantityinstock*msrp) = 
(
    SELECT min(quantityinstock*msrp) FROM products
);

--4
SELECT a.customername, a.POSTALCODE, b.customername, b.postalcode
FROM customers a inner join customers b using (postalcode)
WHERE a.customernumber < b.customernumber
ORDER BY a.customername, b.customername;


-- 5
SELECT city, state from customers where state is not null;

SELECT city, state from offices where state is not null;

SELECT city, state from offices a join customers b where state is not null;