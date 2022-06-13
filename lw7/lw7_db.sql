-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema students
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema students
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `students` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `students` ;

-- -----------------------------------------------------
-- Table `students`.`group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students`.`group` (
  `id_group` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_group`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `students`.`subject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students`.`subject` (
  `id_subject` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_subject`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `students`.`teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students`.`teacher` (
  `id_teacher` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_teacher`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `students`.`lesson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students`.`lesson` (
  `id_lesson` INT NOT NULL AUTO_INCREMENT,
  `id_teacher` INT NOT NULL,
  `id_subject` INT NOT NULL,
  `id_group` INT NOT NULL,
  `date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id_lesson`, `id_subject`, `id_teacher`, `id_group`),
  CONSTRAINT `fk_lesson_subject1`
    FOREIGN KEY (`id_subject`)
    REFERENCES `students`.`subject` (`id_subject`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lesson_teacher1`
    FOREIGN KEY (`id_teacher`)
    REFERENCES `students`.`teacher` (`id_teacher`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lesson_group1`
    FOREIGN KEY (`id_group`)
    REFERENCES `students`.`group` (`id_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 297
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_lesson_subject1_idx` ON `students`.`lesson` (`id_subject` ASC) VISIBLE;

CREATE INDEX `fk_lesson_teacher1_idx` ON `students`.`lesson` (`id_teacher` ASC) VISIBLE;

CREATE INDEX `fk_lesson_group1_idx` ON `students`.`lesson` (`id_group` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `students`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students`.`student` (
  `id_student` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  `id_group` INT NOT NULL,
  PRIMARY KEY (`id_student`, `id_group`),
  CONSTRAINT `fk_student_group`
    FOREIGN KEY (`id_group`)
    REFERENCES `students`.`group` (`id_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 78
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_student_group_idx` ON `students`.`student` (`id_group` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `students`.`mark`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `students`.`mark` (
  `id_mark` INT NOT NULL AUTO_INCREMENT,
  `id_lesson` INT NOT NULL,
  `id_student` INT NOT NULL,
  `mark` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_mark`, `id_student`, `id_lesson`),
  CONSTRAINT `fk_mark_student1`
    FOREIGN KEY (`id_student`)
    REFERENCES `students`.`student` (`id_student`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mark_lesson1`
    FOREIGN KEY (`id_lesson`)
    REFERENCES `students`.`lesson` (`id_lesson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 5997
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `fk_mark_student1_idx` ON `students`.`mark` (`id_student` ASC) VISIBLE;

CREATE INDEX `fk_mark_lesson1_idx` ON `students`.`mark` (`id_lesson` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
