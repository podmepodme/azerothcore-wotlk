-- DB update 2021_10_14_01_auth -> 2021_11_06_00
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
SELECT COUNT(*) INTO @COLEXISTS
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'version_db_auth' AND COLUMN_NAME = '2021_10_14_01_auth';
IF @COLEXISTS = 0 THEN LEAVE proc; END IF;
START TRANSACTION;
ALTER TABLE version_db_auth CHANGE COLUMN 2021_10_14_01_auth 2021_11_06_00 bit;
SELECT sql_rev INTO OK FROM version_db_auth WHERE sql_rev = '1635587640506554000'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--

INSERT INTO `version_db_auth` (`sql_rev`) VALUES ('1635587640506554000');

ALTER TABLE `updates` CHANGE `state` `state` ENUM('RELEASED','CUSTOM','MODULE','ARCHIVED') CHARSET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'RELEASED' NOT NULL COMMENT 'defines if an update is released or archived.';

--
-- END UPDATING QUERIES
--
UPDATE version_db_auth SET date = '2021_11_06_00' WHERE sql_rev = '1635587640506554000';
COMMIT;
END //
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;