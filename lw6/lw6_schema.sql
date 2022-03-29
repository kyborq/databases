-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema umbrella
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema umbrella
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `umbrella` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `umbrella` ;

-- -----------------------------------------------------
-- Table `umbrella`.`company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `umbrella`.`company` (
  `id_company` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `established` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_company`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `umbrella`.`dealer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `umbrella`.`dealer` (
  `id_dealer` INT NOT NULL AUTO_INCREMENT,
  `id_company` INT NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_dealer`, `id_company`),
  INDEX `fk_dealer_company_idx` (`id_company` ASC) VISIBLE,
  CONSTRAINT `fk_dealer_company`
    FOREIGN KEY (`id_company`)
    REFERENCES `umbrella`.`company` (`id_company`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 86
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `umbrella`.`medicine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `umbrella`.`medicine` (
  `id_medicine` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `cure_duration` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_medicine`))
ENGINE = InnoDB
AUTO_INCREMENT = 22
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `umbrella`.`pharmacy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `umbrella`.`pharmacy` (
  `id_pharmacy` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `rating` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_pharmacy`))
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `umbrella`.`production`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `umbrella`.`production` (
  `id_production` INT NOT NULL AUTO_INCREMENT,
  `id_company` INT NOT NULL,
  `id_medicine` INT NOT NULL,
  `price` DOUBLE NULL DEFAULT NULL,
  `rating` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_production`, `id_medicine`, `id_company`),
  INDEX `fk_production_medicine1_idx` (`id_medicine` ASC) VISIBLE,
  INDEX `fk_production_company1_idx` (`id_company` ASC) VISIBLE,
  CONSTRAINT `fk_production_medicine1`
    FOREIGN KEY (`id_medicine`)
    REFERENCES `umbrella`.`medicine` (`id_medicine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_production_company1`
    FOREIGN KEY (`id_company`)
    REFERENCES `umbrella`.`company` (`id_company`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 169
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `umbrella`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `umbrella`.`order` (
  `id_order` INT NOT NULL AUTO_INCREMENT,
  `id_production` INT NOT NULL,
  `id_dealer` INT NOT NULL,
  `id_pharmacy` INT NOT NULL,
  `date` DATE NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_order`, `id_dealer`, `id_pharmacy`, `id_production`),
  INDEX `fk_order_dealer1_idx` (`id_dealer` ASC) VISIBLE,
  INDEX `fk_order_pharmacy1_idx` (`id_pharmacy` ASC) VISIBLE,
  INDEX `fk_order_production1_idx` (`id_production` ASC) VISIBLE,
  CONSTRAINT `fk_order_dealer1`
    FOREIGN KEY (`id_dealer`)
    REFERENCES `umbrella`.`dealer` (`id_dealer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_pharmacy1`
    FOREIGN KEY (`id_pharmacy`)
    REFERENCES `umbrella`.`pharmacy` (`id_pharmacy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_production1`
    FOREIGN KEY (`id_production`)
    REFERENCES `umbrella`.`production` (`id_production`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1000
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
