--
-- This adds StorageAreas
--

SET @s = (SELECT IF(
    (SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.TABLES
    WHERE table_name = 'Storage'
    AND table_schema = DATABASE()
    ) > 0,
"SELECT 'Storage table exists'",
"CREATE TABLE `Storage` (
    `Id`    smallint(5) unsigned NOT NULL auto_increment,
    `Path`  varchar(64) NOT NULL default '',
    `Name`  varchar(64) NOT NULL default '',
    PRIMARY KEY (`Id`)
)"
));

PREPARE stmt FROM @s;
EXECUTE stmt;

--
-- Add StorageId column to Monitors
--

SET @s = (SELECT IF(
    (SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_name = 'Monitors'
    AND table_schema = DATABASE()
    AND column_name = 'StorageId'
    ) > 0,
"SELECT 'Column StorageId exists in Monitors'",
"ALTER TABLE Monitors ADD `StorageId` smallint(5) unsigned NOT NULL default 0 AFTER `ServerId`"
));

PREPARE stmt FROM @s;
EXECUTE stmt;

--
-- Add StorageId column to Eventss
--

SET @s = (SELECT IF(
    (SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_name = 'Events'
    AND table_schema = DATABASE()
    AND column_name = 'StorageId'
    ) > 0,
"SELECT 'Column StorageId exists in Events'",
"ALTER TABLE Events ADD `StorageId` smallint(5) unsigned NOT NULL default 0 AFTER `MonitorId`"
));

PREPARE stmt FROM @s;
EXECUTE stmt;

UPDATE Monitors SET StorageId = 0 WHERE StorageId IS NULL;
ALTER TABLE Monitors MODIFY `StorageId`	smallint(5) unsigned NOT NULL default 0;
UPDATE Events SET StorageId = 0 WHERE StorageId IS NULL;
ALTER TABLE Events MODIFY `StorageId`	smallint(5) unsigned NOT NULL default 0;

SET @s = (SELECT IF(
  (SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_name = 'Events'
  AND table_schema = DATABASE()
  AND column_name = 'Orientation'
  ) > 0,
"SELECT 'Column Orientation exists in Events'",
"ALTER TABLE `Events` ADD `Orientation`  enum('0','90','180','270','hori','vert') NOT NULL default '0' AFTER `Notes`"
));

PREPARE stmt FROM @s;
EXECUTE stmt;

--
-- Update Monitors table to have an Index on ServerId
--
SET @s = (SELECT IF(
  (SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE table_name = 'Monitors'
  AND table_schema = DATABASE()
  AND index_name = 'Monitors_ServerId_idx'
  ) > 0,
"SELECT 'Monitors_ServerId Index already exists on Monitors table'",
"CREATE INDEX `Monitors_ServerId_idx` ON `Monitors` (`ServerId`)"
));

PREPARE stmt FROM @s;
EXECUTE stmt;


--
-- Update Server table to have an Index on Name
--
SET @s = (SELECT IF(
  (SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE table_name = 'Servers'
  AND table_schema = DATABASE()
  AND index_name = 'Servers_Name_idx'
  ) > 0,
"SELECT 'Servers_Name Index already exists on Servers table'",
"CREATE INDEX `Servers_Name_idx` ON `Servers` (`Name`)"
));

PREPARE stmt FROM @s;
EXECUTE stmt;


-- ALTER TABLE Logs ALTER  Message DROP DEFAULT;
ALTER TABLE Logs MODIFY Message TEXT NOT NULL;

ALTER TABLE Config MODIFY DefaultValue TEXT;

