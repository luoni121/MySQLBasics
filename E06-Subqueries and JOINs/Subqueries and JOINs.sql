/*********************************************
1.	Employee Address
*********************************************/

SELECT 
    e.employee_id, e.job_title, a.address_id, a.address_text
FROM
    employees e
INNER JOIN
    addresses a ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

/*********************************************
2.	Addresses with Towns
*********************************************/

SELECT 
    e.first_name, e.last_name, t.name AS `town`, a.address_text
FROM
    employees e
INNER JOIN
    addresses a ON e.address_id = a.address_id
INNER JOIN
    towns t ON t.town_id = a.town_id
ORDER BY e.first_name , e.last_name
LIMIT 5;

/*********************************************
3.	Sales Employee
*********************************************/

SELECT 
     e.employee_id, e.first_name, e.last_name, d.name
FROM
    employees e
INNER JOIN
    departments d ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

/*********************************************
4.	Employee Departments
*********************************************/

SELECT 
     e.employee_id, e.first_name, e.salary, d.name
FROM
    employees e
INNER JOIN
    departments d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

/*********************************************
5.	Employees Without Project
*********************************************/

SELECT 
     e.employee_id, e.first_name
FROM
    employees e
LEFT JOIN
    employees_projects ep ON ep.employee_id = e.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC
LIMIT 3;

/*********************************************
6.	Employees Hired After
*********************************************/

SELECT e.first_name, e.last_name, e.hire_date, d.name AS `dept_name`
FROM
    employees e
JOIN
    departments d ON e.department_id = d.department_id
WHERE
	d.name IN ('Sales','Finance') AND
  DATE(e.hire_date) > '1999-01-01'
ORDER BY e.hire_date;

/*********************************************
7.	Employees with Project
*********************************************/

/*********************************************
8.	Employee 24
*********************************************/


/*********************************************
9.	Employee Manager
*********************************************/


/*********************************************
10.	Employee Summary
*********************************************/


/*********************************************
11.	Min Average Salary
*********************************************/


/*********************************************
12.	Highest Peaks in Bulgaria
*********************************************/



/*********************************************
13.	Count Mountain Ranges
*********************************************/


/*********************************************
14.	Countries with Rivers
*********************************************/


/*********************************************
15.	*Continents and Currencies
*********************************************/


/*********************************************
16.	Countries without any Mountains
*********************************************/

/*********************************************
17.	Highest Peak and Longest River by Country
*********************************************/






















