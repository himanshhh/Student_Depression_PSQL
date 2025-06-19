#!/usr/bin/env python3

# import the req modules
import pandas as pd
import psycopg2
from psycopg2 import sql

# data frame from CSV
df = pd.read_csv('student_depression.csv')

# print the dataframe
print(df)



# Database connection details (replace with your credentials)
DB_HOST = 'your_host'
DB_NAME = 'your_database_name'
DB_USER = 'your_username'
DB_PASSWORD = 'your_password'

# Path to your CSV file
CSV_FILE_PATH = 'student_depression.csv'

try:
    # Connect to the PostgreSQL database
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    cursor = conn.cursor()

    # Create the table
    create_table_query = """
    CREATE TABLE IF NOT EXISTS student_wellbeing (
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
    """
    cursor.execute(create_table_query)
    print("Table created successfully.")

    # Import CSV data into the table
    copy_csv_query = sql.SQL("""
    COPY student_wellbeing FROM %s DELIMITER ',' CSV HEADER;
    """)
    cursor.execute(copy_csv_query, [CSV_FILE_PATH])
    print("CSV data imported successfully.")

    # Execute and display the queries

    # Query 1: Display all data
    cursor.execute("SELECT * FROM student_wellbeing;")
    data = cursor.fetchall()
    print("All data:")
    for row in data:
        print(row)

    # Query 2: Count students with depression
    cursor.execute("SELECT COUNT(id) FROM student_wellbeing WHERE depression = 't';")
    count_depressed = cursor.fetchone()[0]
    print(f"Number of students with depression: {count_depressed}")

    # Query 3: Count students with academic pressure >= 3 and depression
    cursor.execute(
        """
        SELECT COUNT(id) 
        FROM student_wellbeing 
        WHERE academic_pressure >= 3 AND depression = 't';
        """
    )
    count_academic_pressure = cursor.fetchone()[0]
    print(f"Number of students with depression and academic pressure >= 3: {count_academic_pressure}")

    # Query 4: Count students with healthy sleep schedule and depression
    cursor.execute(
        """
        SELECT COUNT(id) 
        FROM student_wellbeing 
        WHERE sleep_duration = '7-8 hours' AND depression = 't';
        """
    )
    count_healthy_sleep = cursor.fetchone()[0]
    print(f"Number of students with healthy sleep and depression: {count_healthy_sleep}")

    # Update queries

    # Query 5: Update city_name for a student
    cursor.execute(
        """
        UPDATE student_wellbeing 
        SET city_name = 'New Delhi' 
        WHERE id = 2;
        """
    )
    cursor.execute("SELECT * FROM student_wellbeing WHERE id = 2;")
    updated_student = cursor.fetchone()
    print(f"Updated student record: {updated_student}")

    # Query 6: Update incorrect CGPA
    cursor.execute(
        """
        UPDATE student_wellbeing 
        SET cgpa = 8.59 
        WHERE id = 30;
        """
    )
    cursor.execute("SELECT * FROM student_wellbeing WHERE id = 30;")
    corrected_student = cursor.fetchone()
    print(f"Corrected student record: {corrected_student}")

    conn.commit()

except (Exception, psycopg2.DatabaseError) as error:
    print(f"Error: {error}")

finally:
    # Close the database connection
    if conn:
        cursor.close()
        conn.close()
        print("Database connection closed.")
