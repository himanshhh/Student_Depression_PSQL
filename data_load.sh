#!/bin/bash

# Database connection details
DB_NAME="your_database_name"
DB_USER="your_username"
DB_PASSWORD="your_password"
DB_HOST="localhost"
DB_PORT="5432"

# SQL commands
SQL_COMMANDS="
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

\COPY student_wellbeing FROM 'student_depression.csv' DELIMITER ',' CSV HEADER;
"

# Execute SQL commands using psql
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "$SQL_COMMANDS"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Table created and data imported successfully."
else
    echo "Error occurred while creating table or importing data."
fi
