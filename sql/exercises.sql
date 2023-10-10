-- 1.Fetch the names of all venues in the 
-- city of 'Washington,' arranging them alphabetically using the venue table.

select * from  venue

select venuename from venue v
where venuecity = 'Washington'
order by venuename asc

-- 2. Craft a SQL query to identify and rank 
-- the top 10 events with the highest attendance. 
-- Utilise the event table to extract key details, 
-- including event names and attendance figures, 
-- presenting them in descending order based on attendance.

-- select * from sales

select e.eventname, sum(s.qtysold) as attendance 
from sales s
join event e on e.eventid = s.eventid
group by e.eventname
order by attendance desc
limit 10 

WITH RankedEvents AS (
    SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance, 
           DENSE_RANK() OVER (ORDER BY SUM(s.qtysold) DESC) as attendance_rank
    FROM event e 
    JOIN sales s ON e.eventid = s.eventid 
    GROUP BY e.eventid, e.eventname
)

SELECT eventid, eventname, attendance
FROM RankedEvents
WHERE attendance_rank <= 10;



WITH EventAttendance AS (
    SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
    FROM event e 
    JOIN sales s ON e.eventid = s.eventid 
    GROUP BY e.eventid, e.eventname
    ORDER BY attendance DESC
),
TenthEventAttendance AS (
    SELECT attendance
    FROM (
        SELECT attendance, ROW_NUMBER() OVER (ORDER BY attendance DESC) as rnk
        FROM EventAttendance
    ) subquery
    WHERE rnk = 10
)

SELECT ea.eventid, ea.eventname, ea.attendance
FROM EventAttendance ea, TenthEventAttendance tea
WHERE ea.attendance >= tea.attendance
ORDER BY ea.attendance DESC;

-- step by step
SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
FROM event e 
JOIN sales s ON e.eventid = s.eventid 
GROUP BY e.eventid, e.eventname
ORDER BY attendance DESC;

SELECT eventid, eventname, attendance,
       ROW_NUMBER() OVER (ORDER BY attendance DESC) as rnk
FROM (
    SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
    FROM event e 
    JOIN sales s ON e.eventid = s.eventid 
    GROUP BY e.eventid, e.eventname
) subquery;

SELECT attendance
FROM (
    SELECT attendance, ROW_NUMBER() OVER (ORDER BY attendance DESC) as rnk
    FROM (
        SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
        FROM event e 
        JOIN sales s ON e.eventid = s.eventid 
        GROUP BY e.eventid, e.eventname
    ) subquery
) ranked_query
WHERE rnk = 10;

-- separating concerns

SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
FROM event e 
JOIN sales s ON e.eventid = s.eventid 
GROUP BY e.eventid, e.eventname
ORDER BY attendance DESC;

SELECT eventid, eventname, attendance,
       ROW_NUMBER() OVER (ORDER BY attendance DESC) as rnk
FROM (
    SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
    FROM event e 
    JOIN sales s ON e.eventid = s.eventid 
    GROUP BY e.eventid, e.eventname
) subquery;

SELECT attendance
FROM (
    SELECT attendance, ROW_NUMBER() OVER (ORDER BY attendance DESC) as rnk
    FROM (
        SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
        FROM event e 
        JOIN sales s ON e.eventid = s.eventid 
        GROUP BY e.eventid, e.eventname
    ) subquery
) ranked_query
WHERE rnk = 10;

WITH EventAttendance AS (
    SELECT e.eventid, e.eventname, SUM(s.qtysold) as attendance
    FROM event e 
    JOIN sales s ON e.eventid = s.eventid 
    GROUP BY e.eventid, e.eventname
    ORDER BY attendance DESC
),
TenthEventAttendance AS (
    SELECT attendance
    FROM (
        SELECT attendance, ROW_NUMBER() OVER (ORDER BY attendance DESC) as rnk
        FROM EventAttendance
    ) subquery
    WHERE rnk = 10
)

SELECT ea.eventid, ea.eventname, ea.attendance
FROM EventAttendance ea, TenthEventAttendance tea
WHERE ea.attendance >= tea.attendance
ORDER BY ea.attendance DESC;

--better query

with event_att as (
	select e.eventname, sum(s.qtysold) as attendance
	from event e
	join sales s
		on e.eventid =s.eventid
	group by e.eventname
)
, rank_query as (
	select *, dense_rank() over(order by attendance desc) as rank
	from event_att
)

select * from rank_query where rank <= 10

-- 3. Construct a SQL query to retrieve events that occurred on a specific date say ‘2008-08-21’,
--  leveraging both the event and date tables. The query should extract event details, 
--  including names and start times, associated with the specified date.


select e.dateid, e.eventname, e.starttime, d.caldate
from event e
join date d on e.dateid = d.dateid
where d.caldate = '2008-08-21'


-- 4. Identify the seller who has listed the highest number of tickets utilizing the listing table. 

select sellerid, count(numtickets) as total 
from listing
group by sellerid
order by total desc
limit 1


with SellerTotal as (
	select sellerid, count(numtickets) as total 
	from listing
	group by sellerid
	order by total desc
),
HighesTotal as (
	select total
	from (
		select total, row_number() over (order by total desc) as rank
		from SellerTotal
	) subquery
	where rank = 2 -- 1 used to to test
)

select sellerid, st.total 
from HighesTotal ht, SellerTotal st
where st.total >= ht.total
order by st.total desc


-- 5. Create a SQL query to list categories alongside the total number of events in each category. 
-- Utilize the category and event tables to extract and aggregate relevant information.


select c.catname as category , count(e.eventname) as event_count
from category c
join event e on e.catid = c.catid
group by category

 -- 6. Formulate a SQL query to calculate the total commission earned by 
 -- sellers for events in a specific city, for instance, 
 -- 'Kansas City’ utilizing the sales, event and venue tables to extract relevant information required.

select * from sales

select  s.sellerid, venuecity, sum(s.commission) as total_commission from sales s
join event e on e.eventid = s.eventid
join venue v on v.venueid = e.venueid
group by s.sellerid, venuecity
order by total_commission desc

-- 7. Devise a SQL query to calculate the average ticket price for each event category. 
-- Utilizing the category, event, and sales tables, extract relevant information 
-- and compute the average ticket price by considering the ratio 
-- of total price paid to the quantity sold for each event.

select catname, round(avg(pricepaid/ qtysold)::numeric,2) as avg_ticket_price
from category c
join event e on e.catid = c.catid
join sales s on e.eventid = s.eventid
group by catname

-- 8. Determine the total sales and average commission for each event category by 
-- creating an SQL subquery using ‘WITH’. Make use of the category, 
-- event, and sales tables strategically to calculate both total sales and average commission.


with 









































































