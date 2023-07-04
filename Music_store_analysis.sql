--Who is the junior most employee based on job title?

select * from employee
order by levels asc 
limit 1;

--Who is the oldest employee?

select* from employee
order by hire_date asc
limit 1

--Which country has the highest billing total?

select billing_country, sum(total) from invoice 
group by billing_country
order by sum(total) desc
limit 1;

--Which country has the least invoice?

select billing_country, count(*) from invoice
group by billing_country
order by billing_country asc
limit 1;

--which is the best customer(highest billing amount)?

select c.customer_id, c.first_name, c.last_name, sum(i.total) as Total
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.customer_id
order by Total desc
limit 1

--To return name(alphabetically) and city of all Jazz music listener

select c.first_name, c.last_name, c.city from 
customer as c
join invoice as i on c.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
where track_id in
( select track_id
from track as t 
join genre as g on t.genre_id = g.genre_id
where g.name like 'Jazz')
order by c.first_name


--A query to return artist name (artists who have written the most Jazz music) and 
 --their total track count (show top 10)

select at.name, count(at.artist_id) as Total_track
from track as t
join album as a on t.album_id = a.album_id
join artist as at on at.artist_id = a.artist_id
join genre as g on g.genre_id = t.genre_id 
Where g.name like 'Jazz'
group by at.artist_id
order by Total_track desc
limit 10;

-- tracks having milliseconds less than avergage length (order by smallest to largest)
select name, milliseconds
from track 
where milliseconds < (
select avg(milliseconds) 
from track)
order by milliseconds 

-- Amount spent by each customer on top 3 best selling artists

with top_3_artists as(
     select at.artist_id, at.name, sum(il.unit_price*il.quantity) as Amount
	from invoice_line as il
	join track as t on il.track_id = t.track_id
	join album as a on a.album_id = t.album_id
	join artist as at on at.artist_id = a.artist_id
	group by 1
	order by 3 desc
	limit 3)
select c.customer_id, c.first_name, c.last_name, top.name, 
sum(ile.unit_price*ile.quantity) as Amount 
from invoice as i 
join customer as c on c.customer_id = i.customer_id
join invoice_line as ile on ile.invoice_id = i.invoice_id
join track as tr on tr.track_id = ile.track_id
join album as al on al.album_id = tr.album_id
join top_3_artists as top on top.artist_id = al.artist_id
group by 1,2,3,4
order by 5 desc

--Most popular artist in each country

with popular_artist as 
(
select count(il.quantity) as purchase, c.country, at.artist_id, at.name,
row_number() over(partition by c.country order by count(il.quantity) desc) as rn
from invoice_line as il
join invoice i on il.invoice_id = i.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id = il.track_id
join album a on a.album_id = t.album_id
join artist at on at.artist_id = a.artist_id
group by 2,3,4
order by 2 asc, 1 desc)
select * from popular_artist where rn <=1;

--Most popular album in each country

with popular_album as 
(
select count(il.quantity) as purchase, c.country, a.album_id, a.title,
row_number() over(partition by c.country order by count(il.quantity) desc) as rn
from invoice_line as il
join invoice i on il.invoice_id = i.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id = il.track_id
join album a on a.album_id = t.album_id
group by 2,3,4
order by 2 asc, 1 desc)
select * from popular_album where rn <= 1;

--Highest spending customer from each country

WITH RECURSIVE 
	customter_country AS (
		SELECT c.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice i
		JOIN customer c ON c.customer_id = i.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;



