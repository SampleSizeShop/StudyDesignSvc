-- Turn off foreign key checks so we can drop tables as needed.
set foreign_key_checks = 0;

create database if not exists studydesigndb;
character set utf8;
    
use studydesigndb;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_DESIGN`
-- -----------------------------------------------------
drop table if exists STUDY_DESIGN;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_DESIGN` (
  `uuid` BINARY(16) NOT NULL ,  
  `solutionType` ENUM( 'Power' , 'Samplesize' , 'Detectable Difference' ) ,
  `viewType` ENUM( 'Guided Mode', 'Matrix Mode', 'Upload'),
  `hasGaussianCovariate` BOOLEAN ,
  `name` VARCHAR(256) ,
  `participantLabel` VARCHAR(45),
  PRIMARY KEY (`uuid`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`CONFIDENCE_INTERVAL`
-- -----------------------------------------------------
drop table if exists CONFIDENCE_INTERVAL;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`CONFIDENCE_INTERVAL` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `isBetaFixed` BOOLEAN ,
  `isSigmaFixed` BOOLEAN ,
  `lowerTailProbability` FLOAT ,
  `upperTailProbability` FLOAT ,
  `sampleSize` INT ,
  `rankOfDesignMatrix` INT ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_CONFIDENCE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_CONFIDENCE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_CONFIDENCE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE, 
  PRIMARY KEY (`uuid`), 
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`CONFIDENCE_INTERVAL`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- ------------------------------------------------------
-- Table `studydesigndb`.`POWER_CURVE_DESCRIPTION`
-- ------------------------------------------------------
drop table if exists POWER_CURVE_DESCRIPTION;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`POWER_CURVE_DESCRIPTION` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `sampleSize` INT ,
  `horizontalAxisLabel` ENUM('Variability Scale Factor','Total Sample Size','Regression Coeeficient Scale Factor'),
  `stratificationVariable` ENUM('Type I error','Statistical Test'),
  `statisticalTest` ENUM('unirep','unirepBox','unirepGG','unirepHF','wl','pbt','hlt'),
  `powerMethod` ENUM('Conditional' , 'Unconditional' , 'Quantile'),  
  `tablePowerCurveDescription` VARCHAR(45),
  `betaScale` DOUBLE,
  `sigmaScale` DOUBLE,
  `quantile` DOUBLE,
  `typeIError` DOUBLE,  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_POWER_CURVE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_POWER_CURVE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_POWER_CURVE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE, 
  PRIMARY KEY (`uuid`), 
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`POWER_CURVE_DESCRIPTION`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`BETA_SCALE_LIST`
-- --------------------------------------------------------
drop table if exists BETA_SCALE_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`BETA_SCALE_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `beta_value` DOUBLE ,  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_BETA_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_BETA_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_BETA_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`BETA_SCALE_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- ------------------------------------------------------
-- Table `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS`
-- ------------------------------------------------------
drop table if exists BETWEEN_PARTICIPANT_EFFECTS;
CREATE TABLE IF NOT EXISTS `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS` (
  `id` INT NOT NULL AUTO_INCREMENT ,   
  `predictorName` VARCHAR(45) , 
  PRIMARY KEY(`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_BETWEEN_PARTICIPANT_EFFECTS_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_BETWEEN_PARTICIPANT_EFFECTS_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_BETWEEN_PARTICIPANT_EFFECTS_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- ------------------------------------------------------
-- Table `studydesigndb`.`CATEGORY_NODE`
-- ------------------------------------------------------
drop table if exists CATEGORY_NODE;
CREATE TABLE IF NOT EXISTS `studydesigndb`.`CATEGORY_NODE` (
  `id` INT NOT NULL AUTO_INCREMENT , 
  `category` VARCHAR(45) ,
  PRIMARY KEY(`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS_CATEGORY_MAP`
-- -----------------------------------------------------
drop table if exists BETWEEN_PARTICIPANT_EFFECTS_CATEGORY_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS_CATEGORY_MAP` (  
  `id` INT NOT NULL,
  `categoryId` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`categoryId`)
  REFERENCES `studydesigndb`.`CATEGORY_NODE`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`CLUSTER_NODE`
-- -----------------------------------------------------
drop table if exists CLUSTER_NODE;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`CLUSTER_NODE` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `group_name` VARCHAR(45) ,
  `group_size` INT , 
  `current_node` INT,  
  `node_parent` INT,
  `Correlation` DOUBLE ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_CLUSTERING_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_CLUSTERING_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_CLUSTERING_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`CLUSTER_NODE`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`STATISTICAL_TEST_LIST`
-- --------------------------------------------------------
drop table if exists STATISTICAL_TEST_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STATISTICAL_TEST_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `type` ENUM('unirep','unirepBox','unirepGG','unirepHF','wl','pbt','hlt'),  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_STATISTICAL_TEST_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_STATISTICAL_TEST_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_STATISTICAL_TEST_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE, 
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`STATISTICAL_TEST_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`RESPONSE_LIST`
-- -----------------------------------------------------
drop table if exists RESPONSES_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`RESPONSE_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_RESPONSE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_RESPONSE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_RESPONSE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE, 
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`RESPONSE_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`NOMINAL_POWER_LIST`
-- -----------------------------------------------------
drop table if exists NOMINAL_POWER_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`NOMINAL_POWER_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `node_value` DOUBLE ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_NOMINAL_POWER_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_NOMINAL_POWER_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_NOMINAL_POWER_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE, 
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`NOMINAL_POWER_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`COVARIANCE`
-- -----------------------------------------------------
drop table if exists COVARIANCE;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`COVARIANCE` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) ,
  `rho` DOUBLE,
  `delta` DOUBLE,
  `rows` INT,
  `columns` INT,
  `data` MEDIUMBLOB,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STANDARD_DEVIATION`
-- -----------------------------------------------------
drop table if exists STANDARD_DEVIATION;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STANDARD_DEVIATION` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `standard_deviation` DOUBLE ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`COVARIANCE_SD_MAP`
-- -----------------------------------------------------
drop table if exists COVARIANCE_SD_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`COVARIANCE_SD_MAP` (
  `cid` INT NOT NULL,
  `sid` INT NOT NULL UNIQUE, 
  `listorder` INT,  
  FOREIGN KEY (`sid`)
  REFERENCES `studydesigndb`.`STANDARD_DEVIATION`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`cid`)
  REFERENCES `studydesigndb`.`COVARIANCE`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_COVARIANCE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_COVARIANCE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_COVARIANCE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,   
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`COVARIANCE`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- ------------------------------------------------------
-- Table `studydesigndb`.`MATRIX`
-- ------------------------------------------------------
drop table if exists MATRIX;
CREATE TABLE IF NOT EXISTS `studydesigndb`.`MATRIX` (
  `id` INT NOT NULL AUTO_INCREMENT , 
  `name` VARCHAR(45) ,
  `rows` INT ,
  `columns` INT ,
  `data` MEDIUMBLOB,
  PRIMARY KEY(`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_MATRIX_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_MATRIX_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_MATRIX_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,   
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`MATRIX`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`ALPHA_LIST`
-- --------------------------------------------------------
drop table if exists ALPHA_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`ALPHA_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `alpha_value` DOUBLE ,  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_ALPHA_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_ALPHA_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_ALPHA_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`ALPHA_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`SIGMA_SCALE_LIST`
-- --------------------------------------------------------
drop table if exists SIGMA_SCALE_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`SIGMA_SCALE_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `sigma_scale_value` DOUBLE ,  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_SIGMA_SCALE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_SIGMA_SCALE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_SIGMA_SCALE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`SIGMA_SCALE_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`QUANTILE_LIST`
-- --------------------------------------------------------
drop table if exists QUANTILE_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`QUANTILE_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `quantile_value` DOUBLE ,  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_QUANTILE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_QUANTILE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_QUANTILE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`QUANTILE_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`RELATIVE_GROUP_SIZE_LIST`
-- --------------------------------------------------------
drop table if exists RELATIVE_GROUP_SIZE_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`RELATIVE_GROUP_SIZE_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `relative_group_size_value` INT ,  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_RELATIVE_GROUP_SIZE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_RELATIVE_GROUP_SIZE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_RELATIVE_GROUP_SIZE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`RELATIVE_GROUP_SIZE_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`POWER_METHOD_LIST`
-- --------------------------------------------------------
drop table if exists POWER_METHOD_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`POWER_METHOD_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `method` ENUM('Conditional' , 'Unconditional' , 'Quantile'),  
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_POWER_METHOD_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_POWER_METHOD_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_POWER_METHOD_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`POWER_METHOD_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`REPEATED_MEASURES`
-- --------------------------------------------------------
drop table if exists REPEATED_MEASURES;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`REPEATED_MEASURES` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) ,
  `repeatType` ENUM( 'Numerical','Ordinal','Categorical') ,
  `node` INT ,
  `parent` INT,
  `units` VARCHAR(45) ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_REPEATED_MEASURES_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_REPEATED_MEASURES_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_REPEATED_MEASURES_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`REPEATED_MEASURES`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`SPACING_LIST`
-- -----------------------------------------------------
drop table if exists SPACING_LIST;
CREATE TABLE IF NOT EXISTS `studydesigndb`.`SPACING_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT , 
  `data` INT ,
  PRIMARY KEY(`id`) )
ENGINE = InnoDB; 

-- -----------------------------------------------------
-- Table `studydesigndb`.`REPEATED_MEASURES_SPACING_MAP`
-- -----------------------------------------------------
drop table if exists REPEATED_MEASURES_SPACING_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`REPEATED_MEASURES_SPACING_MAP` (
  `id` INT NOT NULL,
  `spacingId` INT NOT NULL UNIQUE,
  `listorder` INT,
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`REPEATED_MEASURES`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`spacingId`)
  REFERENCES `studydesigndb`.`SPACING_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- --------------------------------------------------------
-- Table `studydesigndb`.`SAMPLE_SIZE_LIST`
-- --------------------------------------------------------
drop table if exists SAMPLE_SIZE_LIST;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`SAMPLE_SIZE_LIST` (
  `id` INT NOT NULL AUTO_INCREMENT ,  
  `sample_size_value` INT , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_SAMPLE_SIZE_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_SAMPLE_SIZE_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_SAMPLE_SIZE_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,
  `listorder` INT,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`SAMPLE_SIZE_LIST`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`HYPOTHESIS`
-- -----------------------------------------------------
drop table if exists HYPOTHESIS;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`HYPOTHESIS` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `trendType` ENUM( 'Main Effect','Interaction','Trend') , 
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`STUDY_HYPOTHESIS_MAP`
-- -----------------------------------------------------
drop table if exists STUDY_HYPOTHESIS_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`STUDY_HYPOTHESIS_MAP` (
  `uuid` BINARY(16) NOT NULL,
  `id` INT NOT NULL UNIQUE,  
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`HYPOTHESIS`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`uuid`)
  REFERENCES `studydesigndb`.`STUDY_DESIGN`(`uuid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`HYPOTHESIS_BETWEEN_PARTICIPANT_MAP`
-- -----------------------------------------------------
drop table if exists HYPOTHESIS_BETWEEN_PARTICIPANT_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`HYPOTHESIS_BETWEEN_PARTICIPANT_MAP` (
  `id` INT NOT NULL,
  `betweenParticipantId` INT UNIQUE,   
  `trendType` ENUM( 'None','Change from baseline','All polynomial trends','Linear trend','Quadratic trend','Cubic trend') , 
  `listorder` INT,
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`HYPOTHESIS`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`betweenParticipantId`)
  REFERENCES `studydesigndb`.`BETWEEN_PARTICIPANT_EFFECTS`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `studydesigndb`.`HYPOTHESIS_REPEATED_MEASURES_MAP`
-- -----------------------------------------------------
drop table if exists HYPOTHESIS_REPEATED_MEASURES_MAP;
CREATE  TABLE IF NOT EXISTS `studydesigndb`.`HYPOTHESIS_REPEATED_MEASURES_MAP` (
  `id` INT NOT NULL,
  `repeatedMeasuresId` INT UNIQUE,
  `trendType` ENUM( 'None','Change from baseline','All polynomial trends','Linear trend','Quadratic trend','Cubic trend') ,   
  `listorder` INT, 
  FOREIGN KEY (`id`)
  REFERENCES `studydesigndb`.`HYPOTHESIS`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`repeatedMeasuresId`)
  REFERENCES `studydesigndb`.`REPEATED_MEASURES`(`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE
)
ENGINE = InnoDB;


# Turn foreign key checks back on
set foreign_key_checks = 1;
