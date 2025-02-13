-- Most loyal customers
SELECT name, COUNT(*) AS num_sales
FROM customers INNER JOIN sales
ON customers.customer_id = sales.customer_id
GROUP BY name
ORDER BY num_sales DESC, name ASC;

-- Customer purchasing patterns based on place of residence
SELECT city, COUNT(*) AS total_purchase
FROM customers INNER JOIN sales
ON customers.customer_id = sales.customer_id
GROUP BY city
ORDER BY total_purchase DESC;

-- Create a temporary table so that 'with' can be used multiple times
CREATE TEMPORARY TABLE customers_movies AS
WITH customers_movies AS (
    SELECT name, genre, c.city AS city, m.title AS title
    FROM customers c
    JOIN sales s
    ON c.customer_id = s.customer_id
    JOIN movies m
    ON s.movie_id = m.movie_id
)
SELECT * FROM customers_movies;

-- Analysis of movie genres by city
SELECT city, GROUP_CONCAT(DISTINCT(genre) SEPARATOR ', ') AS genre, COUNT(DISTINCT(genre)) AS num_genre
FROM customers_movies
GROUP BY city
ORDER BY num_genre DESC;

-- Analysis of the number of movies sold by city
SELECT city, GROUP_CONCAT(title SEPARATOR ', ') AS movie, COUNT(*) AS num_movie
FROM customers_movies
GROUP BY city
ORDER BY num_movie DESC;

-- Analysis movie genres based on customer
SELECT name, GROUP_CONCAT(DISTINCT(genre) SEPARATOR ', ') AS genre, COUNT(DISTINCT(genre)) AS num_genre
FROM customers_movies
GROUP BY name
ORDER BY num_genre DESC, name ASC;

-- Customer patterns differ by city
SELECT city, COUNT(DISTINCT name) AS num_customer
FROM customers INNER JOIN sales
ON customers.customer_id = sales.customer_id
GROUP BY city
ORDER BY num_customer; 

-- Total revenue by city
SELECT city, SUM(price) AS total_revenue 
FROM customers INNER JOIN sales
ON customers.customer_id = sales.customer_id
GROUP BY city
ORDER BY total_revenue DESC;

-- Average revenue by city
SELECT city, AVG(price) AS average_revenue
FROM customers INNER JOIN sales
ON customers.customer_id = sales.customer_id
GROUP BY city
ORDER BY average_revenue DESC;

-- Relationship between customer registration date and purchase behavior
-- Check if there are customers with signup_date more than 1.
SELECT customer_id, COUNT(DISTINCT signup_date) AS num_date_differ
FROM customers
GROUP BY customer_id
HAVING num_date_differ > 1;

SELECT name, min(signup_date) AS signup_date, COUNT(*) AS total_purchase
FROM customers INNER JOIN sales
ON customers.customer_id = sales.customer_id
GROUP BY name
ORDER BY signup_date ASC, total_purchase DESC;

-- Analysis of customer's preferred movie genre
SELECT name, COUNT(DISTINCT(genre)) AS num_purchase, GROUP_CONCAT(DISTINCT(genre) SEPARATOR ', ') AS genre
FROM customers_movies
GROUP BY name
ORDER BY num_purchase DESC;
