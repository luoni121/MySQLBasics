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

CREATE PROCEDURE usp_get_holders_full_name ()  
BEGIN
	SELECT CONCAT(a.first_name,' ', a.last_name) AS `full_name`
    FROM account_holders a
    ORDER BY full_name, a.id;
END

/*******************************************
9.	People with Balance Higher Than
*******************************************/
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(min_balance DECIMAL (19,4))
BEGIN
SELECT first_name, last_name FROM
	(
    SELECT a.id, first_name, last_name, sum(a.balance) AS total_balance 
	FROM account_holders AS ah
	JOIN accounts a ON a.account_holder_id = ah.id
	GROUP BY ah.first_name, ah.last_name
    )
AS result
WHERE result.total_balance> min_balance
ORDER BY  result.id;
END $$

/*******************************************
10.	Future Value Function
*******************************************/

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum DOUBLE, yearly_interest_rate DOUBLE, years INT(11))
RETURNS DOUBLE
BEGIN
	RETURN sum := sum * (POWER(1 + yearly_interest_rate, years));
END $$

/*******************************************
11.	Calculating Interest
*******************************************/

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum decimal(19,4), yearly_interest_rate decimal(19,4), years INT(11))
RETURNS decimal(19,4)
BEGIN
	SET sum := sum * (POWER(1 + yearly_interest_rate, years));
	RETURN sum;
END $$

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account (account_id INT(11), interest_rate decimal(19,4))
BEGIN
	SELECT a.id AS `account_id`, ah.first_name, ah.last_name, a.balance AS `current_balance`,
			ufn_calculate_future_value(a.balance, interest_rate, 5) AS `balance_in_5_years`
	FROM accounts a
	JOIN account_holders ah ON a.account_holder_id = ah.id
	WHERE a.id = account_id;
END $$

/*******************************************
12.	Deposit Money
*******************************************/

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT(11), money_amount DECIMAL (19, 4))
BEGIN
	IF money_amount > 0 THEN
		START TRANSACTION;
			UPDATE accounts AS a
			SET balance = balance + money_amount
			WHERE a.id = account_id;
	END IF;
END $$

/*******************************************
13.	Withdraw Money
*******************************************/

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT(11), money_amount DECIMAL(19, 4))
BEGIN
    IF (money_amount > 0) THEN
		START TRANSACTION;
        
        IF (SELECT a.balance
		FROM accounts AS a
           	WHERE a.id = account_id) - money_amount< 0
	THEN ROLLBACK;
	ELSE
    	    UPDATE accounts AS a
		SET a.balance = a.balance - money_amount
		WHERE a.id = account_id;
	COMMIT;
        END IF;
    END IF;
END $$

/*******************************************
14.	Money Transfer
*******************************************/

DELIMITER $$
#DROP PROCEDURE IF EXISTS usp_transfer_money;
CREATE PROCEDURE usp_transfer_money (from_account_id INT(11), to_account_id INT(11), amount DECIMAL (19,4))
BEGIN
	DECLARE stat INT;
	SET stat = 1;

	START TRANSACTION;
		IF (SELECT COUNT(*)
			FROM account_holders 
			WHERE id = from_account_id OR id = to_account_id) < 2 THEN
			SET stat = 0;
		END IF;
        
        IF amount < 0 THEN
			SET stat = 0;
		END IF;
       
		IF (SELECT balance
			FROM accounts
			WHERE id = from_account_id) < amount THEN
			SET stat = 0;
		END IF;
        
		IF from_account_id = to_account_id THEN
			SET stat = 0;
		END IF;
        
        UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;
        
		UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
    
		IF stat = 1
        THEN COMMIT;
        ELSE ROLLBACK;
        END IF;	
END $$

/*******************************************
15.	Log Accounts Trigger
*******************************************/

CREATE TABLE logs
(
log_id INT (11) PRIMARY KEY AUTO_INCREMENT,
account_id INT(11),
old_sum DECIMAL(19,4),
new_sum DECIMAL(19,4)
);

DELIMITER $$
CREATE TRIGGER tr_logs
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs (account_id, old_sum, new_sum)
	VALUES(OLD.id, OLD.balance, NEW.balance);
END $$

/*******************************************
16.	Emails Trigger
*******************************************/

CREATE TABLE logs
(
log_id INT (11) PRIMARY KEY AUTO_INCREMENT,
account_id INT(11),
old_sum DECIMAL(19,4),
new_sum DECIMAL(19,4)
);

DELIMITER $$
CREATE TRIGGER tr_logs
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs (account_id, old_sum, new_sum)
	VALUES(OLD.id, OLD.balance, NEW.balance);
END $$

CREATE TABLE notification_emails (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    recipient INT(11) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    body TEXT NOT NULL
);
 
DELIMITER $$
CREATE TRIGGER tr_notification_emails
AFTER INSERT 
ON logs
FOR EACH ROW
BEGIN
    INSERT INTO notification_emails
        (recipient, subject, body)
    VALUES (
        NEW.account_id,
        CONCAT('Balance change for account: ', NEW.account_id),
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), 
	       ' your balance was changed from ', 
	       NEW.old_sum, ' to ', NEW.new_sum, '.'));
END $$











