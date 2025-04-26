--SQL Retail Sales Analysis 

--Check if the table is already exit or not.

DROP TABLE IF EXISTS RETAIL_SALES;
-- To create the retail_sales table.

CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

-- To check date if they have null values in table

SELECT
	*
FROM
	RETAIL_SALES;

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

--Data Cleaning

DELETE FROM RETAIL_SALES WHERE TRANSACTIONS_ID IS NULL
OR SALE_DATE IS NULL
OR SALE_TIME IS NULL
OR CUSTOMER_ID IS NULL
OR GENDER IS NULL
OR CATEGORY IS NULL
OR QUANTIY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL;

-- Data Explorations

-- How many sales we have

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

-- How many unique customers we have

SELECT
	COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMER
FROM
	RETAIL_SALES;

--Data Analysis and Business Key Problems


 
-- 1. Write a sql query to retrieve all columns for sales made on '22-11-05'

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

--2. Write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-22

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND QUANTIY >= 4
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11';

--3. Write a sql query to calculate the total_sales for each category

SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS TOTAL_SALES,
	COUNT(*)
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- 4. Wite a sql query to find the average age of customers who purchased items from the 'Beauty' category

SELECT
	ROUND(AVG(AGE), 2)
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty';

--5. Write a sql query to find all transactions where total_sales is greater than 1000.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000;

-- 6. Write a sql query to find the total number of transactions (transactions_id) made by each gender in each category.

SELECT
	CATEGORY,
	GENDER,
	COUNT(TRANSACTIONS_ID)
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY,
	GENDER
ORDER BY
	CATEGORY,
	GENDER;
-- 7. Write a sql query to calculate the average sale for each month. Find  best selling month in each year

SELECT
	YEAR,
	MONTH,
	AVG_SALES
FROM
	(
		SELECT
			EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
			EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
			AVG(TOTAL_SALE) AS AVG_SALES,
			RANK() OVER (PARTITION over EXTRACT(YEAR FROM SALE_DATE)
				ORDER BY
					AVG(TOTAL_SALE) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			YEAR,
			MONTH
	) AS TOTAL_DATA
WHERE
	RANK = 1;
-- 8. Write a sql query to find the top 5 customers based on the highest total sales.

SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL
FROM
	RETAIL_SALES
GROUP BY
	CUSTOMER_ID
ORDER BY
	TOTAL DESC
LIMIT
	5;

--9. write a sql query to find the number of unique customers who purchased items from each category.	  

SELECT
	CATEGORY,
	COUNT(DISTINCT (CUSTOMER_ID))
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;
	
--10. Write a sql query to create each shift and number of orders {example morning <=12, afternoon between 12 and 17, evening >17}

WITH
	HOURLY_SALES AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'Morning'
				WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'Evening'
			END AS SHIFT
		FROM
			RETAIL_SALES
	)
SELECT
	SHIFT,
	COUNT(TRANSACTIONS_ID)
FROM
	HOURLY_SALES
GROUP BY
	SHIFT;