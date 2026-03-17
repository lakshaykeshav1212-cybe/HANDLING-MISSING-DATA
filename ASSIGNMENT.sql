CREATE DATABASE ASSIGNMENT;
###  Q8. Listwise Deletion  Remove all rows where Region is missing.Tasks:Identify affected rows Show the dataset after deletion Mention how many records were lost

USE ASSIGNMENT;
CREATE TABLE oldcustomers (
    Customer_ID INT,
    Name VARCHAR(50),
    City VARCHAR(50),
    Monthly_Sales INT,
    Income INT,
    Region VARCHAR(20)
);

INSERT INTO oldcustomers VALUES
(101,'Rahul Mehta','Mumbai',12000,65000,'West'),
(102,'Anjali Rao','Bengaluru',NULL,NULL,'South'),
(103,'Suresh Iyer','Chennai',15000,72000,'South'),
(104,'Neha Singh','Delhi',NULL,NULL,'North'),
(105,'Amit Verma','Pune',18000,58000,NULL),
(106,'Karan Shah','Ahmedabad',NULL,61000,'West'),
(107,'Pooja Das','Kolkata',14000,NULL,'East'),
(108,'Riya Kapoor','Jaipur',16000,69000,'North');


CREATE TABLE after_delete (
Customer_ID INT,
Name VARCHAR(50),
City VARCHAR(50),
Monthly_Sales INT,
Income INT,
Region VARCHAR(20),
DeletedAt TIMESTAMP
);

DELIMITER //

CREATE TRIGGER DELETED 
AFTER DELETE ON CUSTOMERS
FOR EACH ROW
BEGIN
INSERT INTO AFTER_DELETE(CUSTOMER_ID,NAME,CITY,MONTHLY_SALES,INCOME,REGION,DELETEDAT)
VALUES (OLD.CUSTOMER_ID,OLD.NAME,OLD.CITY,OLD.MONTHLY_SALES,OLD.INCOME,OLD.REGION,NOW());
END //

DELIMITER ;

SELECT * FROM AFTER_DELETE;


SELECT * FROM CUSTOMERS
WHERE REGION IS NULL;


DELETE FROM CUSTOMERS
WHERE REGION IS NULL;

SELECT * FROM CUSTOMERS;

### Q9. Imputation Handle missing values in Monthly_Sales using: Forward Fill
#Tasks:
#Apply forward fill
#Show before vs after values
#Explain why forward fill is suitable here

UPDATE customers c1
JOIN (
    SELECT Customer_ID,
           MAX(Monthly_Sales) OVER (ORDER BY Customer_ID 
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS filled_sales
    FROM customers
) c2
ON c1.Customer_ID = c2.Customer_ID
SET c1.Monthly_Sales = c2.filled_sales
WHERE c1.Monthly_Sales IS NULL;

SELECT * FROM CUSTOMERS;
select * from oldcustomers;

### Why Forward Fill is suitable (Monthly_Sales):

## Data is ordered (Customer_ID / time-like sequence)
## Missing values are likely not new values, just not recorded
## Assumption: last known sales value continues until updated
## Keeps trend continuity, avoids sudden artificial jumps
## Simple and logical when no better external data available

##Q10. Flagging Missing Data
#Create a flag column for missing Income.
#Tasks:
##Create Income_Missing_Flag (0 = present, 1 = missing)
##Show updated dataset
##Count how many customers have missing income

SELECT *,
       CASE 
           WHEN Income IS NULL THEN 1 
           ELSE 0
       END AS Income_Missing_Flag
FROM customers;

SELECT COUNT(*) AS MISSING_INCOME FROM CUSTOMERS
WHERE INCOME IS NULL;






