-- Drop database and tables if already exist
DROP DATABASE IF EXISTS wellbeing;
DROP TABLE IF EXISTS student_wellbeing, student, city, academic_info, mental_health;

-- Create database
CREATE DATABASE wellbeing;

-- Switch to the database
\c wellbeing;

CREATE TABLE student_wellbeing (
    id SERIAL PRIMARY KEY,
	gender VARCHAR(10) NOT NULL,
    age INT CHECK (age > 0),
    city_name VARCHAR(100) NOT NULL,
	academic_pressure SMALLINT,
	cgpa NUMERIC(4, 2),
	sleep_duration VARCHAR(50),
	suicidal_thoughts VARCHAR(10),
	work_study_hours SMALLINT,
	depression BOOLEAN NOT NULL
);

--Import CSV data into the table
\COPY student_wellbeing FROM 'student_depression.csv' DELIMITER ',' CSV HEADER;

--Query to display the data
select * from student_wellbeing;

--Query to count the number of students with depression
select count(id) from student_wellbeing where depression = 't';

--Query to count the number of students with depression who have academic pressure equal or more than 3
select count(id) from student_wellbeing where academic_pressure <= 3 and depression = 't';

--Query to count the number of students with depression who have a healthy sleeping schedule (7-8 hours)
select count(id) from student_wellbeing where sleep_duration = '7-8 hours' and depression = 't';

--A student has moved their address to New Delhi
update student_wellbeing set city_name = 'New Delhi' where id = 2;
select * from student_wellbeing where id =2;

-- Student with id 30 had their cgpa recorded incorrectly as 5.59 instead of 8.59
update student_wellbeing set cgpa = 8.59 where id = 30;
select * from student_wellbeing where id =30;

--To convert above table into 3NF form:

-- Table: city
CREATE TABLE city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL
);

-- Table: student
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    gender VARCHAR(10) NOT NULL,
    age INT CHECK (age > 0),
    city_id INT REFERENCES city(city_id)
);

-- Table: academic_info
CREATE TABLE academic_info (
    id INT PRIMARY KEY REFERENCES student(id),
    academic_pressure SMALLINT,
    cgpa NUMERIC(4, 2),
    work_study_hours SMALLINT
);

-- Table: mental_health
CREATE TABLE mental_health (
    id INT PRIMARY KEY REFERENCES student(id),
    sleep_duration VARCHAR(50),
    suicidal_thoughts VARCHAR(10),
    depression BOOLEAN NOT NULL
);
