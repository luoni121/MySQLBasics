/*******************************************
1.	One-To-One Relationship
*******************************************/
CREATE TABLE passports
(
	passport_id INT(11) PRIMARY KEY AUTO_INCREMENT,
	passport_number CHAR(10) UNIQUE NOT NULL
);


CREATE TABLE persons 
(
    person_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL,
    passport_id INT(11) UNIQUE NOT NULL,
    CONSTRAINT fk_persons_passports FOREIGN KEY(passport_id) REFERENCES passports(passport_id) ON DELETE CASCADE
);


INSERT INTO passports
VALUES(101,'N34FG21B'),(102,'K65LO4R7'),(103,'ZE657QP2');

INSERT INTO persons
VALUES(1,'Roberto',43300.00,102),(2,'Tom', 56100.00,103),(3,'Yana', 60200.00, 101);

/*******************************************
2.	One-To-Many Relationship
*******************************************/

CREATE TABLE manufacturers
(
    manufacturer_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    established_on DATE  
);

CREATE TABLE models
(
model_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
manufacturer_id INT NOT NULL,
CONSTRAINT fk_models_manufacturers FOREIGN KEY(manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);

INSERT INTO Manufacturers
VALUES(1,'BMW','1916/03/01'),(2,'Tesla','2003/01/01'),(3,'Lada','1966/05/01');

INSERT INTO Models
VALUES( 101,'X1',1),(102,'i6',1),(103,'Model S',2),(104,'Model X',2),(105,'Model 3',2),(106,'Nova',3);

/*******************************************
3.	Many-To-Many Relationship
*******************************************/



/*******************************************
4.	Self-Referencing
*******************************************/

/*******************************************
5.	Online Store Database
*******************************************/

/*******************************************
6.	University Database
*******************************************/

/*******************************************
7.	SoftUni Design
*******************************************/

/*******************************************
9.	Peaks in Rila
*******************************************/

