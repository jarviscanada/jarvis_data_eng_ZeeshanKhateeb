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


