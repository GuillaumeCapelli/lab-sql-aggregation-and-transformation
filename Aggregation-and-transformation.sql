use sakila;

show tables;

/*Challenge 1

    As a movie rental company, we need to use SQL built-in functions to help us gain insights into our business operations:
        1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
        1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: look for floor and round functions.

    We need to use SQL to help us gain insights into our business operations related to rental dates:
        2.1 Calculate the number of days that the company has been operating. Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
        2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
        2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week. Hint: use a conditional expression.

    We need to ensure that our customers can easily access information about our movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results by the film title in ascending order. Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future. Hint: look for the IFNULL() function.

    As a marketing team for a movie rental company, we need to create a personalized email campaign for our customers. To achieve this, we want to retrieve the concatenated first and last names of our customers, along with the first 3 characters of their email address, so that we can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier for us to use the data.

Challenge 2

    We need to analyze the films in our collection to gain insights into our business operations. Using the film table, determine:
        1.1 The total number of films that have been released.
        1.2 The number of films for each rating.
        1.3 The number of films for each rating, and sort the results in descending order of the number of films. This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.
    We need to track the performance of our employees. Using the rental table, determine the number of rentals processed by each employee. This will help us identify our top-performing employees and areas where additional training may be necessary.
    Using the film table, determine:
        3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help us identify popular movie lengths for each category.
        3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.
    Determine which last names are not repeated in the table actor.
*/


# CHALLENGE 1 
-- 1.1
SELECT
MIN(length) AS min_duration,
MAX(length) AS max_duration
FROM film;

-- 1.2
SELECT 
FLOOR(AVG(length) / 60) AS avg_hours, 
ROUND(AVG(length) % 60) AS avg_minutes 
FROM film;

-- 2.1
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS operational_days
FROM rental;

-- 2.2
SELECT 
    rental_date, 
    MONTH(rental_date) AS rental_month, 
    DAYNAME(rental_date) AS rental_weekday 
FROM rental
LIMIT 20;

-- 2.3

SELECT DAYOFWEEK('2005-05-21'); -- 7 = saturday
SELECT DAYOFWEEK('2005-05-22'); -- 1 = sunday
SELECT DAYOFWEEK('2005-05-23');
SELECT DAYOFWEEK('2005-05-24');
SELECT DAYOFWEEK('2005-05-25');
SELECT DAYOFWEEK('2005-05-26');
SELECT DAYOFWEEK('2005-05-27');

SELECT 
    rental_date, 
    CASE 
        WHEN DAYOFWEEK(rental_date) IN (1, 7) THEN 'weekend' -- i only use 7 and 1 so
        ELSE 'workday' 
    END AS DAY_TYPE 
FROM rental;

# film titles and their rental duration

SELECT 
    title, 
    IFNULL(CAST(rental_duration AS CHAR), 'Not Available') AS rental_duration 
FROM film
ORDER BY title ASC;

# first 3 characters of their email address

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    LEFT(email, 3) AS email_start 
FROM customer
ORDER BY last_name ASC;


# CHALLENGE 2

-- 1.1

SELECT COUNT(*) AS total_films
FROM film;

-- 1.2

SELECT 
    rating, 
    COUNT(*) AS num_films 
FROM film
GROUP BY rating;

-- 1.3

SELECT 
    rating, 
    COUNT(*) AS num_films 
FROM film
GROUP BY rating
ORDER BY num_films DESC;

# top-performing employees

SELECT 
    staff_id, 
    COUNT(*) AS num_rentals 
FROM rental
GROUP BY staff_id;

-- 3.1

SELECT 
    rating, 
    ROUND(AVG(length), 2) AS mean_duration 
FROM film
GROUP BY rating
ORDER BY mean_duration DESC;

-- 3.2

SELECT 
    rating, 
    ROUND(AVG(length), 2) AS mean_duration 
FROM film
GROUP BY rating
HAVING mean_duration > 120;

SELECT 
    last_name 
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;