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

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(emp_salary DECIMAL(19,4))
RETURNS VARCHAR(10)
BEGIN
	DECLARE result VARCHAR(10);

    IF emp_salary < 30000 THEN SET result = 'Low';
    ELSEIF emp_salary BETWEEN 30000 AND 50000 THEN SET result = 'Average';
    ELSE SET result = 'High';
    END IF;

    RETURN result;
END $$

/*******************************************
6.	Employees by Salary Level
*******************************************/

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(emp_salary DECIMAL(19,4))
RETURNS VARCHAR(10)
BEGIN
	DECLARE result VARCHAR(10);

    IF emp_salary < 30000 THEN SET result = 'Low';
    ELSEIF emp_salary BETWEEN 30000 AND 50000 THEN SET result = 'Average';
    ELSE SET result = 'High';
    END IF;

    RETURN result;
END $$

#DROP PROCEDURE IF EXISTS usp_get_employees_by_salary_level;
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_lvl VARCHAR(10))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees e
	WHERE ufn_get_salary_level(e.salary) = salary_lvl
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$

/*******************************************
7.	Define Function
*******************************************/

DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))  
RETURNS BIT
BEGIN
	DECLARE result BIT;
    DECLARE word_length INT(11);
	DECLARE index_i INT(11); 
    
	SET result :=1;
	SET word_length := CHAR_LENGTH(word);
   	SET index_i := 1; 
   
	WHILE(index_i <= word_length) DO 
	IF(set_of_letters NOT LIKE (CONCAT('%',SUBSTR(word, index_i, 1),'%'))) THEN
		SET result := 0;
	END IF;
   
	SET index_i = index_i + 1;
	END WHILE;

    RETURN result;
END $$

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













