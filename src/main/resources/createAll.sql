CREATE SCHEMA IF NOT EXISTS epers_aterrizar;

USE epers_aterrizar;

CREATE TABLE `usuarios` (
  `name` varchar(45) DEFAULT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `username` varchar(45) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `birth` DATE DEFAULT NULL,
  `password` varchar(45) NOT NULL,
  `validationstate` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
