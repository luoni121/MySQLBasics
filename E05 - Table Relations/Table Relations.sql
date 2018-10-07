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

CREATE TABLE students
(
    student_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL 
);

CREATE TABLE exams
(
   exam_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL 
);

CREATE TABLE students_exams (
    student_id INT(11) NOT NULL,
    exam_id INT(11) NOT NULL,
    CONSTRAINT pk_student_exam PRIMARY KEY (student_id , exam_id),
    CONSTRAINT fk_students_student_id FOREIGN KEY (student_id) REFERENCES students (student_id),
    CONSTRAINT fk_exam_exam_id FOREIGN KEY (exam_id) REFERENCES exams (exam_id)
);

INSERT INTO students(student_id, name)
VALUES (1,'Mila'), (2,'Toni'), (3,'Ron');
 
INSERT INTO exams(exam_id, name)
VALUES (101, 'Spring MVC'), (102, 'Neo4j'), (103, 'Oracle 11g');
 
INSERT INTO students_exams(student_id, exam_id)
VALUES (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103);

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

