-- Most popular movie genres (by number of sales)
SELECT movies.genre, COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY num_sales DESC;

-- Most popular movie genres (based on total revenue)
SELECT movies.genre, SUM(price) AS total_revenue
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY total_revenue DESC;

-- Most popular movie genres (based on average revenue)
SELECT movies.genre, AVG(price) AS average_revenue
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY average_revenue DESC;

-- Best genres (based on average rating)
SELECT movies.genre, AVG(rating) AS average_rating
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY average_rating DESC;

-- Correlation between movie rating and popularity (based on number of sales)
SELECT movies.genre, AVG(rating) AS average_rating, COUNT(*) AS num_sales
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY average_rating DESC;

-- Correlation between movie rating and popularity (based on total revenue)
SELECT movies.genre, AVG(rating) AS average_rating, SUM(price) AS total_revenue
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY average_rating DESC;

-- Correlation between movie rating and popularity (based on average revenue)
SELECT movies.genre, AVG(rating) AS average_rating, AVG(price) AS average_revenue
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY genre
ORDER BY average_rating DESC;

-- Movie recommendations based on average rating, total sales, total revenue, and average revenue simultaneously
WITH rating_stats AS (
	SELECT genre, AVG(rating) AS average_rating
	FROM movies INNER JOIN sales
	ON movies.movie_id = sales.movie_id
	GROUP BY genre
    ),

    min_max_rating AS (
    SELECT min(average_rating) AS min_rating, max(average_rating) AS max_rating
    FROM rating_stats
    ),
    
    sales_stats AS (
    SELECT genre, COUNT(*) AS num_sales
	FROM movies INNER JOIN sales
	ON movies.movie_id = sales.movie_id
	GROUP BY genre
	),
    
    min_max_sales AS (
    SELECT MIN(num_sales) AS min_sales, MAX(num_sales) AS max_sales
    FROM sales_stats
    ),
    
    total_revenue_stats AS (
    SELECT genre, SUM(price) AS total_revenue
    FROM movies INNER JOIN sales
    ON movies.movie_id = sales.movie_id
    GROUP BY genre
    ),
    
    min_max_revenue AS (
    SELECT MIN(total_revenue) AS min_revenue, MAX(total_revenue) AS max_revenue
    FROM total_revenue_stats
    ),
    
    average_revenue_stats AS (
    SELECT genre, AVG(price) AS average_revenue
    FROM movies INNER JOIN sales
    ON movies.movie_id = sales.movie_id
    GROUP BY genre
    ),
    
    min_max_average_revenue AS (
    SELECT MIN(average_revenue) AS min_average_revenue, MAX(average_revenue) AS max_average_revenue
    FROM average_revenue_stats
    ),
    
    normalized AS (
	SELECT 
		r.genre, 
		(r.average_rating - mr.min_rating) / (mr.max_rating - mr.min_rating) AS normalized_rating,
		(p.num_sales - mp.min_sales) / (mp.max_sales - mp.min_sales) AS normalized_sales,
		(d.total_revenue - md.min_revenue) / (md.max_revenue - md.min_revenue) AS normalized_revenue,
		(rd.average_revenue - mrd.min_average_revenue) / (mrd.max_average_revenue - mrd.min_average_revenue) AS normalized_average_revenue
	FROM rating_stats r 
	JOIN min_max_rating mr ON 1=1
	JOIN sales_stats p ON r.genre = p.genre
	JOIN min_max_sales mp ON 1=1
	JOIN total_revenue_stats d ON r.genre = d.genre
	JOIN min_max_revenue md ON 1=1
	JOIN average_revenue_stats rd ON r.genre = rd.genre
	JOIN min_max_average_revenue mrd ON 1=1
)

SELECT 
	genre,
    normalized_rating,
    normalized_sales,
    normalized_revenue,
    normalized_average_revenue,
	(0.25*normalized_rating + 0.25*normalized_sales + 0.25*normalized_revenue + 0.25*normalized_average_revenue) AS final_score
FROM normalized
ORDER BY final_score DESC;

-- Movies that are often bought together
SELECT sale_date, GROUP_CONCAT(movies.title SEPARATOR ', ') AS movies_title, COUNT(*) AS num_movies
FROM movies INNER JOIN sales
ON movies.movie_id = sales.movie_id
GROUP BY sale_date
ORDER BY num_movies DESC;
