-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 09, 2022 at 12:13 PM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `compte`
--

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `NumCli` int(11) NOT NULL,
  `CINCli` varchar(7) DEFAULT NULL,
  `NomCli` varchar(30) DEFAULT NULL,
  `AdreCli` varchar(50) DEFAULT NULL,
  `TelCli` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`NumCli`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`NumCli`, `CINCli`, `NomCli`, `AdreCli`, `TelCli`) VALUES
(10, 'J1111', 'Omar', 'agadir', '011111'),
(20, 'JB22222', 'amine', 'tanger', '02222'),
(30, 'W33333', 'karim', 'rabat', '03333');

--
-- Triggers `client`
--
DROP TRIGGER IF EXISTS `num_cin`;
DELIMITER $$
CREATE TRIGGER `num_cin` BEFORE INSERT ON `client` FOR EACH ROW BEGIN
DECLARE n varchar(10);
set n=new.CINCli;
if EXISTS (SELECT * from client where n=CNICli)THEN
		signal SQLSTATE '45000'
        set MESSAGE_TEXT= " Ce CIN existe déjà pour un autre client";
END if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `compte`
--

DROP TABLE IF EXISTS `compte`;
CREATE TABLE IF NOT EXISTS `compte` (
  `NumCpt` int(11) NOT NULL,
  `SoldeCpt` float DEFAULT NULL,
  `TypeCpt` varchar(2) DEFAULT NULL,
  `NumCli` int(11) DEFAULT NULL,
  PRIMARY KEY (`NumCpt`),
  KEY `NumCli` (`NumCli`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `compte`
--

INSERT INTO `compte` (`NumCpt`, `SoldeCpt`, `TypeCpt`, `NumCli`) VALUES
(100, 80000, 'CN', 10),
(200, 22222, 'CN', 20),
(300, 33333, 'CN', 30),
(400, 80000, 'CC', 10),
(500, 48000, 'CC', 20),
(600, 30000, 'CC', 30);

--
-- Triggers `compte`
--
DROP TRIGGER IF EXISTS `creer_compt`;
DELIMITER $$
CREATE TRIGGER `creer_compt` BEFORE INSERT ON `compte` FOR EACH ROW BEGIN
declare s int;
declare t varchar (20);
DECLARE c int;
DECLARE nc int;
DECLARE ncp int;
set s=new.soldecpt;
set t=new.typecpt;
set nc=new.NumCli;
set ncp=new.numCpt;
if s<1500 then signal SQLSTATE '45000';
end if;
if t!='cc' then signal SQLSTATE '45000';
end if;
if t!='cn' then signal SQLSTATE '45000';
end if;
if exists (SELECT * from compte WHERE nc=NUMCli and t=typecpt)
THEN signal SQLSTATE '45000';
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr4`;
DELIMITER $$
CREATE TRIGGER `tr4` BEFORE DELETE ON `compte` FOR EACH ROW BEGIN
DECLARE s int;
DECLARE d date;
DECLARE c int;
DECLARE n int;
set s=old.soldecpt ;
set c=old.NumCpt;
if s>0 THEN signal SQLSTATE '45000'; end if;
if s=0  THEN
SELECT Min(datediff(curDate(),DateOp)) into n from operation WHERE n=old.NumCpt;
if n<90 then SIGNAL SQLSTATE '45000';
end if;
end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `operation`
--

DROP TABLE IF EXISTS `operation`;
CREATE TABLE IF NOT EXISTS `operation` (
  `NumOp` int(11) NOT NULL,
  `TypeOp` varchar(25) DEFAULT NULL,
  `MntOp` float DEFAULT NULL,
  `NumCpt` int(11) DEFAULT NULL,
  `DateOp` date DEFAULT NULL,
  PRIMARY KEY (`NumOp`),
  KEY `NumCpt` (`NumCpt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Triggers `operation`
--
DROP TRIGGER IF EXISTS `t5`;
DELIMITER $$
CREATE TRIGGER `t5` BEFORE INSERT ON `operation` FOR EACH ROW BEGIN
DECLARE t varchar (30);
DECLARE m int;
DECLARE s int;
DECLARE c int;
set t=new.Typeop;
set m=new.mntop;
set c=new.NumCpt;
SELECT soldecpt into s from compte where NumCpt=c;
if t='r' and m>s
THEN SIGNAL SQLSTATE '45000';
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr3`;
DELIMITER $$
CREATE TRIGGER `tr3` BEFORE INSERT ON `operation` FOR EACH ROW BEGIN
DECLARE t varchar (30);
DECLARE n int;
DECLARE d date;
set t=new.TypeOp;
set n = new.NumCpt;
set d=new.DateOp;
if t!='R' THEN signal SQLSTATE '45000'; end if;
if t!= 'd'  THEN signal SQLSTATE '45000'; end if;
if not EXISTS ( SELECT * from operation where NumCpt=n)
THEN signal SQLSTATE '45000'; end if;
if d>CURRENT_DATE THEN signal SQLSTATE '45000'; end if;
end
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
