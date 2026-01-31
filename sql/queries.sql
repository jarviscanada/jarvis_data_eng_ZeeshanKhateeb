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


