-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Värd: localhost
-- Tid vid skapande: 25 maj 2016 kl 12:20
-- Serverversion: 5.5.44-0+deb8u1
-- PHP-version: 5.6.20-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databas: `riksdagen`
--
CREATE DATABASE IF NOT EXISTS `riksdagen` DEFAULT CHARACTER SET utf8 COLLATE utf8_swedish_ci;
USE `riksdagen`;

-- --------------------------------------------------------

--
-- Tabellstruktur `Contacts`
--

CREATE TABLE IF NOT EXISTS `Contacts` (
  `cId` int(11) NOT NULL,
  `cName` varchar(64) COLLATE utf8_swedish_ci NOT NULL,
  `cLName` varchar(64) COLLATE utf8_swedish_ci NOT NULL,
  `cEmail` varchar(254) COLLATE utf8_swedish_ci NOT NULL,
  `cSend` int(11) NOT NULL,
  `cSentLast` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumpning av Data i tabell `Contacts`
--

INSERT INTO `Contacts` (`cId`, `cName`, `cLName`, `cEmail`, `cSend`) VALUES
(1, 'Stefan', 'L.', 'stefan.l@riksdagen.se', 1),
(2, 'Hanif', 'B.', 'hanif.b@riksdagen.se', 1);

-- --------------------------------------------------------

--
-- Tabellstruktur `Templates`
--

CREATE TABLE IF NOT EXISTS `Templates` (
  `tId` int(11) NOT NULL,
  `tSubject` varchar(256) COLLATE utf8_swedish_ci NOT NULL,
  `tBody` varchar(4096) COLLATE utf8_swedish_ci NOT NULL,
  `tFile` varchar(256) COLLATE utf8_swedish_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumpning av Data i tabell `Templates`
--

INSERT INTO `Templates` (`tId`, `tSubject`, `tBody`, `tFile`) VALUES
(1, 'Test 123', 'Hej $cName,\r\ntack för senast!\r\n\r\nMvh,\r\n// Mikael', 'MOB-CV-EU-sv.pdf');

--
-- Index för dumpade tabeller
--

--
-- Index för tabell `Contacts`
--
ALTER TABLE `Contacts`
 ADD PRIMARY KEY (`cId`);

--
-- Index för tabell `Templates`
--
ALTER TABLE `Templates`
 ADD PRIMARY KEY (`tId`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
