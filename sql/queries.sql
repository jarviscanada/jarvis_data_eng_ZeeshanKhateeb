-- Question 1: Insert some data into a table (Spa)

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


-- Question 2: Insert calculated data into a table (Spa)

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


-- Question 3: Update some existing data (Tennis Court 2)

UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;

-- Question 4: Update a row based on the contents of another row

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

-- Question 5: Delete all bookings

DELETE FROM
  cd.bookings;


-- Question 6: Delete a member with no bookings

DELETE FROM
  cd.members
WHERE
  memid = 37;

-- Basics:

--Question 1 : Control which rows are retrieved 

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

--Question 2 : Basic string searches

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

--Question 3 : Matching against multiple possible values

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

-- Question 4 : Working with dates

SELECT
  memid,
  surname,
  firstname,
  joindate
FROM
  cd.members
WHERE
  joindate >= '2012-09-01';

-- Question 5 : Combining results from multiple queries

SELECT
  surname
FROM
  cd.members

UNION

SELECT
   name
FROM
   cd.facilities;


-- Joins 

-- Question 1: Retrieve the start times of members' bookings

SELECT
  b.starttime
FROM
  cd.bookings b
JOIN cd.members m
  ON b.memid = m.memid
WHERE
  m.firstname = 'David'
  AND m.surname = 'Farrell';

-- Question 2: Work out the start times of bookings for tennis courts

SELECT
  b.starttime AS start,
  f.name
FROM
  cd.bookings b
  JOIN cd.facilities f
  ON b.facid = f.facid
WHERE
  f.name LIKE 'Tennis Court%'
  AND DATE(b.starttime) = '2012-09-21'
ORDER BY
  b.starttime;

-- Question 3: Produce a list of all members, along with their recommender

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

-- Question 4: Produce a list of all members who have recommended another member

SELECT
   DISTINCT
  r.firstname,
  r.surname
FROM
  cd.members m
  JOIN cd.members r
  ON m.recommendedby = r.memid
ORDER BY
  r.surname,
  r.firstname;

--Question 5: Produce a list of all members, along with their recommender, using no joins

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

