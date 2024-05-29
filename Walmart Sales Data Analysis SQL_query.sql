Show databases;
create database walmartSales;
show databases;
use walmartSales;
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;

-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

select * from sales;

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
select distinct city from sales;

-- In which city is each branch?
select distinct city, branch from sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales;

-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;


-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue; 


-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;


-- What product line had the largest revenue?
select product_line, sum(total) as total_revenue 
from sales 
group by product_line 
order by total_revenue desc;

-- What is the city with the largest revenue?
select city,branch, sum(total) as total_revenue from sales group by city, branch order by total_revenue desc;

-- What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
SELECT AVG(quantity) AS avg_qnty FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > (SELECT AVG(quantity) AS avg_qnty FROM sales)THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
select branch, sum(quantity) as total_quantity 
from sales 
group by branch
having sum(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender
select gender,product_line, count(gender) as gender_cnt from sales 
group by gender, product_line 
order by gender_cnt desc;

-- What is the average rating of each product line
select round(avg(rating), 2) as avg_rating, product_line 
from sales 
group by product_line 
order by avg_rating desc;


-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?
select distinct Customer_type from sales;


-- How many unique payment methods does the data have?
select distinct payment from sales;


-- What is the most common customer type?
select Customer_type, count(*) as cnt from sales
group by customer_type 
order by cnt;


-- Which customer type buys the most?
SELECT customer_type, COUNT(*)
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which day of the week has the best avg ratings?
select day_name, round(avg(rating),2) as avg_rating 
from sales 
group by day_name 
order by avg_rating 
desc limit 1;


-- Which day of the week has the best average ratings per branch?
select day_name, count(day_name) as count from sales 
where branch = "A" 
group by day_name
order by count;

select day_name, count(day_name) as count from sales 
where branch = "B" 
group by day_name
order by count;

select day_name, count(day_name) as count from sales 
where branch = "C" 
group by day_name
order by count;



-- Which customer type pays the most in VAT?

select customer_type, sum(tax_pct) as tax_product 
from sales 
group by customer_type 
order by tax_product; 

-- which time of day made most order
select time_of_day, count(quantity) AS total 
from sales 
group by time_of_day 
order by total desc;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;



