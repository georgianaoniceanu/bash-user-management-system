# User Management System in Bash

This is a simple Bash script that simulates a basic user registration, login, and reporting system. It stores user data in a CSV file and creates a home directory for each registered user.

## File Structure

- `utilizatori.csv` – Stores user data (`ID`, `Name`, `Email`, `Password`, `Last_Login`)
- `home/` – Directory created for each registered user
- `report.txt` – Generated per user with file and directory statistics

## Features

### 1. Registration (`inregistrare`)
- Prompts for username, password (with validation), and email (must end with `@student.ro`)
- Validates if the username already exists
- Creates a `home/username/` directory
- Appends the user to `utilizatori.csv` with a unique ID

### 2. Authentication (`autentificare_user`)
- Verifies credentials against the CSV file
- Updates the `Last_Login` field with the current timestamp
- Adds the user to the `logged_in_users` array
- Changes the current working directory to the user's home

### 3. Logout (`delogare_user`)
- Removes the user from the `logged_in_users` array

### 4. Report (`raport`)
- Generates a `report.txt` file in the user’s `home/` folder
- Includes:
  - Number of files
  - Number of directories
  - Total disk usage

## CSV File Format

Example content of `utilizatori.csv`:
ID,Nume,E-mail,Parola,Last_Login
1001,georgiana,georgiana@student.ro,Parola123,2025.08.04 13:12:50

## How to Run
`chmod +x script.sh`

`./script.sh`

Make sure you run the script in a Linux terminal with Bash installed.

## Notes
Passwords are stored in plain text – use only in educational or demo environments.

Email must end with @student.ro

The logged_in_users array exists only during runtime (not persistent)

## Possible Improvements
Store hashed passwords using sha256sum or similar

Add support for command-line arguments (e.g., --register, --login)

Save logged-in users to a temporary file for persistence

Add admin mode to list all registered users
