SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `car_rental` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;

USE `car_rental`;

CREATE  TABLE IF NOT EXISTS `car_rental`.`User` (
  `idUser` INT(11) NOT NULL AUTO_INCREMENT ,
  `idDocumentType` INT(11) NOT NULL ,
  `firstName` VARCHAR(45) NOT NULL ,
  `lastName` VARCHAR(45) NOT NULL ,
  `address` VARCHAR(254) NOT NULL ,
  `phone` VARCHAR(45) NOT NULL ,
  `email` VARCHAR(50) NOT NULL ,
  `password` VARCHAR(45) NOT NULL ,
  `state` INT(11) NOT NULL ,
  `wrongPassword` INT(11) NOT NULL ,
  `documentNumber` VARCHAR(45) NOT NULL ,
  `idRol` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`idUser`) ,
  INDEX `fk_User_Rol1` (`idRol` ASC) ,
  INDEX `fk_User_DocumentType1` (`idDocumentType` ASC) ,
  CONSTRAINT `fk_User_Rol1`
    FOREIGN KEY (`idRol` )
    REFERENCES `car_rental`.`Rol` (`idRol` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_DocumentType1`
    FOREIGN KEY (`idDocumentType` )
    REFERENCES `car_rental`.`DocumentType` (`idDocumentType` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`DocumentType` (
  `idDocumentType` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idDocumentType`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Brand` (
  `idBrand` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idBrand`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Model` (
  `idModel` INT(11) NOT NULL ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idModel`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Car` (
  `idCar` INT(11) NOT NULL ,
  `idBrand` INT(11) NOT NULL ,
  `idModel` INT(11) NOT NULL ,
  `idStatus` INT(11) NULL DEFAULT NULL ,
  `image` LONGBLOB NULL DEFAULT NULL ,
  `privePerHour` DECIMAL NULL DEFAULT NULL ,
  PRIMARY KEY (`idCar`) ,
  INDEX `fk_Car_Brand1` (`idBrand` ASC) ,
  INDEX `fk_Car_Model1` (`idModel` ASC) ,
  INDEX `fk_Car_Status1` (`idStatus` ASC) ,
  CONSTRAINT `fk_Car_Brand1`
    FOREIGN KEY (`idBrand` )
    REFERENCES `car_rental`.`Brand` (`idBrand` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Car_Model1`
    FOREIGN KEY (`idModel` )
    REFERENCES `car_rental`.`Model` (`idModel` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Car_Status1`
    FOREIGN KEY (`idStatus` )
    REFERENCES `car_rental`.`Status` (`idStatus` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Status` (
  `idStatus` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idStatus`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Reserve` (
  `idReserve` INT(11) NOT NULL AUTO_INCREMENT ,
  `idUser` INT(11) NOT NULL ,
  `idCar` INT(11) NOT NULL ,
  `startDate` TIMESTAMP NOT NULL ,
  `endDate` TIMESTAMP NOT NULL ,
  `state` INT(11) NOT NULL ,
  `totalHours` INT(11) NOT NULL ,
  `dateReject` TIMESTAMP NULL DEFAULT NULL ,
  PRIMARY KEY (`idReserve`, `idCar`, `idUser`) ,
  INDEX `fk_Reserve_User` (`idUser` ASC) ,
  INDEX `fk_Reserve_Car1` (`idCar` ASC) ,
  CONSTRAINT `fk_Reserve_User`
    FOREIGN KEY (`idUser` )
    REFERENCES `car_rental`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reserve_Car1`
    FOREIGN KEY (`idCar` )
    REFERENCES `car_rental`.`Car` (`idCar` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Rental` (
  `Reserve_idCar` INT(11) NOT NULL ,
  `Reserve_idUser` INT(11) NOT NULL ,
  `Reserve_idReserve` INT(11) NOT NULL ,
  `state` INT(11) NULL DEFAULT NULL ,
  `totalCost` DECIMAL NULL DEFAULT NULL ,
  PRIMARY KEY (`Reserve_idReserve`, `Reserve_idCar`, `Reserve_idUser`) ,
  INDEX `fk_Rental_Reserve1` (`Reserve_idReserve` ASC, `Reserve_idCar` ASC, `Reserve_idUser` ASC) ,
  CONSTRAINT `fk_Rental_Reserve1`
    FOREIGN KEY (`Reserve_idReserve` , `Reserve_idCar` , `Reserve_idUser` )
    REFERENCES `car_rental`.`Reserve` (`idReserve` , `idCar` , `idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Devolution` (
  `costOutDate` DECIMAL NOT NULL ,
  `dateDevolution` TIMESTAMP NOT NULL ,
  `outHours` INT(11) NOT NULL ,
  `idAdmin` INT(11) NULL DEFAULT NULL ,
  `Rental_Reserve_idReserve` INT(11) NOT NULL ,
  `Rental_Reserve_idCar` INT(11) NOT NULL ,
  `Rental_Reserve_idUser` INT(11) NOT NULL ,
  INDEX `fk_Devolution_User1` (`idAdmin` ASC) ,
  PRIMARY KEY (`Rental_Reserve_idReserve`, `Rental_Reserve_idCar`, `Rental_Reserve_idUser`) ,
  INDEX `fk_Devolution_Rental1` (`Rental_Reserve_idReserve` ASC, `Rental_Reserve_idCar` ASC, `Rental_Reserve_idUser` ASC) ,
  CONSTRAINT `fk_Devolution_User1`
    FOREIGN KEY (`idAdmin` )
    REFERENCES `car_rental`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Devolution_Rental1`
    FOREIGN KEY (`Rental_Reserve_idReserve` , `Rental_Reserve_idCar` , `Rental_Reserve_idUser` )
    REFERENCES `car_rental`.`Rental` (`Reserve_idReserve` , `Reserve_idCar` , `Reserve_idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

CREATE  TABLE IF NOT EXISTS `car_rental`.`Rol` (
  `idRol` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`idRol`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;

DROP SCHEMA IF EXISTS `information_schema` ;

DROP TABLE IF EXISTS `information_schema`.`CHARACTER_SETS` ;

DROP TABLE IF EXISTS `information_schema`.`COLLATIONS` ;

DROP TABLE IF EXISTS `information_schema`.`COLLATION_CHARACTER_SET_APPLICABILITY` ;

DROP TABLE IF EXISTS `information_schema`.`COLUMNS` ;

DROP TABLE IF EXISTS `information_schema`.`COLUMN_PRIVILEGES` ;

DROP TABLE IF EXISTS `information_schema`.`KEY_COLUMN_USAGE` ;

DROP TABLE IF EXISTS `information_schema`.`ROUTINES` ;

DROP TABLE IF EXISTS `information_schema`.`SCHEMATA` ;

DROP TABLE IF EXISTS `information_schema`.`SCHEMA_PRIVILEGES` ;

DROP TABLE IF EXISTS `information_schema`.`STATISTICS` ;

DROP TABLE IF EXISTS `information_schema`.`TABLES` ;

DROP TABLE IF EXISTS `information_schema`.`TABLE_CONSTRAINTS` ;

DROP TABLE IF EXISTS `information_schema`.`TABLE_PRIVILEGES` ;

DROP TABLE IF EXISTS `information_schema`.`TRIGGERS` ;

DROP TABLE IF EXISTS `information_schema`.`USER_PRIVILEGES` ;

DROP TABLE IF EXISTS `information_schema`.`VIEWS` ;

DROP SCHEMA IF EXISTS `mysql` ;

DROP TABLE IF EXISTS `mysql`.`columns_priv` ;

DROP TABLE IF EXISTS `mysql`.`db` ;

DROP TABLE IF EXISTS `mysql`.`func` ;

DROP TABLE IF EXISTS `mysql`.`help_category` ;

DROP TABLE IF EXISTS `mysql`.`help_keyword` ;

DROP TABLE IF EXISTS `mysql`.`help_relation` ;

DROP TABLE IF EXISTS `mysql`.`help_topic` ;

DROP TABLE IF EXISTS `mysql`.`host` ;

DROP TABLE IF EXISTS `mysql`.`proc` ;

DROP TABLE IF EXISTS `mysql`.`procs_priv` ;

DROP TABLE IF EXISTS `mysql`.`tables_priv` ;

DROP TABLE IF EXISTS `mysql`.`time_zone` ;

DROP TABLE IF EXISTS `mysql`.`time_zone_leap_second` ;

DROP TABLE IF EXISTS `mysql`.`time_zone_name` ;

DROP TABLE IF EXISTS `mysql`.`time_zone_transition` ;

DROP TABLE IF EXISTS `mysql`.`user` ;

DROP SCHEMA IF EXISTS `test` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
