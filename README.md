#SQL

This is sql code will help to understand basic knowledge of the sql query


#There is some of basic query use for the to do the code 

https://github.com/thecraigd/Python_SQL/blob/master/mysql.ipynb

##Basic SQL learn

https://www.w3schools.com/sql/default.asp

https://learnsql.com/blog/lead-and-lag-functions-in-sql/

https://www.tutorialspoint.com/sql/sql-create-database.html


###Master in database

https://github.com/at235am/cecs-323-practice-sql/blob/master/sql-practice-classics-model.sql


####Most interview question for the different interview 

https://github.com/learning-zone


#Types of Window functions

Aggregate Window Functions

SUM(), MAX(), MIN(), AVG(). COUNT()

#Ranking Window Functions

RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()

mysql> select customerid,PaymentMethod,totalcharges,

    -> RANK() OVER(PARTITION BY PAYMENTMETHOD ORDER BY TOTALCHARGES DESC) AS RANK_VALUE,
    
    -> DENSE_RANK() OVER(PARTITION BY PAYMENTMETHOD ORDER BY TOTALCHARGES DESC) AS DENSEVALUE,
    
    -> ROW_NUMBER() OVER(PARTITION BY PAYMENTMETHOD ORDER BY TOTALCHARGES DESC) AS ROWVALUE
    
    -> FROM MYTABLE;

#Value Window Functions

LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()

#Syntax

window_function ( [ ALL ] expression ) 
OVER ( [ PARTITION BY partition_list ] [ ORDER BY order_list] )
 
    
window function link ---https://www.sqltutorial.org/sql-window-functions/
