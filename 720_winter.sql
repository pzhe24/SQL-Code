alter SESSION  set NLS_DATE_FORMAT = 'DD-MM-RR';

--lab 7
--Q1
CREATE TABLE cities 
AS (SELECT location_id, street_address, postal_code, city, state_province, country_id
FROM locations
WHERE location_id < 2000);

SELECT * FROM cities;

--Q2
CREATE TABLE towns 
AS (SELECT location_id, street_address, postal_code, city, state_province, country_id
FROM locations
WHERE location_id < 1500);

SELECT * FROM towns;

--Q3
PURGE RECYCLEBIN;

DROP TABLE towns;
SHOW RECYCLEBIN;

--Q4
FLASHBACK TABLE towns TO BEFORE DROP;
SHOW RECYCLEBIN;

--Q5
DROP TABLE towns PURGE;
SHOW RECYCLEBIN
FLASHBACK TABLE towns TO BEFORE DROP;

--Q6
CREATE VIEW can_city_vu AS
(SELECT street_address, postal_code, city, state_province
FROM cities WHERE LOWER(country_id) IN ('ca'));

SELECT * FROM can_city_vu;

--Q7
CREATE OR REPLACE VIEW can_city_vu AS
(SELECT street_address AS "Str_Adr", postal_code AS "P_Code", city AS "City", state_province AS "Prov"
FROM cities WHERE LOWER(country_id) IN ('ca','it'));

SELECT * FROM can_city_vu;

--Q8
CREATE VIEW city_dname_vu AS
(SELECT d.department_name, l.city, l.state_province
FROM locations l LEFT OUTER JOIN departments d
ON (l.location_id = d.location_id)
WHERE LOWER(l.country_id) IN ('ca','it'));

SELECT * FROM city_dname_vu;

--Q9
CREATE OR REPLACE VIEW city_dname_vu AS
(SELECT d.department_name AS "DName", l.city AS "City", l.state_province AS "Prov"
FROM locations l LEFT OUTER JOIN departments d
ON (l.location_id = d.location_id)
WHERE LOWER(l.country_id)  NOT IN ('us'));

SELECT * FROM city_dname_vu;

--Q10
SELECT view_name, text
FROM   user_views;

DROP VIEW city_dname_vu;



SELECT * FROM locations;
SELECT * FROM employees;

DESC locations;
