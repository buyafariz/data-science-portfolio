CREATE TABLE books (
	id_books int primary key,
    title varchar(255) not null,
    genre varchar(20),
    author varchar(255),
    publisher varchar(255),
    year_pub int,
    price decimal(10,2)
);

INSERT INTO books (title, genre, author, publisher, year_pub, price)
VALUES
    ('Harry Potter dan Batu Bertuah', 'Fantasy', 'J.K. Rowling', 'Gramedia Pustaka Utama', 2000, 95000.00),
    ('Laskar Pelangi', 'Novel', 'Andrea Hirata', 'Bentang Pustaka', 2005, 75000.00),
    ('Bumi Manusia', 'Sejarah', 'Pramoedya Ananta Toer', 'Hasta Mitra', 1980, 120000.00),
    ('Ayat-Ayat Cinta', 'Religi', 'Habiburrahman El Shirazy', 'Republika', 2004, 60000.00),
    ('5 cm', 'Petualangan', 'Donny Dhirgantoro', 'Grasindo', 2005, 55000.00),
    ('Negeri 5 Menara', 'Inspirasional', 'Ahmad Fuadi', 'Gramedia Pustaka Utama', 2009, 80000.00),
    ('Sang Pemimpi', 'Novel', 'Andrea Hirata', 'Bentang Pustaka', 2006, 70000.00),
    ('Perahu Kertas', 'Romance', 'Dee Lestari', 'Bentang Pustaka', 2009, 85000.00),
    ('Marmut Merah Jambu', 'Humor', 'Raditya Dika', 'Bukune', 2010, 45000.00),
    ('Malin Kundang', 'Legenda', NULL, 'BIP', 2015, 35000.00),
    ('Tenggelamnya Kapal Van Der Wijck', 'Romance', 'Hamka', 'Gema Insani', 1938, 150000.00),
    ('Cantik Itu Luka', 'Fiksi', 'Eka Kurniawan', 'Gramedia Pustaka Utama', 2002, 90000.00),
    ('Gajah Mada', 'Sejarah', 'Langit Kresna Hariadi', 'Gajah Mada Media', 2008, 110000.00),
    ('Ronggeng Dukuh Paruk', 'Novel', 'Ahmad Tohari', 'Gramedia Pustaka Utama', 1982, 100000.00),
    ('Anak Rantau', 'Novel', 'A. Fuadi', 'Fauzi Faizin', 2017, 65000.00);


-- OBJECTIVE 1 (BOOK ANALYSIS BY PRICE)
-- Books with the highest price
SELECT title, genre, author, publisher, price FROM books
ORDER BY price DESC
LIMIT 3;

-- Books with the lowest price
SELECT title, genre, author, publisher, price FROM books
ORDER BY price ASC
LIMIT 3;


-- OBJECTIVE 2 (AUTHOR AND PUBLISHER ANALYSIS)
-- Publishers that frequently appears in the collection
SELECT publisher, COUNT(*) AS num_books FROM books
GROUP BY publisher
ORDER BY num_books DESC
LIMIT 3;

-- The Author with the most books in the collection
SELECT author, COUNT(*) AS num_books FROM books
GROUP BY author
ORDER BY num_books DESC
LIMIT 3;

-- Distribution of book authors and publishers in the last 10 year (current=2017)
SELECT title, genre, author, publisher, year_pub FROM books
WHERE year_pub > (SELECT MAX(year_pub)-15 FROM books)
ORDER BY year_pub DESC;

-- A book written by Andrea Hirata
SELECT * FROM books
WHERE author='Andrea Hirata';

-- Distribution of book authors and publishers in the last 20 year (current=2025)
SELECT title, genre, author, publisher, year_pub FROM books
WHERE year_pub > (YEAR(NOW())-20)
ORDER BY year_pub DESC;


-- OBJECTIVE 3 (BOOK PUBLICATION YEAR ANALYSIS)
-- Number of books published per year
SELECT year_pub, COUNT(*) AS num_books FROM books
GROUP BY year_pub
ORDER BY year_pub DESC;

-- Books published in 2005
SELECT title, genre, author, publisher FROM books
WHERE year_pub=2005;

-- Books published in 2009
SELECT title, genre, author, publisher FROM books
WHERE year_pub=2009;

-- Year with the highest number of books
SELECT year_pub, COUNT(*) AS num_books FROM books
GROUP BY year_pub
ORDER BY year_pub DESC
LIMIT 3;

-- Popular genres in the last 15 years
SELECT genre, COUNT(*) AS num_books FROM books
WHERE year_pub > (SELECT MAX(year_pub)-15 FROM books)
GROUP BY genre
ORDER BY num_books DESC
LIMIT 3;

-- Books with Genre='Novel' in the last 15 years
SELECT title, author, year_pub FROM books
WHERE year_pub > (SELECT MAX(year_pub)-15 FROM books) AND genre='Novel';


-- OBJECTIVE 4 (NULL DATA DETECTION)
-- NULL data detection
SELECT * FROM books
WHERE title IS NULL OR author IS NULL OR publisher IS NULL OR year_pub IS NULL OR price IS NULL OR genre IS NULL;


-- OBJECTIVE 5 (BOOK PRICE ANALYSIS)
-- Average price of books
SELECT AVG(price) AS average_price_books FROM books;

-- Average book price by author
SELECT author, AVG(price) AS average_price_books FROM books
GROUP BY author
ORDER BY average_price_books;

-- Average book price by genre
SELECT genre, AVG(price) AS average_price_books FROM books
GROUP BY genre
ORDER BY average_price_books;