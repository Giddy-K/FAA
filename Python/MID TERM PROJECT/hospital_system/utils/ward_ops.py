"""Ward domain class and ward occupancy database operations."""

import sqlite3


class Ward:
    """Represents a hospital ward and its bed occupancy."""

    def __init__(self, ward_name, total_beds, occupied_beds=0):
        """Initialize a Ward with its name and bed capacity."""
        self._ward_name = ward_name
        self._total_beds = total_beds
        self._occupied_beds = occupied_beds

    @property
    def ward_name(self):
        """Return the name of the ward."""
        return self._ward_name

    @property
    def available_beds(self):
        """Return the number of beds currently available in the ward."""
        return self._total_beds - self._occupied_beds

    def summary(self):
        """Return a one-line human-readable summary of ward occupancy."""
        return (f"{self._ward_name}: {self._occupied_beds}/{self._total_beds} occupied "
                f"({self.available_beds} available)")


class WardOps:
    """Encapsulates all database operations related to ward occupancy management."""

    def __init__(self, db_manager):
        """Initialize WardOps with a HospitalDB instance for connectivity."""
        self._db_manager = db_manager

    def add_ward(self, ward_name, total_beds):
        """Register a new ward with a given bed capacity."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "INSERT INTO wards (ward_name, total_beds, occupied_beds) VALUES (?, ?, 0)",
                (ward_name, total_beds),
            )
            connection.commit()
            return True
        except sqlite3.IntegrityError as error:
            print(f"Could not add ward due to a data integrity error: {error}")
        except sqlite3.OperationalError as error:
            print(f"Database error while adding ward: {error}")
        return False

    def view_wards(self):
        """Retrieve occupancy details for all wards."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute("SELECT ward_name, total_beds, occupied_beds FROM wards")
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving wards: {error}")
            return []

    def admit_patient(self, ward_name, patient_id):
        """Admit a patient to a ward, incrementing occupancy.

        Fails gracefully if the ward is full or does not exist.
        """
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT total_beds, occupied_beds FROM wards WHERE ward_name = ?",
                (ward_name,),
            )
            row = cursor.fetchone()
            if row is None:
                print(f"No ward found named '{ward_name}'.")
                return False
            total_beds, occupied_beds = row
            if occupied_beds >= total_beds:
                print(f"Ward '{ward_name}' is full. Cannot admit patient.")
                return False
            cursor.execute(
                "UPDATE wards SET occupied_beds = occupied_beds + 1 WHERE ward_name = ?",
                (ward_name,),
            )
            cursor.execute(
                "UPDATE patients SET ward = ? WHERE id = ?",
                (ward_name, patient_id),
            )
            connection.commit()
            return True
        except sqlite3.OperationalError as error:
            print(f"Database error while admitting patient: {error}")
            return False

    def discharge_patient(self, ward_name, patient_id):
        """Discharge a patient from a ward, decrementing occupancy."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT occupied_beds FROM wards WHERE ward_name = ?",
                (ward_name,),
            )
            row = cursor.fetchone()
            if row is None:
                print(f"No ward found named '{ward_name}'.")
                return False
            occupied_beds = row[0]
            if occupied_beds <= 0:
                print(f"Ward '{ward_name}' already has no occupied beds.")
                return False
            cursor.execute(
                "UPDATE wards SET occupied_beds = occupied_beds - 1 WHERE ward_name = ?",
                (ward_name,),
            )
            cursor.execute(
                "UPDATE patients SET ward = NULL WHERE id = ?",
                (patient_id,),
            )
            connection.commit()
            return True
        except sqlite3.OperationalError as error:
            print(f"Database error while discharging patient: {error}")
            return False

    def available_beds(self, ward_name):
        """Return the number of available beds in a specific ward, or None if not found."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT total_beds, occupied_beds FROM wards WHERE ward_name = ?",
                (ward_name,),
            )
            row = cursor.fetchone()
            if row is None:
                return None
            total_beds, occupied_beds = row
            return total_beds - occupied_beds
        except sqlite3.OperationalError as error:
            print(f"Database error while checking available beds: {error}")
            return None
