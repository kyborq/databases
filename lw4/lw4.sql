-- 3.1 INSERT
-- a) без указания списка полей
INSERT INTO `shop` 
VALUES (
	NULL, 
    "BookShop", 
	"Улица Пушкина, дом Колотушкина", 
    "https://bookshop.ru/"
); 

INSERT INTO `author` VALUES (NULL, "Иван", "Иванов", "Иванович", "2000-05-11", "Mosvow");
INSERT INTO `author` VALUES ("19", "Иван", "Иванов", "Иванович", "2000-05-11", "Mosvow");

-- b) с указанием списка полей
INSERT INTO `publisher` (`name`, `city`, `phone`) VALUES ("ТопИздат", "г. Москва", "8(800)555-35-35");

-- c) с чтением значения из другой таблицы
INSERT INTO `book` (`author_id`, `publisher_id`, `shop_id`, `name`) 
VALUES (1, 1, (SELECT `id` FROM `shop`), "Искусство моргать. Пособие для кипятильников");

-- 3.2 DELETE
-- a) всех записей
DELETE FROM `book`;

-- b) по условию
DELETE FROM `book` WHERE `book`.`author_id` = 1;

-- 3.3 UPDATE
-- a) всех записей
UPDATE `shop` SET `website` = "https://google.ru/";

-- b) по условию обновляя один атрибут
UPDATE `book` SET `name` = "Искусство дышать" WHERE `id` = 1;

-- c) по условию обновляя несколько атрибутов
UPDATE `author` SET `firstname` = "Константин", `lastname` = "Клюжев" WHERE `id` = 1;

-- 3.4 SELECT
-- a) с набором извлекаемых атрибутов
SELECT `firstname`, `lastname`, `middlename` FROM `author`;

-- b) со всеми атрибутами
SELECT * FROM `author`;

-- c) с условием по атрибуту
SELECT `name`, `phone` FROM `publisher` WHERE `city` = "г. Москва";

-- 3.5 SELECT ORDER BY + TOP (LIMIT)
-- a) с сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT * FROM `book`
ORDER BY `name` ASC LIMIT 3;

-- b) с сортировкой по убыванию DESC
SELECT * FROM `book`
ORDER BY `name` DESC;

-- c) с сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * FROM `book`
ORDER BY `name`, `author_id` ASC
LIMIT 3;

-- d) с сортировкой по первому атрибуту, из списка извлекаемых
SELECT `name`, `phone` FROM `publisher`
ORDER BY 1;

-- 3.6 Работа с датами
-- a) WHERE по дате
SELECT * FROM `author`
WHERE `birthdate` > "2000-01-01";

-- b) WHERE дата в диапазоне
SELECT * FROM `author`
WHERE `birthdate` > "1990-01-01" AND `birthdate` < "2005-01-01";

-- c) извлечь из таблицы не всю дату, а только год. Например, год рождения автора. Для этого используется функция YEAR
SELECT `firstname`, `lastname`, YEAR(`birthdate`) AS `year` FROM `author`;

-- 3.7 Функции агрегации
-- a) посчитать количество записей в таблице
SELECT COUNT(*) AS `author_count` FROM `author`;

-- b) посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT `name`) AS `unique_books` FROM `book`;

-- c) вывести уникальные значения столбца
SELECT DISTINCT `name` FROM `book`;

-- d) найти максимальное значение столбца
SELECT MAX(`cost`) AS `max_cost` FROM `order`;

-- e) Найти минимальное значение столбца
SELECT MIN(`cost`) AS `min_cost` FROM `order`;

-- f) написать запрос COUNT() + GROUP BY
SELECT COUNT(`book_id`) AS `books_count`, `client` FROM `order` GROUP BY `client`; -- Изменен

-- 3.8 SELECT GROUP BY + HAVING
-- a) написать 3 разных запроса с использованием GROUP BY + HAVING. 
--    для каждого запроса написать комментарий с пояснением, какую информацию извлекает запрос. 
--    запрос должен быть осмысленным, т.е. находить информацию, которую можно использовать

-- посмотреть количество рожденных авторов по годам после 1990
SELECT COUNT(`id`) AS `authors_count`, YEAR(`birthdate`) AS `year` 
FROM `author` GROUP BY `year` 
HAVING `year` > 1990;

-- посмотреть количество заказов клиентом Иваном
SELECT `client`, COUNT(`book_id`) AS `book_count` 
FROM `order` GROUP BY `client`
HAVING `client` = "Иван";

-- подсчет издательств по Москве -- исправлено
  SELECT `city`, COUNT(`id`) AS `publishers_count` 
    FROM `publisher` 
GROUP BY `city`
  HAVING `city` = "Москва";

-- 3.9 SELECT JOIN
-- a) LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT `order`.`client`, `order`.`cost`, `book`.`name`
FROM `order`
LEFT JOIN `book`
ON `order`.`book_id` = `book`.`id`
WHERE `order`.`client` = "Иван";

-- b) RIGHT JOIN. Получить такую же выборку, как и в 3.9 а
SELECT `order`.`client`, `order`.`cost`, `book`.`name`
FROM `book`
RIGHT JOIN `order`
ON `order`.`book_id` = `book`.`id`
WHERE `order`.`client` = "Иван";

-- c) LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT `book`.`name`, CONCAT(`author`.`firstname`, " ", `author`.`lastname`) AS `author`, `publisher`.`name` AS `publisher`
FROM `book`
LEFT JOIN `author` ON `author`.`id` = `book`.`author_id`
LEFT JOIN `publisher` ON `publisher`.`id` = `book`.`publisher_id`
WHERE `publisher`.`name` = "ТопИздат";

-- d) INNER JOIN двух таблиц
SELECT `order`.`client`, `book`.`name`
FROM `order`
INNER JOIN `book` ON `order`.`book_id` = `book`.`id`;
 
-- 3.10 Подзапросы
-- a) написать запрос сусловием WHERE IN (подзапрос)
SELECT `book`.`name` FROM `book`
WHERE `book`.`publisher_id` IN (SELECT `publisher`.`id` FROM `publisher`); 
 
-- b) написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT `book`.`name`, (SELECT SUM(`order`.`cost`) FROM `order` WHERE `order`.`book_id` = `book`.`id`) FROM `book`;

-- c) написать запрос вида SELECT * FROM (подзапрос)
SELECT `order`.`client` FROM (SELECT `client` FROM `order`) AS `order`;

-- d) написать запрос вида SELECT * FROM table JOIN (подзапрос) ON ...
SELECT * FROM `order`
JOIN (SELECT `book`.`id` FROM `book`) AS `book` 
 ON `book`.`id` = `order`.`book_id`;
