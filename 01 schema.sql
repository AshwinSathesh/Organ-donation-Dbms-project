CREATE DATABASE IF NOT EXISTS odmcs;
USE odmcs;

CREATE TABLE IF NOT EXISTS Hospital (
    Hospital_ID    INT AUTO_INCREMENT PRIMARY KEY,
    Hospital_Name  VARCHAR(150) NOT NULL,
    Hospital_Tier  ENUM('Tier 1', 'Tier 2', 'Tier 3') NOT NULL,
    City           VARCHAR(100) NOT NULL,
    State          ENUM('Karnataka', 'Tamil Nadu', 'Kerala',
                        'Andhra Pradesh', 'Telangana') NOT NULL,
    Contact_Number VARCHAR(20),
    Is_Active      BOOLEAN NOT NULL DEFAULT TRUE
);

DESCRIBE Hospital;
