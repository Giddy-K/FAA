"""Appointment domain class and database operations."""

import sqlite3


class Appointment:
    """Represents a single scheduled appointment between a patient and a doctor."""

    def __init__(self, patient_id, doctor_id, date, time, reason,
                 status="Scheduled", appointment_id=None):
        """Initialize an Appointment with scheduling details."""
        self.appointment_id = appointment_id
        self._patient_id = patient_id
        self._doctor_id = doctor_id
        self._date = date
        self._time = time
        self._reason = reason
        self._status = status

    @property
    def patient_id(self):
        """Return the id of the patient for this appointment."""
        return self._patient_id

    @property
    def doctor_id(self):
        """Return the id of the doctor for this appointment."""
        return self._doctor_id

    @property
    def status(self):
        """Return the current status of the appointment."""
        return self._status

    def summary(self):
        """Return a one-line human-readable summary of the appointment."""
        return (f"[{self.appointment_id}] Patient {self._patient_id} with Doctor "
                f"{self._doctor_id} on {self._date} {self._time} | "
                f"Reason: {self._reason} | Status: {self._status}")


class AppointmentOps:
    """Encapsulates all database operations related to appointment booking and viewing."""

    def __init__(self, db_manager):
        """Initialize AppointmentOps with a HospitalDB instance for connectivity."""
        self._db_manager = db_manager

    def _patient_exists(self, patient_id):
        """Return True if a patient with the given id exists."""
        connection = self._db_manager.get_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT 1 FROM patients WHERE id = ?", (patient_id,))
        return cursor.fetchone() is not None

    def _doctor_exists(self, doctor_id):
        """Return True if a doctor with the given id exists."""
        connection = self._db_manager.get_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT 1 FROM doctors WHERE id = ?", (doctor_id,))
        return cursor.fetchone() is not None

    def book_appointment(self, patient_id, doctor_id, date, time, reason):
        """Book a new appointment for an existing patient and doctor.

        Returns the new appointment's id on success, or None on failure
        (including when the referenced patient or doctor does not exist).
        """
        try:
            if not self._patient_exists(patient_id):
                print(f"No patient found with id {patient_id}.")
                return None
            if not self._doctor_exists(doctor_id):
                print(f"No doctor found with id {doctor_id}.")
                return None
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "INSERT INTO appointments (patient_id, doctor_id, date, time, reason, status) "
                "VALUES (?, ?, ?, ?, ?, ?)",
                (patient_id, doctor_id, date, time, reason, "Scheduled"),
            )
            connection.commit()
            return cursor.lastrowid
        except sqlite3.IntegrityError as error:
            print(f"Could not book appointment due to a data integrity error: {error}")
        except sqlite3.OperationalError as error:
            print(f"Database error while booking appointment: {error}")
        return None

    def view_by_date(self, date):
        """Retrieve all appointments scheduled on a given date."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT a.id, p.name, d.name, a.date, a.time, a.reason, a.status "
                "FROM appointments a "
                "JOIN patients p ON a.patient_id = p.id "
                "JOIN doctors d ON a.doctor_id = d.id "
                "WHERE a.date = ?",
                (date,),
            )
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving appointments by date: {error}")
            return []

    def view_by_patient(self, patient_id):
        """Retrieve all appointments booked for a specific patient id."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT a.id, d.name, a.date, a.time, a.reason, a.status "
                "FROM appointments a "
                "JOIN doctors d ON a.doctor_id = d.id "
                "WHERE a.patient_id = ?",
                (patient_id,),
            )
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving appointments by patient: {error}")
            return []

    def update_status(self, appointment_id, status):
        """Update the status of an appointment (e.g. Completed, Cancelled)."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "UPDATE appointments SET status = ? WHERE id = ?",
                (status, appointment_id),
            )
            connection.commit()
            return cursor.rowcount > 0
        except sqlite3.OperationalError as error:
            print(f"Database error while updating appointment status: {error}")
            return False
