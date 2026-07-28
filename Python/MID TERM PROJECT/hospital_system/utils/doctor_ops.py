"""Doctor domain classes and database operations."""

import sqlite3

from utils.patient_ops import Person


class Doctor(Person):
    """Represents a hospital doctor, extending Person with professional details."""

    def __init__(self, name, phone, specialisation, department, doctor_id=None):
        """Initialize a Doctor with personal and professional information."""
        super().__init__(name, phone)
        self.doctor_id = doctor_id
        self._specialisation = specialisation
        self._department = department

    @property
    def specialisation(self):
        """Return the doctor's medical specialisation."""
        return self._specialisation

    @property
    def department(self):
        """Return the department the doctor is assigned to."""
        return self._department

    def summary(self):
        """Return a one-line human-readable summary of the doctor record."""
        return (f"[{self.doctor_id}] Dr. {self.name} | {self._specialisation} | "
                f"Dept: {self._department} | Phone: {self.phone}")


class DoctorOps:
    """Encapsulates all database operations related to doctor records."""

    def __init__(self, db_manager):
        """Initialize DoctorOps with a HospitalDB instance for connectivity."""
        self._db_manager = db_manager

    def add_doctor(self, name, phone, specialisation, department):
        """Insert a new doctor record.

        Returns the new doctor's id on success, or None on failure.
        """
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "INSERT INTO doctors (name, phone, specialisation, department) "
                "VALUES (?, ?, ?, ?)",
                (name, phone, specialisation, department),
            )
            connection.commit()
            return cursor.lastrowid
        except sqlite3.IntegrityError as error:
            print(f"Could not add doctor due to a data integrity error: {error}")
        except sqlite3.OperationalError as error:
            print(f"Database error while adding doctor: {error}")
        return None

    def view_all_doctors(self):
        """Retrieve and return a list of all doctor records."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute("SELECT id, name, phone, specialisation, department FROM doctors")
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving doctors: {error}")
            return []

    def search_by_name(self, name_query):
        """Search for doctors whose name partially matches name_query (case-insensitive)."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT id, name, phone, specialisation, department FROM doctors "
                "WHERE LOWER(name) LIKE ?",
                (f"%{name_query.lower()}%",),
            )
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while searching doctors: {error}")
            return []

    def search_by_department(self, department_query):
        """Search for doctors whose department partially matches department_query."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT id, name, phone, specialisation, department FROM doctors "
                "WHERE LOWER(department) LIKE ?",
                (f"%{department_query.lower()}%",),
            )
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while searching doctors by department: {error}")
            return []
