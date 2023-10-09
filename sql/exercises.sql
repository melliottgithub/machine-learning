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

select e.eventid, e.eventname, sum(s.qtysold) as attendance 
from sales s
join event e on e.eventid = s.eventid
group by e.eventid, e.eventname
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

-- 3. Construct a SQL query to retrieve events that occurred on a specific date say ‘2008-08-21’,
--  leveraging both the event and date tables. The query should extract event details, 
--  including names and start times, associated with the specified date.


select e.dateid, e.eventname, e.starttime, d.caldate
from event e
join date d on e.dateid = d.dateid
where d.caldate = '2008-08-21'





















