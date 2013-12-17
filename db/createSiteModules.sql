CREATE DATABASE  IF NOT EXISTS `nickslist_de` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `nickslist_dev`;
-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: nickslist_de
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
-- Table structure for table `site_modules`
--

DROP TABLE IF EXISTS `site_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Module` varchar(20) NOT NULL,
  `Description` varchar(100) NOT NULL,
  `DateCreated` datetime NOT NULL,
  `DateUpdated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_modules`
--

LOCK TABLES `site_modules` WRITE;
/*!40000 ALTER TABLE `site_modules` DISABLE KEYS */;
INSERT INTO `site_modules` (`id`, `Module`, `Description`, `DateCreated`, `DateUpdated`) VALUES (1,'Manage Users','Authorized user can manage the subscribed user of this site.','2013-12-02 16:59:54','2013-12-02 16:59:54'),(2,'Manage Admin','Authorized user can manage the admin users of this site.','2013-12-02 16:59:54','2013-12-02 16:59:54'),(3,'Manage Reviews','Authorized user can manage the users reviews of this site.','2013-12-02 16:59:54','2013-12-02 16:59:54'),(4,'Manage Site Content','Authorized user can manage the content of this site.','2013-12-02 16:59:54','2013-12-02 16:59:54');
/*!40000 ALTER TABLE `site_modules` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-17 15:02:17
