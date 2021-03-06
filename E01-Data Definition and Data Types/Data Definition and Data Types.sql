/**********************
1.	Create Tables
**********************/

CREATE TABLE minions (
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30),
age INT(11)
);

CREATE TABLE towns (
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30)
);

/**********************
2.	Alter Minions Table
**********************/

ALTER TABLE minions
ADD COLUMN town_id INT(11);

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns FOREIGN KEY(town_id) REFERENCES towns(id);

/**********************
3.	Insert Records in Both Tables
**********************/

INSERT INTO towns (id, name) VALUES (1,'Sofia');
INSERT INTO towns (id, name) VALUES (2,'Plovdiv');
INSERT INTO towns (id, name) VALUES (3,'Varna');
INSERT INTO minions (id,name, age, town_id) VALUES (1,'Kevin', 22, 1);
INSERT INTO minions (id,name, age, town_id) VALUES (2,'Bob', 15, 3);
INSERT INTO minions (id,name, age, town_id) VALUES (3,'Steward', null, 2);

/**********************
4.	Truncate Table Minions
**********************/

TRUNCATE TABLE minions;

/**********************
5.	Drop All Tables
**********************/

DROP TABLE minions;
DROP TABLE towns;

/**********************
6.	Create Table People
**********************/

CREATE TABLE people(
id INT(11) PRIMARY KEY AUTO_INCREMENT UNIQUE,
name VARCHAR(200) NOT NULL,
picture TINYBLOB,
height DOUBLE(3,2),
weight  DOUBLE(5,2),
gender ENUM('m','f') NOT NULL,
birthdate DATE NOT NULL,
biography TEXT
);

INSERT INTO people (id,name,picture,height,weight,gender,birthdate,biography)
VALUES(1,'Pesho',null,1.8,45.0,'m','1889-01-05','xchvjb'),
(2,'Gesho',null,5.8,55.0,'m','1889-02-05','xhjvjb'),
(3,'Nesho',null,2.8,65.0,'f','1880-01-07','xcjb'),
(4,'Desho',null,3.8,47.0,'m','1989-01-05','xchvjb'),
(5,'Aesho',null,4.8,57.0,'f','1879-01-08','hj');

/**********************
8.	Change Primary Key
**********************/

SELECT * FROM users;

ALTER TABLE users
MODIFY COLUMN id INT(11);

ALTER TABLE users
DROP PRIMARY KEY;

Alter table users
ADD PRIMARY KEY(id,username);

/**********************
9.	Set Default Value of a Field
**********************/
ALTER TABLE users
MODIFY  COLUMN last_login_time 
TIMESTAMP 
NOT NULL DEFAULT CURRENT_TIMESTAMP;

/**********************
10.Set Unique Field
**********************/

ALTER TABLE users
MODIFY id INT(11) NOT NULL;

ALTER TABLE users 
DROP PRIMARY KEY;

ALTER TABLE users 
ADD CONSTRAINT pk_users PRIMARY KEY(id);

ALTER TABLE users 
ADD CONSTRAINT unique_username UNIQUE (username);

/**********************
11.	Movies Database
**********************/

CREATE TABLE directors(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
director_name VARCHAR(40) NOT NULL,
notes TEXT
);

INSERT INTO directors(id,director_name)
values(1,'AAA'),(2,'BBB'),(3,'CCC'),(4,'DDD'),(5,'EEE');

CREATE TABLE genres(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
genre_name VARCHAR(40) NOT NULL,
notes TEXT
);

INSERT INTO genres(id,genre_name)
values(1,'aaa'),(2,'bbb'),(3,'ccc'),(4,'ddd'),(5,'eee');

CREATE TABLE categories(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
category_name VARCHAR(40) NOT NULL,
notes TEXT
);

INSERT INTO categories(id,category_name)
values(1,'z'),(2,'x'),(3,'c'),(4,'v'),(5,'b');

CREATE TABLE movies(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(40) NOT NULL,
director_id INT(11),
copyright_year DATETIME NOT NULL,
length INT(11) NOT NULL,
genre_id INT(11) NOT NULL,
category_id INT(11) NOT NULL,
rating INT(11),
notes TEXT
);

INSERT INTO movies(id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes)
 values(1,'qq',2,'1990-02-01',100,1,3,5,'aaaab'),
(2,'ww',3,'1990-04-05',120,3,1,10,'aab'),
(3,'jj',2,'1995-09-01',90,1,2,5,'aahb'),
(4,'hh',1,'1990-08-06',125,2,1,4,'ahhaab'),
(5,'ss',2,'1996-02-01',150,1,2,5,'aahaamb');

/**********************
12.	Car Rental Database
**********************/

CREATE TABLE categories(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
category VARCHAR(40) NOT NULL,
daily_rate INT(11),
weekly_rate INT(11),
monthly_rate INT(11),
weekend_rate INT(11) 
);

INSERT INTO categories(category)
VALUES('AAA'),('BBB'),('FFF');

CREATE TABLE cars(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
plate_number INT(11) NOT NULL,
make VARCHAR(15) NOT NULL,
model VARCHAR(25) NOT NULL,
car_year DATETIME,
category_id INT(11),
doors INT(11),
picture BLOB,
car_condition VARCHAR(15),
available BIT
);

INSERT INTO cars(plate_number,make,model)
VALUES(1,'a','AAA'),(22,'a','BBB'),(11,'a','FFF');

CREATE TABLE employees(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(15) NOT NULL,
last_name VARCHAR(15) NOT NULL,
title VARCHAR(15),
notes TEXT
);

INSERT INTO employees(first_name,last_name)
VALUES('a','AAA'),('b','BBB'),('c','FFF');

CREATE TABLE customers(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
driver_licence_number INT(11) NOT NULL,
full_name VARCHAR(30) NOT NULL,
address VARCHAR(50),
city VARCHAR(15),
zip_code INT(11),
notes TEXT
);

INSERT INTO customers(driver_licence_number,full_name)
VALUES(111,'AAA'),(255,'BBB'),(1256,'FFF');

CREATE TABLE rental_orders(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
employee_id INT(11) NOT NULL,
customer_id INT(11) NOT NULL,
car_id INT(11) NOT NULL,
car_condition VARCHAR(20),
tank_level VARCHAR(20),
kilometrage_start INT(11),
kilometrage_end INT(11),
total_kilometrage INT(11), 
start_date DATETIME,
end_date DATETIME,
total_days INT(11) ,
rate_applied VARCHAR(20),
tax_rate INT(11) ,
order_status VARCHAR(20),
notes TEXT
);

INSERT INTO rental_orders(employee_id,customer_id,car_id)
VALUES(1,2,3),(2,3,4),(3,4,5);

/**********************
13.	Hotel Database
**********************/

CREATE TABLE employees(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30),
title VARCHAR(30),
notes TEXT
);

INSERT INTO employees(id,first_name)
VALUES(1,'AAA'),(2,'BBB'),(3,'CCC');

CREATE TABLE customers (
account_number INT(11) AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(30) NOT NULL, 
last_name VARCHAR(30) NOT NULL,
phone_number INT(11),
emergency_name VARCHAR(30),
emergency_number VARCHAR(30),
notes TEXT
);

INSERT INTO customers(account_number,first_name,last_name)
VALUES(1,'AAS','BBS'),(2,'ASD','DS'),(3,'ADF','ASF');

CREATE TABLE room_status (
room_status VARCHAR(10) PRIMARY KEY,
notes TEXT
);

INSERT INTO room_status(room_status)
VALUES('FREE'),('NOT FREE'),('NNN');

CREATE TABLE room_types(
room_type VARCHAR(10) PRIMARY KEY,
notes TEXT
);

INSERT INTO room_types(room_type)
VALUES('DOUBLE'),('SINGLE'),('SUIT');

CREATE TABLE bed_types(
bed_type VARCHAR(10) PRIMARY KEY,
notes TEXT
);

INSERT INTO bed_types(bed_type)
VALUES('KING SIZE'),('PERSON'),('SOFA');

CREATE TABLE rooms(
room_number INT(11) AUTO_INCREMENT PRIMARY KEY, 
room_type VARCHAR(30),
bed_type VARCHAR(30),
rate VARCHAR(30), 
room_status VARCHAR(30), 
notes TEXT
);

INSERT INTO rooms(room_number)
VALUES(1),(2),(3);

CREATE TABLE payments(
id INT(11) AUTO_INCREMENT PRIMARY KEY,
employee_id INT(11),
payment_date DATETIME, 
account_number VARCHAR(15), 
first_date_occupied DATETIME, 
last_date_occupied DATETIME, 
total_days INT(11), 
amount_charged DECIMAL(10,2), 
tax_rate DECIMAL(10,2), 
tax_amount DECIMAL(10,2), 
payment_total DECIMAL(10,2), 
notes TEXT
);

INSERT INTO payments(id)
VALUES(1),(2),(3);

CREATE TABLE occupancies(
id INT(11) AUTO_INCREMENT PRIMARY KEY, 
employee_id INT(11) ,
date_occupied DATETIME,
account_number VARCHAR(10),
room_number INT(11),
rate_applied VARCHAR(10), 
phone_charge VARCHAR(10), 
notes TEXT
);

INSERT INTO occupancies(id)
VALUES(1),(2),(3);

/***************************
14.	Create SoftUni Database
***************************/

CREATE TABLE towns(
id INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL,
name VARCHAR(30)
);

CREATE TABLE addresses(
id INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL,
address_text VARCHAR(50),
town_id INT(11),
CONSTRAINT fk_addresses_towns FOREIGN KEY (town_id)
REFERENCES towns(id) 
);

CREATE TABLE departments(
id INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL,
name VARCHAR(30)
);

CREATE TABLE employees(
id INT(11) AUTO_INCREMENT PRIMARY KEY NOT NULL,
first_name VARCHAR(15),
middle_name VARCHAR(15),
last_name VARCHAR(15),
job_title VARCHAR(15),
department_id INT(11),
hire_date DATETIME,
salary DECIMAL (10,2),
address_id INT(11),
CONSTRAINT fk_address_id FOREIGN KEY (address_id)
REFERENCES addresses(id),
CONSTRAINT fk_department_id FOREIGN KEY (department_id)
REFERENCES  departments (id)  
);

/***************************
16.	Basic Insert
***************************/

INSERT INTO towns(name)
VALUES('Sofia'),('Plovdiv'),('Varna'),('Burgas');

INSERT INTO departments(name)
VALUES('Engineering'),('Sales'),('Marketing'),('Software Development'),('Quality Assurance');

INSERT INTO employees(first_name,middle_name,last_name,job_title,department_id,hire_date,salary)
VALUES('Ivan','Ivanov','Ivanov','.NET Developer',4,'2013-02-01','3500.00'),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02','4000.00'),
('Maria','Petrova','Ivanova','Intern',5,'2016-08-28','525.25'),
('Georgi','Terziev','Ivanov','CEO',2,'2007-12-09','3000.00'),
('Peter','Pan','Pan','Intern',3,'2016-08-28','599.88');

/***************************
17.	Basic Select All Fields
***************************/

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

/*******************************************
18.	Basic Select All Fields and Order Them
*******************************************/

SELECT * FROM towns ORDER BY name;
SELECT * FROM departments ORDER BY name;
SELECT * FROM employees ORDER BY salary DESC;

/*******************************************
19.	Basic Select Some Fields
*******************************************/

SELECT name FROM towns ORDER BY name;
SELECT name FROM departments ORDER BY name;
SELECT first_name,last_name,job_title,salary FROM employees ORDER BY salary DESC;

/*******************************************
20.	Increase Employees Salary
*******************************************/

UPDATE employees
SET salary=salary*1.1;
SELECT salary FROM employees;
