# Introduction

# SQL Queries

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


###### Basics 

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

###### Joins 

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
