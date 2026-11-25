-- ODMCS | South India hospital directory | Sources checked 18 November 2026
-- Open this file in MySQL Workbench and run the whole script with Ctrl+Shift+Enter.
-- Requires the project's existing odmcs.Hospital table. Each row represents a branch.
-- Public contact numbers are domestic enquiry, switchboard or patient helpline numbers.
-- Resource tiers are assigned under the project's own criteria. NULL means unclassified.
-- Transplant approvals are organ-specific and are outside this directory's scope.
USE odmcs;

-- Also supports the first version of the schema, which required a tier for every row.
ALTER TABLE Hospital
    MODIFY Hospital_Tier ENUM('Tier 1', 'Tier 2', 'Tier 3') NULL DEFAULT NULL;

DROP TEMPORARY TABLE IF EXISTS odmcs_hospital_seed;
CREATE TEMPORARY TABLE odmcs_hospital_seed LIKE Hospital;

-- Karnataka
INSERT INTO odmcs_hospital_seed (Hospital_Name, City, State, Contact_Number)
VALUES
    -- https://www.manipalhospitals.com/oldairportroad/contact-us/
    ('Manipal Hospital, Old Airport Road', 'Bengaluru', 'Karnataka', '18001025555'),
    -- https://bengaluruurban.nic.in/en/public-utility/victoria-hospital/
    ('Victoria Hospital', 'Bengaluru', 'Karnataka', '08026701150'),
    -- https://www.asterhospitals.in/hospitals
    ('Aster CMI Hospital, Hebbal', 'Bengaluru', 'Karnataka', '08043420100'),
    -- https://jsshospital.in/contact-us/
    ('JSS Hospital', 'Mysuru', 'Karnataka', '08212335555'),
    -- https://sdmucmsh.edu.in/contact
    ('SDM College of Medical Sciences & Hospital', 'Dharwad', 'Karnataka', '08362477777');

-- Tamil Nadu
INSERT INTO odmcs_hospital_seed (Hospital_Name, City, State, Contact_Number)
VALUES
    -- https://www.apollohospitals.com/apollo-prohealth-super-sunday-chennai-main-apollo-hospitals-greams-road-chennai
    ('Apollo Hospitals, Greams Road', 'Chennai', 'Tamil Nadu', '04428290200'),
    -- https://chennai.nic.in/public-utility/govt-stanley-hospital/
    ('Government Stanley Hospital', 'Chennai', 'Tamil Nadu', '04425281347'),
    -- https://www.cmcvellore.ac.in/contact-us/
    ('Christian Medical College, Vellore', 'Vellore', 'Tamil Nadu', '8000338855'),
    -- https://www.psghospitals.com/contact-us/
    ('PSG Hospitals', 'Coimbatore', 'Tamil Nadu', '04224345353'),
    -- https://mmhrc.in/contact-us/
    ('Meenakshi Mission Hospital & Research Centre', 'Madurai', 'Tamil Nadu', '04524263000');

-- Kerala
INSERT INTO odmcs_hospital_seed (Hospital_Name, City, State, Contact_Number)
VALUES
    -- https://www.tmc.kerala.gov.in/public/contactus
    ('Government Medical College Hospital, Thiruvananthapuram', 'Thiruvananthapuram', 'Kerala', '04712528225'),
    -- https://kottayammedicalcollege.org/contact/
    ('Government Medical College Hospital, Kottayam', 'Kottayam', 'Kerala', '04812592201'),
    -- https://www.asterhospitals.in/hospitals
    ('Aster Medcity', 'Kochi', 'Kerala', '04846699999'),
    -- https://www.asterhospitals.in/hospitals
    ('Aster MIMS Calicut', 'Kozhikode', 'Kerala', '04952488222'),
    -- https://www.asterhospitals.in/hospitals
    ('Aster MIMS Kannur', 'Kannur', 'Kerala', '04973538000');

-- Andhra Pradesh
INSERT INTO odmcs_hospital_seed (Hospital_Name, City, State, Contact_Number)
VALUES
    -- https://svimstpt.ap.nic.in/Contact.html
    ('Sri Venkateswara Institute of Medical Sciences', 'Tirupati', 'Andhra Pradesh', '08772287777'),
    -- https://www.kimshospitals.com/kurnool/contact-us/
    ('KIMS Hospital, Kurnool', 'Kurnool', 'Andhra Pradesh', '08518667000'),
    -- https://www.kimshospitals.com/nellore/contact-us/
    ('KIMS Hospital, Nellore', 'Nellore', 'Andhra Pradesh', '08612315835'),
    -- https://www.kimshospitals.com/rajahmundry/contact-us/
    ('KIMS Hospital, Rajahmundry', 'Rajahmundry', 'Andhra Pradesh', '08832477770'),
    -- https://www.kimshospitals.com/vizag-sheela-nagar/contact-us/
    ('KIMS-ICON Hospital, Sheela Nagar', 'Visakhapatnam', 'Andhra Pradesh', '08913536379');

-- Telangana
INSERT INTO odmcs_hospital_seed (Hospital_Name, City, State, Contact_Number)
VALUES
    -- https://www.telangana.gov.in/Contacts/hospitals/
    ('Nizam''s Institute of Medical Sciences', 'Hyderabad', 'Telangana', '04023489999'),
    -- https://www.kimshospitals.com/about-us/contact-us/
    ('KIMS Hospital, Secunderabad', 'Secunderabad', 'Telangana', '04044885000'),
    -- https://www.kimshospitals.com/kondapur/contact-us/
    ('KIMS Hospital, Kondapur', 'Hyderabad', 'Telangana', '04047505050'),
    -- https://prathimaeducation.org/citizen-charter-of-pims/
    ('Prathima Institute of Medical Sciences', 'Karimnagar', 'Telangana', '08782216555'),
    -- https://www.medicoverhospitals.in/hospitals/telangana/warangal/
    ('Medicover Hospitals, Warangal', 'Hanamkonda', 'Telangana', '04068334455');

-- Keep existing IDs and records. A branch is matched by name, city and state.
INSERT INTO Hospital (Hospital_Name, City, State, Contact_Number, Hospital_Tier)
SELECT seed.Hospital_Name, seed.City, seed.State, seed.Contact_Number, NULL
FROM odmcs_hospital_seed AS seed
LEFT JOIN Hospital AS existing
    ON existing.Hospital_Name = seed.Hospital_Name
   AND existing.City = seed.City
   AND existing.State = seed.State
WHERE existing.Hospital_ID IS NULL;

SELECT ROW_COUNT() AS Hospitals_Added;

-- Count only branches from this directory. Expect five for each of five states.
SELECT seed.State, COUNT(*) AS Directory_Hospitals_Present
FROM odmcs_hospital_seed AS seed
WHERE EXISTS (
    SELECT 1
    FROM Hospital AS h
    WHERE h.Hospital_Name = seed.Hospital_Name
      AND h.City = seed.City
      AND h.State = seed.State
)
GROUP BY seed.State
ORDER BY seed.State;

DROP TEMPORARY TABLE odmcs_hospital_seed;
