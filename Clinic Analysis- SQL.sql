CREATE TABLE patients(
patient_id INT,
first_name VARCHAR,
last_name VARCHAR,
gender CHAR (1),
date_of_birth DATE,
city VARCHAR,
insurance_provider VARCHAR
);

CREATE TABLE medications(
med_id INT,
patient_id	INT,
medication_name	VARCHAR,
dosage	VARCHAR,
start_date	DATE,
end_date DATE
);

CREATE TABLE doctors(
doctor_id INT,	
doctor_name	VARCHAR,
specialty 	VARCHAR,
clinic_location VARCHAR
);

CREATE TABLE diagnoses(
diagnosis_id	INT,
appointment_id	INT,
diagnosis_code	VARCHAR,
diagnosis_description CHAR
);

CREATE TABLE billing(
bill_id	INT,
appointment_id	INT,
amount	BIGINT,
insurance_covered INT,	
patient_paid INT
);

CREATE TABLE appointments(
appointment_id	INT,
patient_id	INT,
doctor_id	INT,
appointment_date	DATE,
status	VARCHAR,
visit_reason VARCHAR
);
SELECT* FROM medications
SELECT* FROM doctors
SELECT* FROM patients
SELECT* FROM billing
SELECT* FROM appointments
SELECT* FROM diagnoses
SELECT DISTINCT doctor_id FROM doctors
SELECT DISTINCT patient_id FROM patients
SELECT DISTINCT med_id FROM medications
SELECT COUNT(specialty) FROM doctors
WHERE specialty ='Endocrinology'
/* 1. Identify patients whose insurance covered less than 70% of their bill*/
WITH insurance_bill_percent AS(
SELECT (patient_paid/insurance_covered)* 100  AS insurance_percent 
FROM billing
ORDER BY insurance_percent DESC
)

SELECT CONCAT(P.first_name,'',P.last_name) AS full_name,
B.amount,B.insurance_covered 
FROM patients P
JOIN appointments A
ON P.patient_id = A.patient_id
JOIN billing B
ON B.appointment_id = A.appointment_id
WHERE B.amount >0 AND (B.insurance_covered/B.amount) * 100<70;
/*12. Identify all diabetic patients and list their last medication renewal date*/
SELECT CONCAT(P.first_name,'',P.last_name) AS full_name,
D.specialty AS Diabetic_patients,M.end_date AS med_renewal_day
FROM patients P
JOIN medications M
ON P.patient_id = M.patient_id
JOIN doctors D
ON D.doctor_id = M.med_id
WHERE D.specialty ='Endocrinology'
ORDER BY med_renewal_day ASC

/*Which doctor has the lowest no‑show rate?*/
SELECT D.doctor_name,
COUNT(A.status) AS no_show_rate 
FROM doctors D
JOIN appointments A
ON D.doctor_id = A.doctor_id
WHERE A.status ='No-show'
GROUP BY D.doctor_name
ORDER BY no_show_rate ASC
