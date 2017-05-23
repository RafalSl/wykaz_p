-- MySQL Script generated by MySQL Workbench
-- Sun May 14 17:50:40 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema wykaz_p
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema wykaz_p
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `wykaz_p` DEFAULT CHARACTER SET utf8 COLLATE utf8_polish_ci ;
USE `wykaz_p` ;

-- -----------------------------------------------------
-- Table `wykaz_p`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(16) NOT NULL,
  `email` VARCHAR(256) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uprawnienia` VARCHAR(3) NOT NULL DEFAULT '011',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`wspinacz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`wspinacz` (
  `wspinacz_id` INT NOT NULL AUTO_INCREMENT,
  `imie` VARCHAR(30) NOT NULL,
  `nazwisko` VARCHAR(30) NOT NULL,
  `ksywa` VARCHAR(30) NULL,
  `data_ur` DATE NULL,
  `plec` ENUM('M', 'K') NOT NULL DEFAULT 'M',
  `kraj` VARCHAR(20) NULL,
  `miasto` VARCHAR(45) NULL,
  `wzrost` INT NULL,
  `waga` INT NULL,
  `od_kiedy` DATE NULL,
  UNIQUE INDEX `user_id_UNIQUE` (`wspinacz_id` ASC),
  PRIMARY KEY (`wspinacz_id`),
  CONSTRAINT `fk_wspinacz_user1`
    FOREIGN KEY (`wspinacz_id`)
    REFERENCES `wykaz_p`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`kraj`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`kraj` (
  `kraj_id` INT NOT NULL AUTO_INCREMENT,
  `nazwa_kraju` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`kraj_id`),
  UNIQUE INDEX `kraj_id_UNIQUE` (`kraj_id` ASC),
  UNIQUE INDEX `kraj_UNIQUE` (`nazwa_kraju` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`rejon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`rejon` (
  `rejon_id` INT NOT NULL AUTO_INCREMENT,
  `kraj_id` INT NOT NULL,
  `nazwa_rejonu` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`rejon_id`, `kraj_id`),
  UNIQUE INDEX `kraj_id_UNIQUE` (`kraj_id` ASC),
  UNIQUE INDEX `rejon_UNIQUE` (`nazwa_rejonu` ASC),
  UNIQUE INDEX `rejon_id_UNIQUE` (`rejon_id` ASC),
  CONSTRAINT `fk_rejon_kraj1`
    FOREIGN KEY (`kraj_id`)
    REFERENCES `wykaz_p`.`kraj` (`kraj_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`dolina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`dolina` (
  `dolina_id` INT NOT NULL AUTO_INCREMENT,
  `rejon_id` INT NOT NULL,
  `nazwa_doliny` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`dolina_id`, `rejon_id`),
  UNIQUE INDEX `rejon_id_UNIQUE` (`rejon_id` ASC),
  UNIQUE INDEX `dolina_UNIQUE` (`nazwa_doliny` ASC),
  UNIQUE INDEX `dolina_id_UNIQUE` (`dolina_id` ASC),
  CONSTRAINT `fk_dolina_rejon1`
    FOREIGN KEY (`rejon_id`)
    REFERENCES `wykaz_p`.`rejon` (`rejon_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`formacja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`formacja` (
  `formacja_id` INT NOT NULL AUTO_INCREMENT,
  `dolina_id` INT NOT NULL,
  `nazawa_formacji` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`formacja_id`, `dolina_id`),
  UNIQUE INDEX `dolina_id_UNIQUE` (`dolina_id` ASC),
  UNIQUE INDEX `formacja_UNIQUE` (`nazawa_formacji` ASC),
  UNIQUE INDEX `formacja_id_UNIQUE` (`formacja_id` ASC),
  CONSTRAINT `fk_formacja_dolina1`
    FOREIGN KEY (`dolina_id`)
    REFERENCES `wykaz_p`.`dolina` (`dolina_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`droga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`droga` (
  `droga_id` INT NOT NULL AUTO_INCREMENT,
  `formacja_id` INT NOT NULL,
  `nazwa_drogi` VARCHAR(45) NOT NULL,
  `wycena` DOUBLE NOT NULL,
  `skala` ENUM('uiaa', 'fr', 'kurtyki', 'usa') NULL DEFAULT 'kurtyki',
  `trad` TINYINT NOT NULL DEFAULT 0,
  `l_przejsc` INT NULL DEFAULT 0,
  PRIMARY KEY (`droga_id`, `formacja_id`),
  UNIQUE INDEX `formacja_id_UNIQUE` (`formacja_id` ASC),
  UNIQUE INDEX `droga_id_UNIQUE` (`droga_id` ASC),
  CONSTRAINT `fk_droga_formacja1`
    FOREIGN KEY (`formacja_id`)
    REFERENCES `wykaz_p`.`formacja` (`formacja_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`przejscia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`przejscia` (
  `wspinacz_id` INT NOT NULL,
  `droga_id` INT NOT NULL,
  `styl` ENUM('OS', 'FL', 'RP', 'PP', 'TR', 'RK', 'AF', 'Solo', 'Free_Solo') NULL,
  `data_p` DATE NULL,
  `ocena` ENUM('1', '2', '3', '4', '5') NULL,
  `komentarz` TEXT NULL,
  `waga_p` INT NULL,
  INDEX `fk_droga_has_wspinacz_wspinacz1_idx` (`wspinacz_id` ASC),
  INDEX `fk_droga_has_wspinacz_droga1_idx` (`droga_id` ASC),
  CONSTRAINT `fk_droga_has_wspinacz_droga1`
    FOREIGN KEY (`droga_id`)
    REFERENCES `wykaz_p`.`droga` (`droga_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_droga_has_wspinacz_wspinacz1`
    FOREIGN KEY (`wspinacz_id`)
    REFERENCES `wykaz_p`.`wspinacz` (`wspinacz_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`wyceny`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`wyceny` (
  `wycena` DOUBLE NOT NULL,
  `uiaa` VARCHAR(5) NOT NULL,
  `fr` VARCHAR(5) NOT NULL,
  `kurtyki` VARCHAR(5) NOT NULL,
  `usa` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`wycena`),
  UNIQUE INDEX `wycena_UNIQUE` (`wycena` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`schematy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`schematy` (
  `droga_id` INT NOT NULL,
  `schemat` VARCHAR(45) NULL,
  PRIMARY KEY (`droga_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`miasto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`miasto` (
  `miasto_id` INT NOT NULL AUTO_INCREMENT,
  `kraj_id` INT NOT NULL,
  `nazwa_miasta` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`miasto_id`, `kraj_id`),
  INDEX `kraj_idx` (`kraj_id` ASC),
  CONSTRAINT `fk_kraj_p`
    FOREIGN KEY (`kraj_id`)
    REFERENCES `wykaz_p`.`kraj` (`kraj_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`sciana`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`sciana` (
  `sciana_id` INT NOT NULL AUTO_INCREMENT,
  `miasto_id` INT NOT NULL,
  `nazwa_sciany` VARCHAR(25) NULL,
  UNIQUE INDEX `sciana_id_UNIQUE` (`sciana_id` ASC),
  PRIMARY KEY (`sciana_id`, `miasto_id`),
  INDEX `miasto_idx` (`miasto_id` ASC),
  CONSTRAINT `fk_miasto`
    FOREIGN KEY (`miasto_id`)
    REFERENCES `wykaz_p`.`miasto` (`miasto_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`droga_p`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`droga_p` (
  `droga_p_id` INT NOT NULL AUTO_INCREMENT,
  `sciana_id` INT NOT NULL,
  `nazwa_drogi_p` VARCHAR(45) NOT NULL,
  `wycena_p` DOUBLE NOT NULL,
  `skala_p` ENUM('uiaa', 'fr', 'kurtyki', 'usa') NOT NULL DEFAULT 'fr',
  `l_przejsc_p` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`droga_p_id`, `sciana_id`),
  INDEX `sciana_idx` (`sciana_id` ASC),
  INDEX `fk_droga_p_wyceny1_idx` (`wycena_p` ASC),
  CONSTRAINT `fk_sciana`
    FOREIGN KEY (`sciana_id`)
    REFERENCES `wykaz_p`.`sciana` (`sciana_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_droga_p_wyceny1`
    FOREIGN KEY (`wycena_p`)
    REFERENCES `wykaz_p`.`wyceny` (`wycena`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wykaz_p`.`przejscia_p`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wykaz_p`.`przejscia_p` (
  `wspinacz_id_p` INT NOT NULL,
  `data_pp` DATE NULL,
  `droga_p_id` INT NOT NULL,
  `styl` ENUM('OS', 'FL', 'RP', 'PP', 'TR', 'RK', 'AF', 'Solo', 'Free_Solo') NULL,
  `ocena_p` ENUM('1', '2', '3', '4', '5') NULL,
  `komentarz_p` TEXT NULL,
  `waga_pp` INT NULL,
  INDEX `fk_droga_has_wspinacz_wspinacz1_idx` (`wspinacz_id_p` ASC),
  INDEX `fk_droga_p_idx` (`droga_p_id` ASC),
  CONSTRAINT `fk_droga_p`
    FOREIGN KEY (`droga_p_id`)
    REFERENCES `wykaz_p`.`droga_p` (`droga_p_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_wspinacz_p`
    FOREIGN KEY (`wspinacz_id_p`)
    REFERENCES `wykaz_p`.`wspinacz` (`wspinacz_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `wykaz_p` ;

-- -----------------------------------------------------
--  routine1
-- -----------------------------------------------------

DELIMITER $$
USE `wykaz_p`$$
$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `wykaz_p`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`user` (`user_id`, `username`, `email`, `password`, `create_time`, `uprawnienia`) VALUES (1, 'rafal', 'rafal_slomka@poczta.onet.pl', 'abc111', '2016-08-21', '011');
INSERT INTO `wykaz_p`.`user` (`user_id`, `username`, `email`, `password`, `create_time`, `uprawnienia`) VALUES (2, 'tester', 'aaa@b.pl', 'abc', '2016-01-01', '011');
INSERT INTO `wykaz_p`.`user` (`user_id`, `username`, `email`, `password`, `create_time`, `uprawnienia`) VALUES (3, 'tester2', 'bbb@b.pl', 'abc', '2016-01-01', '011');

delete from user;

COMMIT;


-- -----------------------------------------------------
-- Data for table `wykaz_p`.`wspinacz`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`wspinacz` (`wspinacz_id`, `imie`, `nazwisko`, `ksywa`, `data_ur`, `plec`, `kraj`, `miasto`, `wzrost`, `waga`, `od_kiedy`) VALUES (1, 'Rafał', 'Słomka', 'Rafał', '1984-08-21', 'M', 'Polska', 'Warszawa', 188, 75, '2009-05-01');
INSERT INTO `wykaz_p`.`wspinacz` (`wspinacz_id`, `imie`, `nazwisko`, `ksywa`, `data_ur`, `plec`, `kraj`, `miasto`, `wzrost`, `waga`, `od_kiedy`) VALUES (2, 'Testerka', 'Nazwisko_t', 'Testereczka', '1990-07-22', 'K', 'Polska', 'Kraków', 168, 66, '2008-01-01');
INSERT INTO `wykaz_p`.`wspinacz` (`wspinacz_id`, `imie`, `nazwisko`, `ksywa`, `data_ur`, `plec`, `kraj`, `miasto`, `wzrost`, `waga`, `od_kiedy`) VALUES (3, 'Tester', 'Nazwisko_t', 'Testerek', '1980-12-12', 'M', 'Niemcy', 'Berlin', 175, 71, '2016-01-01');

COMMIT;


-- -----------------------------------------------------
-- Data for table `wykaz_p`.`kraj`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`kraj` (`kraj_id`, `nazwa_kraju`) VALUES (1, 'Polska');
INSERT INTO `wykaz_p`.`kraj` (`kraj_id`, `nazwa_kraju`) VALUES (2, 'Niemcy');

COMMIT;


-- -----------------------------------------------------
-- Data for table `wykaz_p`.`wyceny`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (1, 'I', '1', 'I', '5.1');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (2, 'II', '2', 'II', '5.2');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (3, 'II+', '2+', 'II+', '5.2');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (4, 'III', '3', 'III', '5.3');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (5, 'IV', '4a', 'IV', '5.4');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (6, 'IV', '4b', 'IV', '5.4');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (7, 'IV+', '4c', 'IV+', '5.5');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (8, 'V-', '5a', 'V-', '5.5');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (9, 'V', '5b', 'V', '5.6');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (10, 'V+', '5c', 'V+', '5.7');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (11, 'VI-', '5c', 'VI-', '5.8');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (12, 'VI', '6a', 'VI', '5.9');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (13, 'VI+', '6a+', 'VI+', '5.10a');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (14, 'VII-', '6b', 'VI.1', '5.10b');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (15, 'VII', '6b+', 'VI.1+', '5.10c');
INSERT INTO `wykaz_p`.`wyceny` (`wycena`, `uiaa`, `fr`, `kurtyki`, `usa`) VALUES (16, 'VII+', '6c', 'VI.2', '5.10d');

COMMIT;


-- -----------------------------------------------------
-- Data for table `wykaz_p`.`miasto`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`miasto` (`miasto_id`, `kraj_id`, `nazwa_miasta`) VALUES (1, 1, 'Warszawa');
INSERT INTO `wykaz_p`.`miasto` (`miasto_id`, `kraj_id`, `nazwa_miasta`) VALUES (2, 1, 'Kraków');
INSERT INTO `wykaz_p`.`miasto` (`miasto_id`, `kraj_id`, `nazwa_miasta`) VALUES (3, 2, 'Berlin');

COMMIT;


-- -----------------------------------------------------
-- Data for table `wykaz_p`.`sciana`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (1, 1, 'Makak');
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (2, 1, 'Murall');
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (3, 1, 'Warszawianka');
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (4, 1, 'Nowowiejska \"W pionie\"');
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (5, 2, 'Avatar');
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (6, 3, 'DAV');
INSERT INTO `wykaz_p`.`sciana` (`sciana_id`, `miasto_id`, `nazwa_sciany`) VALUES (7, 3, 'Magic Mountain');

COMMIT;


-- -----------------------------------------------------
-- Data for table `wykaz_p`.`droga_p`
-- -----------------------------------------------------
START TRANSACTION;
USE `wykaz_p`;
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (1, 1, 'Paczkomat', 13, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (2, 1, 'zielona 5b na pochyłej', 9, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (3, 1, 'żółta 5a na poczyłej', 8, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (4, 1, 'Świat jest WF-em', 9, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (5, 1, 'czerwona 5b na brzuszkach', 9, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (6, 6, 'w połogu 7-', 14, 'uiaa', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (7, 5, 't1', 16, 'kurtyki', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (8, 5, 't2', 14, 'kurtyki', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (9, 4, 't3', 10, 'kurtyki', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (10, 2, 't4', 8, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (11, 2, 't5', 10, 'fr', 0);
INSERT INTO `wykaz_p`.`droga_p` (`droga_p_id`, `sciana_id`, `nazwa_drogi_p`, `wycena_p`, `skala_p`, `l_przejsc_p`) VALUES (12, 2, 't6', 15, 'fr', 0);

COMMIT;

USE `wykaz_p`;
drop trigger `wykaz_p`.`przejscia_p_AFTER_INSERT`;

DELIMITER $$
USE `wykaz_p`$$
CREATE DEFINER = CURRENT_USER TRIGGER `wykaz_p`.`przejscia_p_AFTER_INSERT` AFTER INSERT ON `przejscia_p` FOR EACH ROW
BEGIN
update droga_p, przejscia_p set droga_p.l_przejsc_p = droga_p.l_przejsc_p + 1 where droga_p.droga_p_id = new.droga_p_id;
END$$

/*TEN TRIGGER NIE DZIAŁA I NIE WIEM, CZY W OGÓLE MOŻNA WYKONAĆ TĘ OPERACJĘ W TEN SPOSÓB - wpisywanie wagi w do nowego przejścia w przejscia_p, jeśli nie została podana, na podstawie wagi z tabeli wspinacz
CREATE DEFINER = CURRENT_USER TRIGGER `wykaz_p`.`przejscia_p_before_INSERT` before INSERT ON `przejscia_p` FOR EACH ROW
BEGIN
set @auto_waga = (select distinct wspinacz.waga from wspinacz, przejscia_p where wspinacz.wspinacz_id = new.wspinacz_id_p);
update przejscia_p set new.waga_pp = @auto_waga;
END$$
*/
DELIMITER ;

#Wspinacz id = 1
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-05-06', 1, 'AF', '4', '3 bloki', 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-05-09', 1, 'AF', '4', '3 bloki', 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-04-06', 11, 'OS', '3', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-04-21', 9, 'OS', '5', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-04-15', 12, 'OS', '3', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-04-06', 3, 'OS', '3', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-02-16', 2, 'OS', '3', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-02-16', 5, 'OS', '3', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-02-18', 5, 'OS', '2', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-02-18', 6, 'OS', '4', null, 75);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-01-02', 8, 'OS', '1', null, 77);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-01-02', 6, 'OS', '4', null, 77);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (1, '2017-01-09', 4, 'OS', '2', null, 77);
#Wspinacz id = 2
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-09', 11, 'OS', '3', null, 60);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-09', 10, 'OS', '5', null, 60);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-18', 3, 'OS', '4', null, 60);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-18', 4, 'OS', '3', null, 60);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-22', 4, 'OS', '3', null, 61);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-22', 3, 'OS', '2', null, 61);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-01-22', 5, 'OS', '5', null, 61);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-01', 7, 'OS', '3', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-01', 8, 'OS', '4', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-01', 9, 'OS', '5', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-10', 7, 'OS', '3', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-10', 3, 'OS', '1', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-20', 1, 'OS', '3', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-10', 2, 'OS', '5', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-03-10', 4, 'OS', '4', null, 65);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-01', 1, 'OS', '3', null, 66);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-01', 11, 'OS', '5', null, 66);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-01', 12, 'OS', '4', null, 66);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-05', 12, 'OS', '4', null, 66);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-15', 9, 'OS', '5', null, 66);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-15', 1, 'OS', '5', null, 66);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (2, '2017-04-15', 3, 'OS', '4', null, 66);
#Wspinacz id = 3
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-01-09', 1, 'OS', '3', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-01-09', 2, 'OS', '3', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-01-09', 4, 'OS', '3', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-01-09', 3, 'OS', '3', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-01-09', 5, 'OS', '3', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-01-09', 6, 'OS', '5', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 7, 'OS', '2', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 8, 'OS', '5', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 9, 'OS', '4', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 7, 'OS', '2', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 10, 'OS', '5', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 11, 'OS', '4', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-02-09', 12, 'OS', '2', null, 71);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 12, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 11, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 10, 'OS', '5', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 9, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 8, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 7, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-03-09', 6, 'OS', '5', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 5, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 4, 'OS', '1', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 3, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 2, 'OS', '5', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 1, 'OS', '4', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 5, 'OS', '2', null, 70);
INSERT INTO `wykaz_p`.`przejscia_p` (`wspinacz_id_p`, `data_pp`, `droga_p_id`, `styl`, `ocena_p`, `komentarz_p`, `waga_pp`) VALUES (3, '2017-04-09', 12, 'OS', '2', null, 70);

update wspinacz set nazwisko = 'Kowalski' where wspinacz_id = 3;
update wspinacz set imie = 'Jan' where wspinacz_id = 3;

#Wszystkie przejścia wszystkich wspinaczy posortowane po dacie - wyświetlanie wybranych kolumn z różnych tabel
select przejscia_p.data_pp as 'Data przejścia', droga_p.nazwa_drogi_p as 'Droga', droga_p.wycena_p as 'Wycena', sciana.nazwa_sciany as 'Ściana', kraj.nazwa_kraju as 'Kraj' from przejscia_p 
natural left join droga_p
natural left join sciana
natural left join miasto
natural left join kraj
order by przejscia_p.data_pp;

#Wszystkie przejścia wszystkich wspinaczy posortowane po dacie i nazwiskach wspinaczy
select wspinacz.imie, wspinacz.nazwisko, przejscia_p.data_pp as 'Data przejścia', droga_p.nazwa_drogi_p as 'Droga', droga_p.wycena_p as 'Wycena', sciana.nazwa_sciany as 'Ściana', kraj.nazwa_kraju as 'Kraj'
from przejscia_p 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
natural left join droga_p
natural left join sciana
natural left join miasto
natural left join kraj
order by wspinacz.nazwisko, przejscia_p.data_pp desc;

#Wszystkie przejścia wybranego wspinacza
select wspinacz.imie, wspinacz.nazwisko, przejscia_p.data_pp as 'Data przejścia', droga_p.nazwa_drogi_p as 'Droga', droga_p.wycena_p as 'Wycena', sciana.nazwa_sciany as 'Ściana', kraj.nazwa_kraju as 'Kraj' from przejscia_p 
natural left join droga_p
natural left join sciana
natural left join miasto
natural left join kraj
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where przejscia_p.wspinacz_id_p = 1 
order by przejscia_p.data_pp;

#Najlepsze przejście wybranego wspinacza - nie potrafię przyporządkować nazwy drogi i innych jej atrybutów do maksa
select wspinacz.imie, wspinacz.nazwisko, max(droga_p.wycena_p) as 'Personal best' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where przejscia_p.wspinacz_id_p = 1;

#inna próba tego samego, która też nie działa
select wspinacz.imie, wspinacz.nazwisko, przejscia_p.data_pp as 'Data przejścia', droga_p.nazwa_drogi_p as 'Droga', droga_p.wycena_p as 'Wycena', sciana.nazwa_sciany as 'Ściana', kraj.nazwa_kraju as 'Kraj' from przejscia_p 
left join droga_p on przejscia_p.droga_p_id = droga_p.droga_p_id
left join sciana on droga_p.sciana_id = sciana.sciana_id
left join miasto on sciana.miasto_id = miasto.miasto_id
natural left join kraj
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where przejscia_p.wspinacz_id_p = 1 
order by przejscia_p.data_pp;


#Najlepsze przejścia poszczególnych wspinaczy - też niepełne
select wspinacz.imie, wspinacz.nazwisko, max(droga_p.wycena_p) as 'Personal best' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
group by przejscia_p.wspinacz_id_p;
#To nie działa
select wspinacz.wspinacz_id, wspinacz.imie, wspinacz.nazwisko, droga_p.nazwa_drogi_p as 'Droga', max(droga_p.wycena_p) as 'Wycena', sciana.nazwa_sciany as 'Ściana', kraj.nazwa_kraju as 'Kraj' 
from przejscia_p
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
left join droga_p on droga_p.droga_p_id = przejscia_p.droga_p_id
natural left join sciana
natural left join miasto
natural left join kraj
group by wspinacz.wspinacz_id;

#Średnia trudność dróg, jakie przeszedł dany wspinacz
select wspinacz.imie, wspinacz.nazwisko, round(avg(droga_p.wycena_p)) as 'Średnia wycena' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where przejscia_p.wspinacz_id_p = 3;

#Średnia trudność dróg, jakie przeszedł dany wspinacz w ciągu ostatnich 30 dni
select wspinacz.imie, wspinacz.nazwisko, round(avg(droga_p.wycena_p)) as 'Średnia wycena' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where 
przejscia_p.wspinacz_id_p = 1 and
przejscia_p.data_pp >= (date_sub(curdate(), interval 1 month));

#Średnia trudność dróg jakie przeszli wspinacze podczas ostatniego miesiąca - pogrupowani
select wspinacz.imie, wspinacz.nazwisko, round(avg(droga_p.wycena_p)) as 'Średnia wycena' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where przejscia_p.data_pp >= (date_sub(curdate(), interval 1 month))
group by przejscia_p.wspinacz_id_p;

#Ilość dróg trudniejszych od wybranego progu jakie przeszli wszyscy wspinacze
select wspinacz.imie, wspinacz.nazwisko, count(*) as 'Liczba dróg trudniejszych niż 10' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where droga_p.wycena_p > 10;

#Ilość dróg trudniejszych od wybranego progu jakie przeszedl dany wspinacz
select wspinacz.imie, wspinacz.nazwisko, count(*) as 'Liczba dróg trudniejszych niż 10' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where droga_p.wycena_p > 10 and przejscia_p.wspinacz_id_p = 1;

#Średnia trudność dróg robionych przez wspinaczy wg krajów w ciągu ostatnich 60 dni
select wspinacz.kraj, round(avg(droga_p.wycena_p)) as 'Średnia wycena' from droga_p 
left join przejscia_p using (droga_p_id) 
left join wspinacz on przejscia_p.wspinacz_id_p = wspinacz.wspinacz_id
where przejscia_p.data_pp >= (date_sub(curdate(), interval 60 day))
group by wspinacz.kraj;

#Widok wszystkich dróg ze ścianek w Warszawie
create view drogi_w_warszawie as
select droga_p.nazwa_drogi_p as 'Droga', droga_p.wycena_p as 'Wycena', sciana.nazwa_sciany as 'Ściana', miasto.nazwa_miasta as 'Miasto' from droga_p
natural left join sciana
natural left join miasto
where miasto_id = 1;

#Widok liczba dróg w bazie z podziałem na miasta
create view l_drog_wg_miast as
select miasto.nazwa_miasta as 'Miasto', count(*) from droga_p
natural left join sciana
natural left join miasto
group by miasto.miasto_id;

#Top trzy oceniane drogi
create view top3 as
select droga_p.nazwa_drogi_p as 'Droga', round(avg(przejscia_p.ocena_p), 1) as 'Śr. ocena', sciana.nazwa_sciany as 'Ściana', miasto.nazwa_miasta as 'Miasto', kraj.nazwa_kraju as 'Kraj' from przejscia_p 
natural left join droga_p
natural left join sciana
natural left join miasto
natural left join kraj
group by przejscia_p.droga_p_id
order by (avg(przejscia_p.ocena_p)) desc
limit 3;

#Najlepsze drogi wg krajow
select droga_p.nazwa_drogi_p as 'Droga', round(avg(przejscia_p.ocena_p), 1) as 'Śr. ocena', sciana.nazwa_sciany as 'Ściana', miasto.nazwa_miasta as 'Miasto', kraj.nazwa_kraju as 'Kraj' from przejscia_p 
natural left join droga_p
natural left join sciana
natural left join miasto
natural left join kraj
group by kraj.kraj_id, przejscia_p.droga_p_id
order by (avg(przejscia_p.ocena_p)) desc
limit 2;

#Drogi z wycenami 
select droga_p.nazwa_drogi_p as 'Nazwa drogi', 
case 
when droga_p.skala_p = 'uiaa' then wyceny.uiaa #where droga_p.wycena_p = wyceny.wycena
when droga_p.skala_p = 'fr' then wyceny.fr 
when droga_p.skala_p = 'kurtyki' then wyceny.kurtyki
else wyceny.usa
end as 'Wycena',
droga_p.l_przejsc_p as 'Liczba przejść',
sciana.nazwa_sciany as 'Ściana', miasto.nazwa_miasta as 'Miasto'
from droga_p left join wyceny on droga_p.wycena_p = wyceny.wycena
natural left join sciana
natural left join miasto;

use wykaz_p;
select username, password, uprawnienia from user where username = 'rafal';
update user set password = 'rafal' where username = 'rafal';