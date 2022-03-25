-- 1. Добавить внешние ключи
-- Внешние ключи уже присутствуют в таблицах
-- они были добавлены извне

-- 2. Выдать информацию о клиентах гостиницы “Космос”, 
--    проживающих в номерах категории “Люкс” на 1 апреля 2019г
SELECT 
  `client`.`name`,
  `room`.`number`,
  `room`.`price`,
  `room_in_booking`.`checkin_date`,
  `room_in_booking`.`checkout_date`,
  `booking`.`booking_date`
FROM `room_in_booking`
  LEFT JOIN `booking` ON `booking`.`id_booking` = `room_in_booking`.`id_booking`
  LEFT JOIN `client` ON `client`.`id_client` = `booking`.`id_client`
  LEFT JOIN `room` ON `room`.`id_room` = `room_in_booking`.`id_room`
  LEFT JOIN `hotel` ON `hotel`.`id_hotel` = `room`.`id_hotel`
  LEFT JOIN `room_category` ON `room_category`.`id_room_category` = `room`.`id_room_category`
WHERE ("2019-04-01" BETWEEN `room_in_booking`.`checkin_date` AND `room_in_booking`.`checkout_date`)
  AND `hotel`.`name` = "Космос"
  AND `room_category`.`name` = "Люкс";

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля
SELECT 
  `room`.`number`,
  `room`.`price`,
  `room_category`.`name`,
  `hotel`.`name`
FROM `client`
  LEFT JOIN `booking` ON `booking`.`id_client` = `client`.`id_client`
  LEFT JOIN `room_in_booking` ON `room_in_booking`.`id_booking` = `booking`.`id_booking`
  LEFT JOIN `room` ON `room`.`id_room` = `room_in_booking`.`id_room`
  LEFT JOIN `room_category` ON `room_category`.`id_room_category` = `room`.`id_room_category`
  LEFT JOIN `hotel` ON `hotel`.`id_hotel` = `room`.`id_hotel`
WHERE 
  NOT ("2019-04-22" BETWEEN `room_in_booking`.`checkin_date` AND `room_in_booking`.`checkout_date`);

-- 4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров
SELECT 
  `hotel`.`name`,
  `room_category`.`name`,
  COUNT(`room_in_booking`.`id_room`)
FROM `client`
  LEFT JOIN         `booking` ON           `client`.`id_client` = `booking`.`id_client`
  LEFT JOIN `room_in_booking` ON `room_in_booking`.`id_booking` = `booking`.`id_booking`
  LEFT JOIN            `room` ON    `room_in_booking`.`id_room` = `room`.`id_room`
  LEFT JOIN   `room_category` ON      `room`.`id_room_category` = `room_category`.`id_room_category`
  LEFT JOIN           `hotel` ON              `room`.`id_hotel` = `hotel`.`id_hotel`
WHERE ("2019-03-23" BETWEEN `room_in_booking`.`checkin_date` AND `room_in_booking`.`checkout_date`)
  AND `hotel`.`name` = "Космос"
GROUP BY `room_category`.`name`;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, 
--    выехавшим в апреле с указанием даты выезда.
-- CREATE TEMPORARY TABLE IF NOT EXISTS `temp_table` AS (
--   SELECT `room_in_booking`.`id_room`, MAX(`room_in_booking`.`checkout_date`) AS `checkout`
--   FROM `room_in_booking`
--     LEFT JOIN `room` ON `room`.`id_room` = `room_in_booking`.`id_room` 
--     LEFT JOIN `hotel` ON `hotel`.`id_hotel` = `room`.`id_hotel`
--   WHERE `hotel`.`name` = "Космос" 
--     AND `room_in_booking`.`checkout_date` BETWEEN "2019-04-01" AND "2019-04-30"
--   GROUP BY `room_in_booking`.`id_room`
-- );

-- SELECT `client`.`name`, `client`.`id_client`, `temp_table`.`checkout`, `temp_table`.`id_room`
-- FROM `temp_table`
--   LEFT JOIN `room_in_booking` ON `temp_table`.`id_room` = `room_in_booking`.`id_room` AND `temp_table`.`checkout` = `room_in_booking`.`checkout_date`
--   LEFT JOIN `booking` ON `room_in_booking`.`id_booking` = `booking`.`id_booking`
--   LEFT JOIN `client` ON `booking`.`id_client` = `client`.`id_client`;
-- DROP TABLE `temp_table`;

SELECT DISTINCT `room_in_booking`.`id_room`, `room_in_booking`.`checkout_date`, `client`.`name`
FROM `room_in_booking`
  LEFT JOIN `booking` ON `booking`.`id_booking` = `room_in_booking`.`id_booking`
  LEFT JOIN `client` ON `client`.`id_client` = `booking`.`id_client`
  LEFT JOIN (
    SELECT `room_in_booking`.`id_room`, MAX(`room_in_booking`.`checkout_date`) AS `checkout` FROM `room_in_booking`
      LEFT JOIN `booking` ON `room_in_booking`.`id_booking` = `booking`.`id_booking`
      LEFT JOIN `client` ON `booking`.`id_client` = `client`.`id_client`
      LEFT JOIN `room` ON `room`.`id_room` = `room_in_booking`.`id_room` 
      LEFT JOIN `hotel` ON `hotel`.`id_hotel` = `room`.`id_hotel`
	WHERE `room_in_booking`.`checkout_date` BETWEEN "2019-04-01" AND "2019-05-01" AND `hotel`.`name` = "Космос"
    GROUP BY `room_in_booking`.`id_room`
  ) `temp` ON `temp`.`checkout` = `room_in_booking`.`checkout_date` AND `room_in_booking`.`id_room` = `temp`.`id_room`
ORDER BY `client`.`name`;

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, 
--    которые заселились 10мая.
UPDATE `room_in_booking`
  LEFT JOIN `room` ON `room`.`id_room` = `room_in_booking`.`id_room`
  LEFT JOIN `hotel` ON `room`.`id_hotel` = `hotel`.`id_hotel`
  LEFT JOIN `room_category` ON `room`.`id_room_category` = `room_category`.`id_room_category`
SET `room_in_booking`.`checkout_date` = DATE_ADD(`room_in_booking`.`checkout_date`, INTERVAL 2 DAY)
  WHERE `hotel`.`name` = "Космос" 
    AND `room_category`.`name` = "Бизнес"
    AND `room_in_booking`.`checkin_date` = "2019-05-10";
    
-- проверка
SELECT 
  `room_in_booking`.`checkin_date`, 
  `room_in_booking`.`checkout_date`,
  `hotel`.`name`,
  `room_category`.`name`
FROM `room_in_booking`
  LEFT JOIN `room` ON `room`.`id_room` = `room_in_booking`.`id_room`
  LEFT JOIN `hotel` ON `room`.`id_hotel` = `hotel`.`id_hotel`
  LEFT JOIN `room_category` ON `room`.`id_room_category` = `room_category`.`id_room_category`
WHERE `room_in_booking`.`checkin_date` = "2019-05-10" AND `room_category`.`name` = "Бизнес";

-- ? 
-- 7. Найти все "пересекающиеся" варианты проживания. 
--    Правильное состояние: не может быть забронированодин номер на одну дату несколько раз, 
--    т.к. нельзя заселиться нескольким клиентам в один номер
SELECT *
FROM `room_in_booking`
  LEFT JOIN `room_in_booking` `r_booking` ON `r_booking`.`id_room` = `room_in_booking`.`id_room`
    AND NOT `r_booking`.`id_room_in_booking` = `room_in_booking`.`id_room_in_booking`
WHERE `room_in_booking`.`checkout_date` > `r_booking`.`checkin_date`
  AND `room_in_booking`.`checkin_date` < `r_booking`.`checkin_date`;

SELECT *
FROM `room_in_booking`;

-- 8. Создать бронирование в транзакции
START TRANSACTION;
  SELECT @client_id := 5;
  INSERT INTO `booking` VALUES (NULL, @client_id, "2022-03-18");
  SELECT @booking_id := LAST_INSERT_ID();
  INSERT INTO `room_in_booking` VALUES (NULL, @booking_id, 9, "2022-04-12", "2022-04-25");
COMMIT;

-- 9. Добавить необходимые индексы для всех таблиц
-- Индексы уже присутствуют в таблицах
-- они были добавлены извне