/******************************************************
Section 1: Data Definition Language (DDL)
******************************************************/

CREATE TABLE users (
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL
);

CREATE TABLE repositories (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE repositories_contributors (
repository_id INT,
contributor_id INT 
);

CREATE TABLE issues (
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
issue_status VARCHAR(6) NOT NULL,
repository_id INT NOT NULL,
assignee_id INT NOT NULL
);

CREATE TABLE commits (
id INT PRIMARY KEY AUTO_INCREMENT,
message VARCHAR(255) NOT NULL,
issue_id INT,
repository_id INT NOT NULL,
contributor_id INT NOT NULL
);

CREATE TABLE files (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
size DECIMAL(10,2) NOT NULL,
parent_id INT,
commit_id INT NOT NULL
);

ALTER TABLE repositories_contributors
ADD CONSTRAINT fk_repositories_contributors_users
FOREIGN KEY repository_contributories(contributor_id) 
REFERENCES users(id);

ALTER TABLE repositories_contributors
ADD CONSTRAINT fk_repositories_contributors_repositories
FOREIGN KEY repository_contributories(repository_id) 
REFERENCES repositories(id);

ALTER TABLE issues
ADD CONSTRAINT fk_issues_repositories
FOREIGN KEY issues(repository_id) 
REFERENCES repositories(id);

ALTER TABLE issues
ADD CONSTRAINT fk_issues_users
FOREIGN KEY issues(assignee_id) 
REFERENCES users(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_issues
FOREIGN KEY commits(issue_id) 
REFERENCES issues(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_repositories
FOREIGN KEY commits(repository_id) 
REFERENCES repositories(id);

ALTER TABLE commits
ADD CONSTRAINT fk_commits_users
FOREIGN KEY commits(contributor_id) 
REFERENCES users(id);

ALTER TABLE files
ADD CONSTRAINT fk_files_commits
FOREIGN KEY files(commit_id) 
REFERENCES commits(id);

ALTER TABLE files
ADD CONSTRAINT fk_files_files
FOREIGN KEY files(parent_id) 
REFERENCES files(id);

/******************************************************
02.	Data Insertion
******************************************************/

INSERT INTO issues(title, issue_status, repository_id, assignee_id)
SELECT 
	CONCAT('Critical Problem With ',f.name,'!'),
	'open' AS `issue_status`,
    Ceiling(f.id * 2/3) AS `repository_id`,
    c.contributor_id
FROM files f
JOIN commits c ON c.id = f.commit_id
WHERE f.id BETWEEN 46 AND 50;

/******************************************************
03.	Data Update
******************************************************/

INSERT INTO repositories_contributors(contributor_id, repository_id)
SELECT *
FROM 
(
	SELECT contributor_id
	FROM repositories_contributors
	WHERE contributor_id = repository_id
) AS t1
CROSS JOIN (
SELECT MIN(r.id)
FROM repositories r
LEFT JOIN repositories_contributors rc ON r.id = rc.repository_id
WHERE rc.repository_id IS NULL AND r.id IS NOT NULL) AS t2;

/******************************************************
04.	Data Deletion
******************************************************/

DELETE FROM repositories
WHERE id NOT IN (
	SELECT repository_id 
	FROM issues
);

/******************************************************
05.	Users
******************************************************/

SELECT id, username
FROM users
ORDER BY id;

/******************************************************
06.	Lucky Numbers
******************************************************/

SELECT rc.repository_id, rc.contributor_id
FROM repositories_contributors rc
WHERE rc.repository_id = rc.contributor_id
ORDER BY rc.repository_id;

/******************************************************
07.	Heavy HTML
******************************************************/

SELECT f.id, f.name, f.size
FROM files f
WHERE f.size > 1000 AND f.name LIKE '%html%'
ORDER BY f.size DESC;


/******************************************************
08.	Issues and Users
******************************************************/

SELECT s.id, CONCAT(u.username, ' : ' ,s.title) AS `issue_assignee`
FROM issues s
JOIN users u ON u.id = s.assignee_id
ORDER BY s.id DESC;

/******************************************************
09.	Non-Directory Files
******************************************************/

SELECT d.id, d.name, CONCAT(d.size,'KB')
FROM files f
RIGHT JOIN files d ON f.parent_id = d.id
WHERE f.id IS NULL
ORDER BY d.id;

/******************************************************
10.	Active Repositories
******************************************************/

SELECT i.repository_id, r.name, COUNT(i.id) AS `issues`
FROM issues i
JOIN repositories r ON r.id = i.repository_id
GROUP BY i.repository_id
ORDER BY issues DESC, i.repository_id
LIMIT 5;


/******************************************************
11.	Most Contributed Repository
******************************************************/

SELECT 
	r.id, 
	r.name,
	(
		SELECT COUNT(*)
		FROM commits
		WHERE commits.repository_id = r.id
	) AS `commits `,
	COUNT(u.id) AS `contributors`
FROM users u
JOIN repositories_contributors rc ON rc.contributor_id = u.id
JOIN repositories r ON r.id = rc.repository_id 
GROUP BY r.id
ORDER BY contributors DESC, r.id
LIMIT 1;


/******************************************************
12.	Fixing My Own Problems
******************************************************/

SELECT u.id, u.username, 
(
	SELECT COUNT(c.id)
	FROM commits c
	JOIN issues i ON i.id = c.issue_id
  WHERE i.assignee_id = u.id AND c.contributor_id = u.id
) AS com
FROM users u
ORDER BY com DESC, u.id;

/********************VARIANT 2*************************/

SELECT u.id, u.username, COUNT(c.id) as `commits`
FROM users u 
LEFT JOIN issues i ON i.assignee_id = u.id
LEFT JOIN commits c ON c.issue_id = i.id AND c.contributor_id = u.id
GROUP BY u.id
ORDER BY commits DESC, u.id;

/******************************************************
13.	Recursive Commits
******************************************************/

SELECT LEFT(f1.name, LOCATE('.', f1.name)-1),
(
	SELECT COUNT(*)
  FROM commits c
  WHERE c.message LIKE CONCAT('%',f1.name,'%')
)AS `recursive_count`

#SELECT LEFT(f1.name, POSITION('.' IN f1.name)-1)
FROM files f1
JOIN files f2 
ON f1.parent_id = f2.id 
	AND f2.parent_id = f1.id 
	AND f1.id != f2.id 
GROUP BY f1.id
ORDER BY f1.name;

/********************VARIANT 2*************************/

SELECT
	LEFT(f1.name, LOCATE('.', f1.name) - 1), 
	COUNT(c.id) AS `recursive_count`
FROM files f1
JOIN files f2 
	ON f1.parent_id = f2.id 
	AND f2.parent_id = f1.id 
	AND f1.id != f2.id 
LEFT JOIN commits c
	ON c.message LIKE CONCAT('%',f1.name,'%') 
GROUP BY f1.id
ORDER BY f1.name;

/******************************************************
14.	Repositories and Commits
******************************************************/

SELECT r.id, r.name, COUNT(DISTINCT c.contributor_id) AS `users`
FROM repositories r
LEFT JOIN commits c ON r.id = c.repository_id
GROUP BY r.id
ORDER BY users DESC, r.id;

/******************************************************
15.	Commit
******************************************************/

DELIMITER $$
CREATE PROCEDURE udp_commit(username VARCHAR(30), password VARCHAR(30), message VARCHAR(255), issue_id INT)
BEGIN
	DECLARE contributor_id INT;
	DECLARE repository_id INT;

	IF 1 <> (SELECT COUNT(*) FROM users WHERE users.username = username)
	THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No such user!';
    END IF;
    
	IF 1 <> (SELECT COUNT(*) FROM users WHERE users.username = username AND users.password = password)
	THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Password is incorrect!';
    END IF;
    
	IF 1 <> (SELECT COUNT(*) FROM issues WHERE issues.id = issue_id)
	THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'The issue does not exist!';
    END IF;

	SET contributor_id :=(
		SELECT u.id
		FROM users u
		WHERE u.username = username
	);
    
    SET repository_id :=(
		SELECT i.repository_id
		FROM issues i
		WHERE i.id = issue_id
	);
    
    INSERT INTO commits (repository_id, contributor_id, issue_id, message)
    VALUES(repository_id, contributor_id, issue_id, message);
    
    UPDATE issues
    SET issue_status = 'closed'
    WHERE issues.id = issue_id;
END $$

/******************************************************
16.	Filter Extensions
******************************************************/

DELIMITER $$
CREATE PROCEDURE udp_findbyextension (extension VARCHAR(100))
BEGIN
	SELECT id, name, CONCAT(size, 'KB')
    FROM files
    WHERE name LIKE CONCAT('%.', extension);
END $$












