CREATE DATABASE  IF NOT EXISTS `nickslist_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `nickslist_dev`;
-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: nickslist_dev
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.13.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `site_module_user_joins`
--

DROP TABLE IF EXISTS `site_module_user_joins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_module_user_joins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ModuleID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `DateCreated` datetime NOT NULL,
  `DateUpdated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_module_user_joins`
--

LOCK TABLES `site_module_user_joins` WRITE;
/*!40000 ALTER TABLE `site_module_user_joins` DISABLE KEYS */;
INSERT INTO `site_module_user_joins` (`id`, `ModuleID`, `UserID`, `DateCreated`, `DateUpdated`) VALUES (1,2,1,'2013-12-02 16:59:54','2013-12-02 16:59:54'),(2,1,1,'2013-12-17 12:45:24','2013-12-17 12:45:24'),(3,3,1,'2013-12-17 12:45:24','2013-12-17 12:45:24'),(4,1,2,'2013-12-17 12:51:32','2013-12-17 12:51:32'),(5,3,2,'2013-12-17 12:51:32','2013-12-17 12:51:32');
/*!40000 ALTER TABLE `site_module_user_joins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_users`
--

DROP TABLE IF EXISTS `site_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(20) NOT NULL,
  `Password` varchar(100) NOT NULL,
  `Salt` varchar(45) NOT NULL,
  `FirstName` varchar(20) NOT NULL,
  `LastName` varchar(20) NOT NULL,
  `EmailID` varchar(50) NOT NULL,
  `IsActivated` tinyint(1) NOT NULL,
  `DateCreated` datetime NOT NULL,
  `DateUpdated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_users`
--

LOCK TABLES `site_users` WRITE;
/*!40000 ALTER TABLE `site_users` DISABLE KEYS */;
INSERT INTO `site_users` (`id`, `UserName`, `Password`, `Salt`, `FirstName`, `LastName`, `EmailID`, `IsActivated`, `DateCreated`, `DateUpdated`) VALUES (1,'admin','hÏkC·âYh4¯ëc\\','20131217','nick','serge','nicks@iiil.in',1,'2013-12-16 20:27:11','2013-12-17 13:39:22'),(2,'billys','Œ—Ðœ.ÐÐ>\\á³\'úÂ&Ü','20131217','Billy','Serge','billys@iiil.in',1,'2013-12-17 12:51:00','2013-12-17 12:51:49');
/*!40000 ALTER TABLE `site_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-17 15:07:08
