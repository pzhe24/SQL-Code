--Assignment 2
--Q2
CREATE TABLE record_label_region
(region_id NUMBER(4) PRIMARY KEY,
territory VARCHAR2(25) NOT NULL
CONSTRAINT territory_uniq UNIQUE);

CREATE TABLE record_label
(label_id NUMBER(3) PRIMARY KEY,
label_name VARCHAR2(25) NOT NULL
CONSTRAINT label_name_uniq UNIQUE,
url VARCHAR2(30) NOT NULL
CONSTRAINT url_uniq UNIQUE);

CREATE TABLE record_label_rep
(label_id NUMBER(3) REFERENCES record_label(label_id),
rep_number NUMBER(5)
CONSTRAINT rep_number_pk PRIMARY KEY,
first_name VARCHAR2(10) NOT NULL,
last_name VARCHAR2(10) NOT NULL,
phone VARCHAR2(15) NOT NULL
CONSTRAINT phone_uniq UNIQUE,
email VARCHAR2(40) NOT NULL
CONSTRAINT rep_email_uniq UNIQUE,
region_id NUMBER(4) REFERENCES record_label_region(region_id));

CREATE TABLE category
(category_id NUMBER(3)
CONSTRAINT category_id_pk PRIMARY KEY,
description VARCHAR2(10) NOT NULL
CONSTRAINT desc_uniq UNIQUE);

CREATE TABLE recording
(recording_id NUMBER(4)
CONSTRAINT recording_id_pk PRIMARY KEY,
title VARCHAR2(30) NOT NULL,
performer VARCHAR2(30) NOT NULL,
category_id NUMBER(3) REFERENCES category(category_id),
current_price NUMBER(4,2) NOT NULL
CONSTRAINT current_price_ck CHECK(current_price >0),
qty_in_stock NUMBER(3) NOT NULL
CONSTRAINT quantity_ck CHECK(qty_in_stock > =0),
label_id NUMBER(3)
CONSTRAINT label_id_fk REFERENCES record_label(label_id));

CREATE TABLE recording_history
(recording_id NUMBER(4) REFERENCES recording(recording_id),
price_number NUMBER(4) NOT NULL,
old_price NUMBER(4,2) NOT NULL
CONSTRAINT old_price_ck CHECK(old_price >0),
start_date DATE NOT NULL,
CONSTRAINT recording_price_pk PRIMARY KEY(recording_id,price_number));

CREATE TABLE customer
(customer_number NUMBER(5)
CONSTRAINT customer_number_pk PRIMARY KEY,
first_name VARCHAR2(10) NOT NULL,
last_name VARCHAR2(10) NOT NULL,
dob DATE NOT NULL,
address VARCHAR2(30) NOT NULL,
city VARCHAR2(20) NOT NULL,
province VARCHAR2(20) NOT NULL,
postal_code VARCHAR2(6) NOT NULL,
email VARCHAR2(40) NOT NULL
CONSTRAINT customer_email_uniq UNIQUE);

CREATE TABLE order_summary
(order_number NUMBER(6)
CONSTRAINT order_number_pk PRIMARY KEY,
customer_number NUMBER(5)
CONSTRAINT customer_number_fk REFERENCES customer(customer_number),
order_date DATE NOT NULL,
order_total NUMBER(5,2) NOT NULL);

CREATE TABLE item
(order_number NUMBER(6) REFERENCES order_summary(order_number),
item_number NUMBER(5) NOT NULL,
unit_price NUMBER(4,2) NOT NULL
CONSTRAINT price_ck CHECK(unit_price >0),
quantity NUMBER(3) NOT NULL
CONSTRAINT qty_ck CHECK(quantity >=0),
recording_id
CONSTRAINT recording_id_fk REFERENCES recording(recording_id),
CONSTRAINT ordernum_itemnum_pk PRIMARY KEY(order_number, item_number));

CREATE TABLE payment
(payment_id NUMBER(3)
CONSTRAINT payment_id_pk PRIMARY KEY,
credit_card_number VARCHAR2(16) NOT NULL,
name_on_card VARCHAR2(30) NOT NULL,
expiry_date DATE NOT NULL,
card_type CHAR(1) NOT NULL
CONSTRAINT card_type_ck CHECK(LOWER(card_type) IN ('a','d','m','v')),
order_number NUMBER(6)
CONSTRAINT order_number_fk REFERENCES order_summary(order_number));

--Sample Data
--record_label_region
INSERT INTO record_label_region
VALUES (1000, 'Ontario');

INSERT INTO record_label_region
VALUES (1100, 'Alberta');

INSERT INTO record_label_region
VALUES (1200, 'New Brunswick');

INSERT INTO record_label_region
VALUES (1300, 'British Columbia');

--record_label
INSERT INTO record_label
VALUES (100,'Sony Music Entertainment','www.sampleurl.com');

INSERT INTO record_label
VALUES (101,'Universal Music','www.sampleurl1.com');

INSERT INTO record_label
VALUES (102,'Warner Music Group','www.sampleurl2.com');

INSERT INTO record_label
VALUES (103, 'Island Records','www.sampleurl3.com');


--record_label_rep
INSERT INTO record_label_rep
VALUES (100, 12345, 'Howie', 'McGuire', '905-234-5678', 'h.mcguire@outlook.com', 1000);
INSERT INTO record_label_rep
VALUES (101, 23456, 'Billy', 'Doe', '905-111-1111', 'b.doe@gmail.com', 1100);
INSERT INTO record_label_rep
VALUES (102, 34567, 'Jason', 'Bourne', '905-222-2222', 'j.bourne@hotmail.com', 1200);
INSERT INTO record_label_rep
VALUES (103, 45678, 'Lily', 'Smith', '905-333-3333', 'l.smith@outlook.com', 1300);

--category
INSERT INTO category
VALUES (500, 'Country');
INSERT INTO category
VALUES (501, 'Hip-Hop');
INSERT INTO category
VALUES (502, 'Alt Rock');
INSERT INTO category
VALUES (503, 'Indie');


--recording
INSERT INTO recording
VALUES (1000, 'Smells Like Teen Spirit', 'Nirvana', 502, 24.99, 20, 100);
INSERT INTO recording
VALUES (1010, 'Dear Mama', '2Pac', 501, 20.99, 15, 101);
INSERT INTO recording
VALUES (1020, 'Choices', 'George Jones', 500, 10.99, 18, 102);
INSERT INTO recording
VALUES (1030, 'Wonderwall', 'Oasis', 502, 24.99, 30, 103);


--recording_history
INSERT INTO recording_history
VALUES (1000, 9000, 29.99, TO_DATE('JAN/01/01', 'MON/DD/RR'));
INSERT INTO recording_history
VALUES (1010, 9100, 29.99, TO_DATE('JAN/02/01', 'MON/DD/RR'));
INSERT INTO recording_history
VALUES (1020, 9200, 29.99, TO_DATE('JAN/03/01', 'MON/DD/RR'));
INSERT INTO recording_history
VALUES (1030, 9300, 29.99, TO_DATE('JAN/04/01', 'MON/DD/RR'));

--customer
INSERT INTO customer
VALUES (0001, 'James', 'Kittle', TO_DATE('FEB/01/01', 'MON/DD/RR'), '123 Sesame Street', 'Toronto', 'Ontario', 'M5G2K2', 'tester23@gmail.com');

INSERT INTO customer
VALUES (0002, 'John', 'Skittles', TO_DATE('MAR/02/02', 'MON/DD/RR'), '456 Sesame Street', 'Toronto', 'Ontario', 'M5G2L5', 'tester56@gmail.com');

INSERT INTO customer
VALUES (0003, 'Jack', 'Little', TO_DATE('APR/03/03', 'MON/DD/RR'), '999 Sesame Street', 'Toronto', 'Ontario', 'M5G3K5', 'tester89@gmail.com');

INSERT INTO customer
VALUES (0004, 'Jane', 'Fiddle', TO_DATE('MAY/04/04', 'MON/DD/RR'), '1010 Sesame Street', 'Toronto', 'Ontario', 'M5G5K5', 'tester90@gmail.com');

--order_summary
INSERT INTO order_summary
VALUES (123456, 0001, TO_DATE('DEC/31/19', 'MON/DD/RR'), 100.00);

INSERT INTO order_summary
VALUES (234567, 0002, TO_DATE('NOV/12/20', 'MON/DD/RR'), 200.00);

INSERT INTO order_summary
VALUES (456789, 0003, TO_DATE('OCT/31/21', 'MON/DD/RR'), 300.00);

INSERT INTO order_summary
VALUES (345678, 0004, TO_DATE('SEP/30/21', 'MON/DD/RR'), 50.00);


--item
INSERT INTO item
VALUES (123456, 001, 24.99, 2, 1000);
INSERT INTO item
VALUES (234567, 002, 20.99, 3, 1010);
INSERT INTO item
VALUES (456789, 003, 10.99, 1, 1020);
INSERT INTO item
VALUES (345678, 004, 19.99, 4, 1030);

--payment
INSERT INTO payment
VALUES (010, '5191230564363549', 'James Kittle', TO_DATE('OCT/31/24', 'MON/DD/RR'), 'A', 123456);
INSERT INTO payment
VALUES (020, '5191230599180123', 'John Skittles', TO_DATE('NOV/02/24', 'MON/DD/RR'), 'M', 234567);
INSERT INTO payment
VALUES (030, '5191520935452124', 'Jack Little', TO_DATE('SEP/10/24', 'MON/DD/RR'), 'V', 456789);
INSERT INTO payment
VALUES (040, '5191543023495320', 'Jane Fiddle', TO_DATE('AUG/11/24', 'MON/DD/RR'), 'D', 345678); 
COMMIT;


--5 Complex View
CREATE OR REPLACE VIEW cust_cat_ar_vu 
AS (SELECT c.last_name, c.city, c.dob, r.performer, r.title
FROM category cat JOIN recording r
USING (category_id) JOIN item 
USING (recording_id) JOIN order_summary
USING (order_number) JOIN customer c
USING(customer_number)
WHERE cat.description = 'Alt Rock');


SELECT * FROM cust_cat_ar_vu;

SELECT * FROM record_label_rep;

DESC record_label_rep;

--DROP TABLE RECORD_LABEL_REGION;
--DROP TABLE RECORD_LABEL;
--DROP TABLE RECORD_LABEL_REP;
--DROP TABLE category;
--DROP TABLE recording;
--DROP TABLE recording_history;
--DROP TABLE customer;
--DROP TABLE order_summary;
--DROP TABLE item;
--DROP TABLE payment;

