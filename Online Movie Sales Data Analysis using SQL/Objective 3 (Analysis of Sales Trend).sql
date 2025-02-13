-- Sales trend by month
SELECT 
    DATE_FORMAT(sale_date, '%M') AS month, 
    COUNT(*) AS num_sales
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%M')
ORDER BY MONTH(MIN(sale_date));

-- Sales trend by year
SELECT 
	DATE_FORMAT(sale_date, '%Y') AS year,
	COUNT(*) AS num_sales
FROM sales
GROUP BY year
ORDER BY YEAR(MIN(sale_date));

-- Movies and total sales by month
SELECT
    DATE_FORMAT(sale_date, '%M') AS month,
    title AS movie,
    COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY month, movie
ORDER BY MONTH(MIN(sale_date)), num_sales DESC;

-- Correlation between release year and popularity (num_sales)
SELECT
	release_year AS year,
    movies.title AS movie,
    COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY year, movie
ORDER BY year ASC, num_sales DESC;
