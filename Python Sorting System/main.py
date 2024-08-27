import os
import pyodbc

directory_path = input("Enter the directory path: ")

# List directory contents
folder_names = os.listdir(directory_path)

# Connect to the database
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=Halvor.ibc.dk;'
    'DATABASE=onboarding_db;'
    'Trusted_Connection=yes;'
)
cursor = conn.cursor()

# Execute SQL query
cursor.execute("SELECT * FROM [onboarding_db].[dbo].[FileUpload] Where Path like 'App_Data/Uploads/%' and Deleted = '0'")
results = cursor.fetchall()

# Check for matches
matches = [folder for folder in folder_names if folder in [row[0] for row in results]]

# Output results
if matches:
    print("Matching folders found:", matches)
else:
    print("No matching folders found.")

# Close the database connection
conn.close()