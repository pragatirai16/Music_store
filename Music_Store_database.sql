Who is the junior most employee based on job title?

select * from employee
order by levels asc 
limit 1;

Who is the oldest employee?

select* from employee
order by hire_date asc
limit 1

Which country has the highest billing total?

select billing_country, sum(total) from invoice 
group by billing_country
order by sum(total) desc
limit 1;

Which country has the least invoice?

select billing_country, count(*) from invoice
group by billing_country
order by billing_country asc
limit 1;

which is the best customer(highest billing amount)?

select c.customer_id, c.first_name, c.last_name, sum(i.total) as Total
from customer c
join invoice i
on c.customer_id = i.customer_id
group by c.customer_id
order by Total desc
limit 1

To return name(alphabetically) and city of all Jazz music listener

select c.first_name, c.last_name, c.city from 
customer as c
join invoice as i on c.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
where track_id in
( select track_id
from track as t 
join genre as g 
on t.genre_id = g.genre_id
where g.name like 'Jazz')
order by c.first_name


A query to return artist name (artists who have written the most Jazz music) and 
their total track count

select a.name, count(a.artist_id) as Total_track
from track as t
join album as a 
on t.album_id = a.album_id
join artist as at on at.artist_id = a.artist_id
join 
