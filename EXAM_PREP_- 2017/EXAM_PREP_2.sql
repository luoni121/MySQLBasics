/*********************-2-***********************/
/*******************INSERT*********************/
INCERT INTO messages (content, sent_on, chat_id, user_id)

SELECT
CONCAT(u.age, '-', u.gender, '-', l.latitude, '-', l.longitude),
'2016-12-15' AS sent-on,
CASE(
    WHEN u.gender = 'M' THEN ROUND(POW(u.age/18,3),0)
      WHEN u.gender = 'F' THEN CEIL(SQRT(u.age*2))

END) AS chat_id,
u.id AS `user_id`
FROM users u
JOIN locations l ON u.locations_id = l.id
WHERE u.id >= 10 AND u.id <=20;

/*********************-3-***********************/
/*******************UPDATE**********************/

UPDATE chats AS c
JOIN messages m ON m.chat_id = c.id AND c.sent_on < c.start_date
SET c.start_date = m.sent_on;

/***variant 2

UPDATE chats AS c
JOIN messages m ON m.chat_id = c.id
SET c.start_date = m.sent_on
WHERE c.sent_on < c.start_date;

/*********************-4-***********************/
/*******************DELETE**********************/

DELETE l
FROM locations l
LEFT JOIN users u ON u.location_id = l.id
WHERE u.id IS NULL;

/*********************-9-***********************/

SELECT c.id, COUNT(m.id) AS `total_messages`
FROM chats c
JOIN messages m ON m.chat_id = c.id AND m.id < 90
GROUP BY c.id
ORDER BY total_messages DESC, c.id
LIMIT 5;

/*********************-13-***********************/

SELECT c.title, m.content 
FROM chats c
LEFT JOIN messages m ON c.id = m.chat_id
WHERE c.start_date = (SELECT MAX(c.start_date) FROM chats c)
ORDER BY m.sent_on, m.id;

/*********************-15-**********************/

DROP FUNCTION IF EXISTS udf_get_radians;
CREATE FUNCTION udf_get_radians(degrees FLOAT)
RETURNS FLOAT
BEGIN 
RETURN (degrees * PI) / 180;
END

/*********************-16-**********************/

DROP PROCEDURE IF EXISTS udp_change_password;
CREATE PROCEDURE udp_change_password(user_email VARCHAR(30),  new_password VARCHAR(30))
BEGIN 
  IF(SELECT id FROM credentials WHERE email = user_email) IS NULL 
      THEN 
          SIGNAL SQL STATE '45000'
          SET MESSAGE TEXT = 'The email doesn\'t exist!' ;         
  ELSE
      UPDATE credentials SET password = new_password WHERE email = user_email;
  END IF;
END

/*********************-17-**********************/

DROP PROCEDURE IF EXISTS udp_send_messages;
CREATE PROCEDURE udp_send_messages(u_id INT, c_id INT, chat_msg VARCHAR(200))
BEGIN 
  IF(SELECT user_id FROM users_chats WHERE user_id = u_id AND chat_id = c_id) IS NULL 
      THEN 
          SIGNAL SQL STATE '45000'
          SET MESSAGE TEXT = 'There is no chat with that user!' ;         
  ELSE
      INSERT INTO messages (content, sent_on, chat_id, user_id)
      VALUES (chat_msg, '2016-12-15', c_id, u_id);
  END IF;
END

/*********************-18-**********************/

CREATE TRIGGER del_msg
AFTER DELETE
ON messages
FOR EACH ROW
BEGIN
    INSERT INTO backup VALUES (OLD.id, OLD.content, OLD.chat_id, OLD.user_id);
END

/*********************-19-**********************/

CREATE TRIGGER del_user
BEFORE DELETE
ON users
FOR EACH ROW
BEGIN
    DELETE FROM messages WHERE user_id = OLD.id;
    DELETE FROM messages_log WHERE user_id = OLD.id;
    DELETE FROM user_chats WHERE user_id = OLD.id;
END









                    

