CREATE TABLE IF NOT EXISTS `keep_bags_retrieval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `available_at` DATETIME NOT NULL ,
  `expire_at` DATETIME NOT NULL ,
  `metadata` TEXT NULL ,
  `claimed` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  KEY `characterId` (`characterId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

