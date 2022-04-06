-- 2. Выдать оценки студентов по информатике если они обучаются данному предмету. 
--    Оформить выдачу данных с использованием view
CREATE OR REPLACE VIEW `students_rating` AS
  SELECT 
    `student`.`name`,
    `mark`.`mark`
  FROM `mark`
    LEFT JOIN `student` ON `student`.`id_student` = `student`.`id_student`
    LEFT JOIN `lesson` ON `lesson`.`id_lesson` = `mark`.`id_lesson`
    LEFT JOIN `subject` ON `subject`.`id_subject` = `lesson`.`id_subject`
  WHERE `subject`.`name` = "Информатика" AND `mark`.`mark` IS NOT NULL;
  
SELECT * FROM `students_rating`;  
  
-- 3. Дать информацию о должниках с указанием фамилии студента и названия предмета. 
--    Должниками считаются студенты, не имеющие оценки по предмету, который ведется в группе. 
--    Оформить в виде процедуры, на входе идентификатор группы
DROP PROCEDURE IF EXISTS get_debtors;
DELIMITER  //
CREATE PROCEDURE get_debtors (IN `id` INT)
  BEGIN
    DROP TABLE IF EXISTS `group_lessons`;
    CREATE TEMPORARY TABLE `group_lessons` AS (
      SELECT 
        `student`.`id_student`, 
        `student`.`name` AS `student_name`, 
        `subject`.`name` AS `subject_name`, 
        `lesson`.`id_lesson` AS `id_lesson`
      FROM `lesson`
        LEFT JOIN `group` ON `group`.`id_group` = `lesson`.`id_group`
        LEFT JOIN `student` ON `student`.`id_group` = `group`.`id_group`
        LEFT JOIN `subject` ON `subject`.`id_subject` = `lesson`.`id_subject`
      WHERE `group`.`id_group` = `id`
    );
    
    SELECT DISTINCT
      `group_lessons`.`student_name`,
      `group_lessons`.`subject_name`
	FROM `group_lessons`
      LEFT JOIN `mark` ON `mark`.`id_lesson` = `group_lessons`.`id_lesson` 
        AND `mark`.`id_student` = `group_lessons`.`id_student`
	GROUP BY `group_lessons`.`student_name`
      HAVING COUNT(`mark`.`mark`) = 0;
  END //
DELIMITER ;

CALL get_debtors(3);

-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, 
--    по которым занимаетсяне менее 35 студентов
-- подумоть еще
SELECT 
  `student`.`name` AS `student`,
  `subject`.`name` AS `subject`,
  AVG(`mark`.`mark`) AS `average`
FROM `mark`
  LEFT JOIN `student` ON `student`.`id_student` = `mark`.`id_student`
  LEFT JOIN `lesson` ON `lesson`.`id_lesson` = `mark`.`id_lesson`
  LEFT JOIN `subject` ON `subject`.`id_subject` = `lesson`.`id_subject`
GROUP BY `subject`.`id_subject`
  HAVING COUNT(`student`.`id_student`) >= 35;

-- 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с указанием группы, фамилии, предмета, даты. 
--    При отсутствии оценки заполнить значениями NULL поля оценки
SELECT 
  `group`.`name` AS `group`,
  `student`.`name` AS `student`,
  `subject`.`name` AS `subject`,
  `lesson`.`date`,
  `mark`.`mark`
FROM `lesson`
  LEFT JOIN `subject` ON `subject`.`id_subject` = `lesson`.`id_subject`
  LEFT JOIN `group` ON `group`.`id_group` = `lesson`.`id_group`
  LEFT JOIN `student` ON `student`.`id_group` = `group`.`id_group`
  RIGHT JOIN `mark` ON `mark`.`id_student` = `student`.`id_student`
WHERE `group`.`name` = "ВМ";  
  
-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету БД до 12.05, 
--    повысить эти оценки на 1 балл.
UPDATE `mark`
  LEFT JOIN `lesson` ON `lesson`.`id_lesson` = `mark`.`id_lesson`
  LEFT JOIN `subject` ON `subject`.`id_subject` = `lesson`.`id_subject`
SET `mark`.`mark` = `mark`.`mark` + 1
  WHERE `subject`.`name` = "БД"
    AND `mark`.`mark` < 5 
    AND `lesson`.`date` <= "2019-05-12";
    