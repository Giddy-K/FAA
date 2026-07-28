"""Database connection and schema management for the Hospital Management System."""

import sqlite3


class HospitalDB:
    """Manages the SQLite connection and schema for the hospital database."""

    def __init__(self, db_name="hospital.db"):
        """Initialize the database manager and create tables if they do not exist."""
        self.db_name = db_name
        self._connection = None
        self._create_tables()

    def get_connection(self):
        """Return a live sqlite3 connection, creating one on first use."""
        if self._connection is None:
            self._connection = sqlite3.connect(self.db_name)
            self._connection.execute("PRAGMA foreign_keys = ON")
        return self._connection

    def _create_tables(self):
        """Create all required tables if they do not already exist."""
        connection = self.get_connection()
        cursor = connection.cursor()

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS patients (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                dob TEXT,
                phone TEXT,
                blood_type TEXT,
                ward TEXT
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS doctors (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                phone TEXT,
                specialisation TEXT,
                department TEXT
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS appointments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                patient_id INTEGER NOT NULL,
                doctor_id INTEGER NOT NULL,
                date TEXT NOT NULL,
                time TEXT NOT NULL,
                reason TEXT,
                status TEXT DEFAULT 'Scheduled',
                FOREIGN KEY (patient_id) REFERENCES patients (id),
                FOREIGN KEY (doctor_id) REFERENCES doctors (id)
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS bills (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                patient_id INTEGER NOT NULL,
                amount REAL NOT NULL,
                paid_status TEXT DEFAULT 'Unpaid',
                date TEXT NOT NULL,
                FOREIGN KEY (patient_id) REFERENCES patients (id)
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS wards (
                ward_name TEXT PRIMARY KEY,
                total_beds INTEGER NOT NULL,
                occupied_beds INTEGER NOT NULL DEFAULT 0
            )
        """)

        connection.commit()

    def close(self):
        """Close the database connection if one is open."""
        if self._connection is not None:
            self._connection.close()
            self._connection = None
