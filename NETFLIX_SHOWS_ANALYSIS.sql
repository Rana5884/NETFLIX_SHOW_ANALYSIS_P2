-- creating a netflix table

drop table if exists netflix;

CREATE TABLE netflix(
show_id varchar(10) ,
show_type varchar(50),
title varchar(150),
director varchar(210),
casts varchar(800),
country varchar(150),
date_added varchar(50),
releae_year int,
rating varchar(10),
duration varchar(20),
listed_in varchar(100),
description varchar(250)

);

-- checking if the data is imported

select * from netflix
limit 2;

-- checking the shape of the data
select count(*) from netflix



select distinct show_type
from netflix;

--15 BUSSINESS PROBLEMS RELATED TO THIS DATASET

/*
1. Count the number of Movies vs TV Shows
2. Find the most common rating for movies and TV shows
3. List all movies released in a specific year (e.g., 2020)
4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

*/

--1. Count the number of Movies vs TV Shows
SELECT * FROM netflix

select show_type,count(show_id)
from netflix
group by show_type;

--2. Find the most common rating for movies and TV shows


WITH RatingCounts AS (
    SELECT 
        show_type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY show_type, rating
),
RankedRatings AS (
    SELECT 
        show_type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)

--3. List all movies released in a specific year (e.g., 2020)
select * from netflix

select * 
from netflix
where show_type = 'Movie' and releae_year = 2020;


--4. Find the top 5 countries with the most content on Netflix

select * from netflix

select unnest(string_to_array(country,',')) as new_country,
count(show_id) as counts
from netflix
group by country
order by counts desc
limit 5;

--5. Identify the longest movie

select * from netflix

select * 
from netflix
where show_type='Movie' and 
duration = (
select max(duration) from netflix
);

--6. Find content added in the last 5 years

select * from netflix

select *
from netflix
where
   TO_DATE(date_added,'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years';


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM NETFLIX
WHERE DIRECTOR =  'Rajiv Chilaka';

-- OTHER METHOD TO SOLVE THIS

SELECT * FROM NETFLIX
WHERE DIRECTOR LIKE  '%Rajiv Chilaka%';

-- OTHER METHOD TO SOLVE THIS 

SELECT * FROM NETFLIX
WHERE DIRECTOR ILIKE  '%Rajiv Chilaka%';



--8. List all TV shows with more than 5 seasons

select * from netflix

SELECT *
FROM NETFLIX
WHERE show_type = 'TV Show'
and split_part(duration,' ',1) :: numeric  > 5

--9. Count the number of content items in each genre

select * from netflix

select unnest(string_to_array(listed_in,',')) as genre,
count(show_id) as counts
from netflix
group by genre
order by counts desc;


/*--10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release! */

SELECT 
	country,
	releae_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5



-- 11. List all movies that are documentaries

select * from netflix 

select *
--unnest(string_to_array(listed_in,',')) as genre
FROM netflix
WHERE  listed_in ilike '%Documentaries%' and show_type = 'Movie'


--12. Find all content without a director
select * from netflix
where director is null;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select *
--extract(year from To_Date(releae_year,'yyyy')) as year
from netflix
where casts ilike '%Salman Khan%'  
and 
   releae_year>= EXTRACT( YEAR FROM CURRENT_DATE) - 10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


select 
unnest(string_to_array(casts,',')) as actor,
count(show_id) as counts
from netflix
WHERE COUNTRY ilike '%India%'
group by actor
order by counts desc
limit 10;

/*--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category. */


SELECT 
    category,
	show_type,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2







