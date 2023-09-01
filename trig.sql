-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 07, 2022 at 08:57 AM
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
-- Database: `trig`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `ps1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ps1` ()  begin
SELECT count(*) FROM `etudiant` ;

end$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `Fct1`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Fct1` () RETURNS INT(11) begin
declare nbr int;
SELECT count(*) into nbr FROM `etudiant` ;
return nbr;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `classe`
--

DROP TABLE IF EXISTS `classe`;
CREATE TABLE IF NOT EXISTS `classe` (
  `codeC` int(11) NOT NULL,
  `nomC` varchar(30) NOT NULL,
  `Effectif` int(11) NOT NULL,
  PRIMARY KEY (`codeC`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `classe`
--

INSERT INTO `classe` (`codeC`, `nomC`, `Effectif`) VALUES
(1, 'tdi101', 0),
(2, 'tdi102', 0);

-- --------------------------------------------------------

--
-- Table structure for table `etudiant`
--

DROP TABLE IF EXISTS `etudiant`;
CREATE TABLE IF NOT EXISTS `etudiant` (
  `codeE` int(11) NOT NULL,
  `nomE` varchar(30) NOT NULL,
  `emailE` varchar(60) NOT NULL,
  `ageE` int(11) NOT NULL,
  `codeC` int(11) NOT NULL,
  PRIMARY KEY (`codeE`),
  KEY `codeC` (`codeC`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `etudiant`
--

INSERT INTO `etudiant` (`codeE`, `nomE`, `emailE`, `ageE`, `codeC`) VALUES
(101, 'zarah', 'zarah@gmail.com', 25, 1),
(102, 'saidi', 'saidi@', 25, 1),
(103, 'ilyas', 'ilyas@', 23, 2),
(104, 'mourad', 'mourad@gmail', 22, 2),
(105, 'karim', 'karim@', 23, 2),
(106, 'Omar', 'Omar@', 23, 2),
(110, 'chemssi', 'chemssi', 14, 2),
(111, 'morjani', 'chemssi', -400, 2),
(120, 'fghjk', 'dfghjkl', 22, 1);

--
-- Triggers `etudiant`
--
DROP TRIGGER IF EXISTS `tr_Ajout_Nom`;
DELIMITER $$
CREATE TRIGGER `tr_Ajout_Nom` BEFORE INSERT ON `etudiant` FOR EACH ROW BEGIN
if length( new.nomE)<3 THEN
	SIGNAL SQLSTATE '45000'
    set MESSAGE_TEXT='Le nom doit comporter plus de  3 caratères';
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_ModifEmail2`;
DELIMITER $$
CREATE TRIGGER `tr_ModifEmail2` BEFORE UPDATE ON `etudiant` FOR EACH ROW begin
declare oldemail, newemail varchar(50);
set oldemail=old.emailE;
set newemail=new.emailE;
if  newemail  != oldemail then
      signal sqlstate '45000' set message_Text="On ne peut pas modifier l'email";
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_Modif_age`;
DELIMITER $$
CREATE TRIGGER `tr_Modif_age` BEFORE UPDATE ON `etudiant` FOR EACH ROW BEGIN declare x int; set x= new.ageE; if x<17 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT="Problème de modification: L'age doit être >17"; end if; end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_age`;
DELIMITER $$
CREATE TRIGGER `tr_age` BEFORE INSERT ON `etudiant` FOR EACH ROW begin
declare x int;
set x= new.ageE;

 if x<16 THEN
 	signal  SQLSTATE '45000' 
    set MESSAGE_TEXT="L' age des etudiants doit etre >16, On accepte pas les enfants";
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_ajout_Email`;
DELIMITER $$
CREATE TRIGGER `tr_ajout_Email` BEFORE INSERT ON `etudiant` FOR EACH ROW BEGIN
DECLARE x varchar(50);
set x= new.emailE;

if EXISTS( select * from etudiant WHERE emaile= x) THEN
SIGNAL SQLSTATE '45000'
set MESSAGE_TEXT="Cet email existe déjà";
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_eefictif`;
DELIMITER $$
CREATE TRIGGER `tr_eefictif` AFTER UPDATE ON `etudiant` FOR EACH ROW begin
DECLARE Cc int;
set Cc = old.CodeC;
IF EXISTS (select * from etudiant where codeC=Cc) THEN
    UPDATE classe set Effectif=Effectif + 1 where codeC=Cc;
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_nodelete`;
DELIMITER $$
CREATE TRIGGER `tr_nodelete` BEFORE UPDATE ON `etudiant` FOR EACH ROW begin
declare ce INT;
set ce=old.codeE;
if EXISTS (select * from notation where codeE=ce ) THEN
      signal sqlstate '45000' set message_Text="l'etudiant a dejà passer un examen !";

end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
CREATE TABLE IF NOT EXISTS `module` (
  `NModule` int(11) NOT NULL,
  `intituleMod` varchar(60) DEFAULT NULL,
  `Coefficient` int(11) DEFAULT NULL,
  `MasseHor` int(11) DEFAULT NULL,
  PRIMARY KEY (`NModule`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `module`
--

INSERT INTO `module` (`NModule`, `intituleMod`, `Coefficient`, `MasseHor`) VALUES
(10, 'C++', 5, 90),
(20, 'CSS', 4, 80),
(30, 'JS', 3, 120);

-- --------------------------------------------------------

--
-- Table structure for table `notation`
--

DROP TABLE IF EXISTS `notation`;
CREATE TABLE IF NOT EXISTS `notation` (
  `NNotation` int(11) NOT NULL,
  `NEtudiant` int(11) DEFAULT NULL,
  `NModule` int(11) DEFAULT NULL,
  `TypeNotation` varchar(15) DEFAULT NULL,
  `Note` float DEFAULT NULL,
  PRIMARY KEY (`NNotation`),
  KEY `NStagiaire` (`NEtudiant`),
  KEY `NModule` (`NModule`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notation`
--

INSERT INTO `notation` (`NNotation`, `NEtudiant`, `NModule`, `TypeNotation`, `Note`) VALUES
(1, 101, 10, 'CC', 9),
(2, 101, 20, 'CC', 8),
(3, 102, 10, 'CC', 15),
(4, 102, 20, 'CC', 17),
(5, 102, 30, 'CC', 2),
(6, 104, 20, 'EFM', 14),
(76, 106, 30, 'EFM', 14),
(77, 106, 20, 'EFM', 6),
(78, 106, 20, 'EFM', 6),
(89, 102, 30, 'EFM', 14);

--
-- Triggers `notation`
--
DROP TRIGGER IF EXISTS `tr_notype`;
DELIMITER $$
CREATE TRIGGER `tr_notype` AFTER INSERT ON `notation` FOR EACH ROW BEGIN
declare n int;
declare t varchar(50);
set t = new.TypeNotation;
set n = new.Note;
if n>20 and t='CC' THEN
    SIGNAL SQLSTATE '45000'
    set MESSAGE_TEXT = "error pas d ajout de note pour CC et EFM";
ELSEIF n>40 and t='EFM' THEN
    SIGNAL SQLSTATE '45000'
    set MESSAGE_TEXT = 'error pas d ajout de note pour CC et EFM ';
end if;
end
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_type`;
DELIMITER $$
CREATE TRIGGER `tr_type` AFTER INSERT ON `notation` FOR EACH ROW BEGIN
declare t varchar(50);
set t = new.TypeNotation;
if t='CC' THEN
    SIGNAL SQLSTATE '45000'
    set MESSAGE_TEXT = "error pas d ajout de note pour CC et EFM";
ELSEIF  t='EFM' THEN
    SIGNAL SQLSTATE '45000'
    set MESSAGE_TEXT = 'error pas d ajout de note pour CC et EFM ';
end if;
end
$$
DELIMITER ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `etudiant`
--
ALTER TABLE `etudiant`
  ADD CONSTRAINT `etudiant_ibfk_1` FOREIGN KEY (`codeC`) REFERENCES `classe` (`codeC`);

--
-- Constraints for table `notation`
--
ALTER TABLE `notation`
  ADD CONSTRAINT `notation_ibfk_1` FOREIGN KEY (`NEtudiant`) REFERENCES `etudiant` (`codeE`),
  ADD CONSTRAINT `notation_ibfk_2` FOREIGN KEY (`NModule`) REFERENCES `module` (`NModule`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
