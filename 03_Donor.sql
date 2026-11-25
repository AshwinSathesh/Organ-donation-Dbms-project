USE odmcs;

CREATE TABLE IF NOT EXISTS Donor (
    Donor_ID                  INT AUTO_INCREMENT PRIMARY KEY,
    Donor_Name                VARCHAR(100) NOT NULL,
    Date_of_Birth             DATE,
    Gender                    VARCHAR(30),
    Blood_Group               ENUM('A+', 'A-', 'B+', 'B-',
                                   'AB+', 'AB-', 'O+', 'O-'),
    Contact_Number            VARCHAR(20),
    Hospital_ID               INT NOT NULL,
    Brain_Stem_Death_Cert_Ref VARCHAR(100) NOT NULL,
    Brain_Stem_Death_Certified_At DATETIME NOT NULL,
    Donor_Status              ENUM('Open', 'Closed') NOT NULL DEFAULT 'Open',

    CONSTRAINT fk_donor_hospital
        FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID),

    CONSTRAINT chk_donor_cert_ref
        CHECK (CHAR_LENGTH(TRIM(Brain_Stem_Death_Cert_Ref)) > 0)
);

DESCRIBE Donor;