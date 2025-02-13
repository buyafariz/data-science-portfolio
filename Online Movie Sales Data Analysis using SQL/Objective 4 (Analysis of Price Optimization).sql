-- Movie price distribution (cheapest)
SELECT price AS price, title AS movie
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
ORDER BY price ASC
LIMIT 1;

-- Movie price distribution (most expensive)
SELECT price AS price, title AS movie
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
ORDER BY price DESC
LIMIT 1;

-- Average price of movies sold
SELECT AVG(price) AS average_price
FROM sales;

-- Median price of movies sold
WITH ordered_sales AS (
    SELECT price,
           ROW_NUMBER() OVER (ORDER BY price) AS row_num,
           COUNT(*) OVER () AS total_rows
    FROM sales
)
SELECT AVG(price) AS median_price
FROM ordered_sales
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));

-- Correlation between movie price and popularity (total sales)
SELECT title, AVG(price) AS average_price, COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY title
ORDER BY average_price ASC;

-- Movies that are too cheap (high rating considerations)
SELECT title, AVG(price) AS average_price, ROUND(AVG(rating),1) AS average_rating, COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY title
HAVING average_rating >= 4.7
ORDER BY average_price ASC;

-- Movies that are too expensive (low rating consideration)
SELECT title, AVG(price) AS average_price, ROUND(AVG(rating),1) AS average_rating, COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY title
HAVING average_rating <= 2
ORDER BY average_price DESC;

