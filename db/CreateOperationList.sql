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
-- Table structure for table `operation_lists`
--

DROP TABLE IF EXISTS `operation_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operation_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `OPCode` int(11) NOT NULL,
  `Operation` varchar(200) NOT NULL,
  `DateCreated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_lists`
--

LOCK TABLES `operation_lists` WRITE;
/*!40000 ALTER TABLE `operation_lists` DISABLE KEYS */;
INSERT INTO `operation_lists` (`id`, `OPCode`, `Operation`, `DateCreated`) VALUES (1,101,'Added New Admin','2014-01-14 15:29:34'),(2,102,'Updated Admin Details','2014-01-14 15:29:34'),(3,103,'Changed Admin Password','2014-01-14 15:29:34'),(4,104,'Changed Admin Permissions','2014-01-14 15:29:34'),(5,105,'Activated User','2014-01-14 15:29:34'),(6,106,'Deactivated User','2014-01-14 15:29:34'),(7,107,'Added New User','2014-01-14 15:29:34'),(8,108,'Updated User Details','2014-01-14 15:29:34'),(9,109,'Changed User Password','2014-01-14 15:29:34'),(10,110,'Approved Review','2014-01-14 15:29:34'),(11,111,'Disapproved Review','2014-01-14 15:29:34'),(12,112,'Published Review','2014-01-14 15:29:34'),(13,113,'Unpublished Review','2014-01-14 15:29:34'),(14,114,'Updated ML & Judgements Details','2014-01-14 15:29:34'),(15,115,'Updated Court Proceedings Details','2014-01-14 15:29:34'),(16,116,'Updated Site Content','2014-01-14 15:29:34'),(17,117,'Added New FAQ','2014-01-14 15:29:34'),(18,118,'Updated FAQ','2014-01-14 15:29:34'),(19,119,'Deleted FAQ','2014-01-14 15:29:34'),(20,120,'Enabled FAQ','2014-01-14 15:29:34'),(21,121,'Disabled FAQ','2014-01-14 15:29:34'),(22,122,'Added New Testimonial','2014-01-14 15:29:34'),(23,123,'Updated Testimonial','2014-01-14 15:29:34'),(24,124,'Deleted Testimonial','2014-01-14 15:29:34'),(25,125,'Enabled Testimonial','2014-01-14 15:29:34'),(26,126,'Disabled Testimonial','2014-01-14 15:29:34'),(27,127,'Added New News & Update','2014-01-14 15:29:34'),(28,128,'Updated News & Update','2014-01-14 15:29:34'),(29,129,'Deleted News & Update','2014-01-14 15:29:34'),(30,130,'Enabled News & Update','2014-01-14 15:29:34'),(31,131,'Disabled News & Update','2014-01-14 15:29:34'),(32,132,'Activated Admin','2014-01-14 15:29:34'),(33,133,'Deactivated Admin','2014-01-14 15:29:34');
/*!40000 ALTER TABLE `operation_lists` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-22 15:17:36
