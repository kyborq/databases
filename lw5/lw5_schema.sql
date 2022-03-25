-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema hotels
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hotels
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hotels` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `hotels`;

-- -----------------------------------------------------
-- Table `hotels`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotels`.`client` (
  `id_client` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_client`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `hotels`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotels`.`booking` (
  `id_booking` INT NOT NULL AUTO_INCREMENT,
  `id_client` INT NOT NULL,
  `booking_date` DATE NULL,
  PRIMARY KEY (`id_booking`, `id_client`),
  INDEX `fk_booking_client_idx` (`id_client` ASC) INVISIBLE,
  CONSTRAINT `fk_booking_client`
    FOREIGN KEY (`id_client`)
    REFERENCES `hotels`.`client` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `hotels`.`hotel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotels`.`hotel` (
  `id_hotel` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `stars` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_hotel`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `hotels`.`room_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotels`.`room_category` (
  `id_room_category` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `square` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_room_category`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `hotels`.`room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotels`.`room` (
  `id_room` INT NOT NULL AUTO_INCREMENT,
  `id_hotel` INT NOT NULL,
  `id_room_category` INT NOT NULL,
  `number` INT NULL,
  `price` DOUBLE NULL,
  PRIMARY KEY (`id_room`, `id_room_category`, `id_hotel`),
  INDEX `fk_room_category_idx` (`id_room_category` ASC) VISIBLE,
  INDEX `fk_room_hotel_idx` (`id_hotel` ASC) VISIBLE,
  CONSTRAINT `fk_room_category`
    FOREIGN KEY (`id_room_category`)
    REFERENCES `hotels`.`room_category` (`id_room_category`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_room_hotel`
    FOREIGN KEY (`id_hotel`)
    REFERENCES `hotels`.`hotel` (`id_hotel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `hotels`.`room_in_booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hotels`.`room_in_booking` (
  `id_room_in_booking` INT NOT NULL,
  `id_booking` INT NOT NULL,
  `id_room` INT NOT NULL,
  `checkin_date` DATE NULL,
  `checkout_date` DATE NULL,
  PRIMARY KEY (`id_room_in_booking`, `id_room`, `id_booking`),
  INDEX `fk_booking_room_idx` (`id_room` ASC) VISIBLE,
  INDEX `fk_booking_idx` (`id_booking` ASC) VISIBLE,
  CONSTRAINT `fk_booking_room`
    FOREIGN KEY (`id_room`)
    REFERENCES `hotels`.`room` (`id_room`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_booking`
    FOREIGN KEY (`id_booking`)
    REFERENCES `hotels`.`booking` (`id_booking`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
