# Introduction

# SQL Queries

###### Modifying Data ######

###### Insert some data into a table

```sql
INSERT INTO cd.facilities (
  facid,
  name,
  membercost,
  guestcost,
  initialoutlay,
  monthlymaintenance
)
VALUES (
  9,
  'Spa',
  20,
  30,
  100000,
  800
);
```

Explanation: 
Inserted a new facility named *Spa* into the `cd.facilities` table.


###### Insert calculated data into a table

```sql
INSERT INTO cd.facilities (
  facid,
  name,
  membercost,
  guestcost,
  initialoutlay,
  monthlymaintenance
)
SELECT
  MAX(facid) + 1,
  'Spa',
  20,
  30,
  100000,
  800
FROM cd.facilities;
```

Explanation:
Inserted a new facility named Spa into the cd.facilities table using a calculated facid.


###### Update some existing data

```sql
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;
```

Explanation:
Corrected the initialoutlay value for Tennis Court 2 in the cd.facilities table.


###### Update a row based on the contents of another row

```sql
UPDATE cd.facilities
SET
  membercost = (
    SELECT membercost * 1.1
    FROM cd.facilities
    WHERE facid = 0
  ),
  guestcost = (
    SELECT guestcost * 1.1
    FROM cd.facilities
    WHERE facid = 0
  )
WHERE facid = 1;
```

Explanation:
Updated Tennis Court 2 prices to be 10% higher than Tennis Court 1 using values from another row.

###### Delete all bookings

```sql
DELETE FROM 
  cd.bookings;
```

Explanation:
Removed all records from the cd.bookings table as part of a database clearout.


###### Delete a member from the cd.members table

```sql
DELETE FROM 
  cd.members 
WHERE 
  memid = 37;
```

Explanation:
Deleted member 37 from the cd.members table since they had no associated bookings.


###### Basics ######

###### Control which rows are retrieved 

```sql
SELECT
  facid,
  name,
  membercost,
  monthlymaintenance
FROM 
  cd.facilities
WHERE
   membercost > 0
   AND membercost < monthlymaintenance / 50;
```

Explanation:
Retrieves facilities that charge members a fee which is less than 1/50th of their monthly maintenance cost.

###### Basic string searches

```sql
SELECT
  facid,
  name,
  membercost,
  guestcost,
  initialoutlay,
  monthlymaintenance
FROM
  cd.facilities
WHERE
  name LIKE '%Tennis%';
```

Explanation:
Retrieves all facilities whose name contains the word Tennis.

###### Matching against multiple possible values

```sql
SELECT
  facid,
  name,
  membercost,
  guestcost,
  initialoutlay,
  monthlymaintenance
FROM
  cd.facilities
WHERE
  facid IN (1, 5);
```

Explanation:
Retrieves facility details for multiple facility IDs using the IN clause instead of OR.

###### Working with dates

```sql
SELECT
  memid,
  surname,
  firstname,
  joindate
FROM
  cd.members
WHERE
  joindate >= '2012-09-01';
```

Explanation:
Retrieves members who joined on or after the start of September 2012.


###### Combining results from multiple queries

```sql
SELECT
  surname
FROM
  cd.members

UNION

SELECT
  name
FROM
  cd.facilities;
```

Explanation:
Combines member surnames and facility names into a single result set.

###### Joins ######

###### Retrieve the start times of members' bookings

```sql
SELECT
  b.starttime
FROM cd.bookings b
JOIN cd.members m
  ON b.memid = m.memid
WHERE m.firstname = 'David'
  AND m.surname = 'Farrell';
```

Explanation:
Retrieves booking start times for the member named David Farrell using a join between members and bookings.


###### Work out the start times of bookings for tennis courts

```sql
SELECT
  b.starttime AS start,
  f.name
FROM cd.bookings b
JOIN cd.facilities f
  ON b.facid = f.facid
WHERE f.name LIKE 'Tennis Court%'
  AND DATE(b.starttime) = '2012-09-21'
ORDER BY b.starttime;
```
Explanation:
Retrieves start times and facility names for tennis court bookings on 21 September 2012, ordered by time.


###### Produce a list of all members, along with their recommender

```sql
SELECT
  m.firstname AS memfname,
  m.surname AS memsname,
  r.firstname AS recfname,
  r.surname AS recsname
FROM
  cd.members m
  LEFT JOIN cd.members r
  ON m.recommendedby = r.memid
ORDER BY
  m.surname,
  m.firstname;
```

Explanation:
Lists all members and the members who recommended them, if any, using a self join.


###### Produce a list of all members who have recommended another member

```sql
SELECT DISTINCT
  r.firstname,
  r.surname
FROM
  cd.members m
JOIN cd.members r
  ON m.recommendedby = r.memid
ORDER BY
  r.surname, 
  r.firstname;
```

Explanation:
Lists members who appear as recommenders for other members, ensuring no duplicates.


###### Produce a list of all members, along with their recommender, using no joins

```sql
SELECT DISTINCT
  m.firstname || ' ' || m.surname AS member,
  (
    SELECT r.firstname || ' ' || r.surname
    FROM cd.members r
    WHERE r.memid = m.recommendedby
  ) AS recommender
FROM cd.members m
ORDER BY
  m.firstname || ' ' || m.surname;
```

Explanation:
Lists each member with their recommender using a correlated subquery (no JOINs), ordered by member name.


###### Aggregation ######

###### Count recommendations per member

```sql
SELECT
  recommendedby,
  COUNT(*) AS count
FROM 
  cd.members
WHERE recommendedby IS NOT NULL
GROUP BY
  recommendedby
ORDER BY
  recommendedby;
```

Explanation:
Counts how many members each person has recommended by grouping on recommendedby and ordering by member ID.

###### Total slots booked per facility

```sql
SELECT
  facid,
  SUM(slots) AS "Total Slots"
FROM 
  cd.bookings
GROUP BY
  facid
ORDER BY 
  facid;
```

Explanation:
Calculates the total number of booking slots per facility by summing slots and grouping by facility ID.

###### Total slots booked per facility in September 2012

```sql
SELECT
  facid,
  SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE starttime >= '2012-09-01'
  AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY "Total Slots";
```

Explanation:
Calculates total booking slots per facility for September 2012 by filtering bookings by date and aggregating slots.

###### Total slots booked per facility per month in 2012

```sql
SELECT
  facid,
  EXTRACT(MONTH FROM starttime) AS month,
  SUM(slots) AS "Total Slots"
FROM cd.bookings
WHERE starttime >= '2012-01-01'
  AND starttime < '2013-01-01'
GROUP BY
  facid,
  month
ORDER BY
  facid,
  month;
```

Explanation:
Calculates monthly total booking slots per facility for 2012 by grouping on facility ID and extracted month.

###### Count of members who have made at least one booking

```sql
SELECT
  COUNT(DISTINCT memid) AS count
FROM
  cd.bookings;
```
Explanation:
Counts the number of unique members (including guests) who have made at least one booking.

###### First booking per member after September 1st, 2012

```sql
SELECT
  m.surname,
  m.firstname,
  m.memid,
  MIN(b.starttime) AS starttime
FROM cd.members m
JOIN cd.bookings b
  ON m.memid = b.memid
WHERE b.starttime >= '2012-09-01'
GROUP BY
  m.memid,
  m.surname,
  m.firstname
ORDER BY
  m.memid;
```

Explanation:
Lists each members first booking after September 1st, 2012 by grouping bookings per member and selecting the earliest start time.

###### Total member count on each row

```sql
SELECT
  COUNT(*) OVER () AS count,
  firstname,
  surname
FROM cd.members
ORDER BY joindate;
```
Explanation:
Displays all members with the total number of members repeated on each row using a window function.

###### Numbered list of members

```sql
SELECT
  ROW_NUMBER() OVER (ORDER BY joindate) AS row_number,
  firstname,
  surname
FROM cd.members
ORDER BY joindate;
```
Explanation:
Generates a sequential row number for each member ordered by join date using a window function.

###### Facility with the highest number of slots booked

```sql
SELECT
  facid,
  SUM(slots) AS total
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) = (
  SELECT MAX(total_slots)
  FROM (
    SELECT SUM(slots) AS total_slots
    FROM cd.bookings
    GROUP BY facid
  ) sub
);
```
Explanation:

Finds the facility (or facilities) with the maximum total slots booked using aggregation and a subquery.


###### Strings ######

###### Format the names of members

```sql
SELECT
  surname || ', ' || firstname AS name
FROM cd.members
ORDER BY surname, firstname;
```
Explanation:
Formats member names as Surname, Firstname using string concatenation and orders them alphabetically.

###### Find telephone numbers with parentheses

```sql
SELECT
  memid,
  telephone
FROM cd.members
WHERE telephone LIKE '%(%'
ORDER BY memid;
```
Explanation:
Finds members whose telephone numbers contain parentheses using pattern matching.

###### Count members by surname initial

```sql
SELECT
  LEFT(surname, 1) AS letter,
  COUNT(*) AS count
FROM cd.members
GROUP BY
  LEFT(surname, 1)
ORDER BY
  letter;
```

Explanation:

Counts how many members have surnames starting with each letter of the alphabet.
