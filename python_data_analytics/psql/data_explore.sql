-- =========================================
-- Setup Jarvis PSQL Data Warehouse
-- File: psql/data_explore.sql
-- Dataset: retail (loaded from retail.sql)
-- =========================================
  -----Verified Q2-Q5
-- Q0: Inspect table schema

  \d+ retail;

-- Q1: Show first 10 rows

  SELECT * FROM retail LIMIT 10;

 -- Q2: Check number of records
 -- Counts total rows in the retail table

  SELECT COUNT(*) AS count
  FROM retail;

 -- Q3: Number of clients (unique customer_id)
 -- Counts distinct customers

  SELECT COUNT(DISTINCT customer_id) AS count
  FROM retail;

 -- Q4: Invoice date range (min / max invoice_date)
 -- Finds the earliest and latest invoice dates

 SELECT
  MAX(invoice_date) AS max,
  MIN(invoice_date) AS min
  FROM retail;

-- Q5: Number of SKUs / merchants (unique stock_code)
-- Counts distinct products

  SELECT COUNT(DISTINCT stock_code) AS count
  FROM retail;

-- Q6: Average invoice amount excluding negative invoices

SELECT AVG(invoice_total) AS avg
FROM (
  SELECT
    invoice_no,
    SUM(quantity * unit_price) AS invoice_total
  FROM retail
  GROUP BY invoice_no
  HAVING SUM(quantity * unit_price) > 0
) sub;



-- Q7: Total revenue (SUM(unit_price * quantity))

SELECT SUM(unit_price * quantity) AS sum
FROM retail;

-- Q8: Total revenue by YYYYMM

SELECT
  EXTRACT(YEAR FROM invoice_date) * 100
  + EXTRACT(MONTH FROM invoice_date) AS yyyymm,
  SUM(unit_price * quantity) AS sum
FROM retail
GROUP BY yyyymm
ORDER BY yyyymm;


