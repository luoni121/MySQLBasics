/*******************************************
1.	Employees with Salary Above 35000
*******************************************/

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
     BEGIN
         SELECT e.first_name, e.last_name
         FROM employees e
         WHERE e.salary > 35000
         ORDER BY e.first_name, e.last_name, e.employee_id ;
END $$

/*******************************************
2.	Employees with Salary Above Number
*******************************************/

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(topSalary DOUBLE )
     BEGIN
         SELECT e.first_name, e.last_name
         FROM employees e
         WHERE e.salary >= topSalary
         ORDER BY e.first_name, e.last_name, e.employee_id;
END $$

/*******************************************
3.	Town Names Starting With
*******************************************/

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(input_str VARCHAR(50))
BEGIN
		DECLARE town_wildcard VARCHAR(50);
		SET town_wildcard := CONCAT(input_str, '%');
     
         SELECT t.name
         FROM towns t
         WHERE LOWER(t.name) LIKE LOWER(town_wildcard)
         ORDER BY t.name;
END $$

/*******************************************
4.	Employees from Town
*******************************************/

CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
     BEGIN
         SELECT e.first_name, e.last_name
         FROM employees e
         JOIN addresses a ON a.address_id = e.address_id
		 JOIN towns t ON t.town_id = a.town_id
         WHERE t.name = town_name
         ORDER BY e.first_name, e.last_name, e.employee_id;
END

/*******************************************
5.	Salary Level Function
*******************************************/



/*******************************************
6.	Employees by Salary Level
*******************************************/


/*******************************************
7.	Define Function
*******************************************/


/*******************************************
8.	Find Full Name
*******************************************/


/*******************************************
9.	People with Balance Higher Than
*******************************************/


/*******************************************
10.	Future Value Function
*******************************************/


/*******************************************
11.	Calculating Interest
*******************************************/



/*******************************************
12.	Deposit Money
*******************************************/


/*******************************************
13.	Withdraw Money
*******************************************/


/*******************************************
14.	Money Transfer
*******************************************/


/*******************************************
15.	Log Accounts Trigger
*******************************************/



/*******************************************
16.	Emails Trigger
*******************************************/













