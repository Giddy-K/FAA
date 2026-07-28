"""Patient domain classes and database operations."""

import sqlite3


class Person:
    """Base class representing a person with a name and phone contact."""

    def __init__(self, name, phone):
        """Initialize a Person with a name and phone number."""
        self._name = name
        self._phone = phone

    @property
    def name(self):
        """Return the person's full name."""
        return self._name

    @property
    def phone(self):
        """Return the person's phone number."""
        return self._phone

    def get_contact_info(self):
        """Return a formatted string of the person's contact details."""
        return f"{self._name} - {self._phone}"


class Patient(Person):
    """Represents a hospital patient, extending Person with medical details."""

    def __init__(self, name, phone, dob, blood_type, ward=None, patient_id=None):
        """Initialize a Patient with personal and medical information."""
        super().__init__(name, phone)
        self.patient_id = patient_id
        self._dob = dob
        self._blood_type = blood_type
        self._ward = ward

    @property
    def dob(self):
        """Return the patient's date of birth."""
        return self._dob

    @property
    def blood_type(self):
        """Return the patient's blood type."""
        return self._blood_type

    @property
    def ward(self):
        """Return the ward currently assigned to the patient, if any."""
        return self._ward

    def summary(self):
        """Return a one-line human-readable summary of the patient record."""
        return (f"[{self.patient_id}] {self.name} | DOB: {self._dob} | "
                f"Phone: {self.phone} | Blood: {self._blood_type} | Ward: {self._ward}")


class PatientOps:
    """Encapsulates all database operations related to patient records."""

    def __init__(self, db_manager):
        """Initialize PatientOps with a HospitalDB instance for connectivity."""
        self._db_manager = db_manager

    def add_patient(self, name, dob, phone, blood_type, ward):
        """Insert a new patient record.

        Returns the new patient's id on success, or None on failure.
        """
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "INSERT INTO patients (name, dob, phone, blood_type, ward) "
                "VALUES (?, ?, ?, ?, ?)",
                (name, dob, phone, blood_type, ward),
            )
            connection.commit()
            return cursor.lastrowid
        except sqlite3.IntegrityError as error:
            print(f"Could not add patient due to a data integrity error: {error}")
        except sqlite3.OperationalError as error:
            print(f"Database error while adding patient: {error}")
        return None

    def view_all_patients(self):
        """Retrieve and return a list of all patient records."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute("SELECT id, name, dob, phone, blood_type, ward FROM patients")
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving patients: {error}")
            return []

    def search_patient_by_name(self, name_query):
        """Search for patients whose name partially matches name_query (case-insensitive)."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT id, name, dob, phone, blood_type, ward FROM patients "
                "WHERE LOWER(name) LIKE ?",
                (f"%{name_query.lower()}%",),
            )
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while searching patients: {error}")
            return []

    def update_patient(self, patient_id, name, dob, phone, blood_type, ward):
        """Update an existing patient record. Returns True if a row was updated."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "UPDATE patients SET name = ?, dob = ?, phone = ?, blood_type = ?, ward = ? "
                "WHERE id = ?",
                (name, dob, phone, blood_type, ward, patient_id),
            )
            connection.commit()
            return cursor.rowcount > 0
        except sqlite3.IntegrityError as error:
            print(f"Could not update patient due to a data integrity error: {error}")
        except sqlite3.OperationalError as error:
            print(f"Database error while updating patient: {error}")
        return False

    def delete_patient(self, patient_id):
        """Delete a patient record by id. Returns True if a row was deleted."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute("DELETE FROM patients WHERE id = ?", (patient_id,))
            connection.commit()
            return cursor.rowcount > 0
        except sqlite3.OperationalError as error:
            print(f"Database error while deleting patient: {error}")
            return False
