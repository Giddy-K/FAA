"""Bill domain class and billing/invoicing database operations."""

import sqlite3
from datetime import date


class Bill:
    """Represents an invoice generated for a patient's visit."""

    def __init__(self, patient_id, amount, paid_status="Unpaid", bill_date=None, bill_id=None):
        """Initialize a Bill with patient, amount and payment details."""
        self.bill_id = bill_id
        self._patient_id = patient_id
        self._amount = amount
        self._paid_status = paid_status
        self._bill_date = bill_date or date.today().isoformat()

    @property
    def amount(self):
        """Return the total amount due on the bill."""
        return self._amount

    @property
    def paid_status(self):
        """Return the current payment status of the bill."""
        return self._paid_status

    def format_invoice(self, patient_name):
        """Return a formatted, human-readable invoice string."""
        lines = [
            "=" * 40,
            "           HOSPITAL INVOICE",
            "=" * 40,
            f"Bill ID:        {self.bill_id}",
            f"Patient:        {patient_name}",
            f"Date:           {self._bill_date}",
            f"Amount Due:     ${self._amount:.2f}",
            f"Payment Status: {self._paid_status}",
            "=" * 40,
        ]
        return "\n".join(lines)


class BillingOps:
    """Encapsulates all database operations related to billing and invoices."""

    def __init__(self, db_manager):
        """Initialize BillingOps with a HospitalDB instance for connectivity."""
        self._db_manager = db_manager

    def generate_bill(self, patient_id, amount):
        """Create a new bill for a patient visit.

        Returns the new bill's id on success, or None on failure.
        """
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute("SELECT 1 FROM patients WHERE id = ?", (patient_id,))
            if cursor.fetchone() is None:
                print(f"No patient found with id {patient_id}.")
                return None
            bill_date = date.today().isoformat()
            cursor.execute(
                "INSERT INTO bills (patient_id, amount, paid_status, date) "
                "VALUES (?, ?, ?, ?)",
                (patient_id, amount, "Unpaid", bill_date),
            )
            connection.commit()
            return cursor.lastrowid
        except sqlite3.IntegrityError as error:
            print(f"Could not generate bill due to a data integrity error: {error}")
        except sqlite3.OperationalError as error:
            print(f"Database error while generating bill: {error}")
        return None

    def mark_as_paid(self, bill_id):
        """Mark a bill as paid. Returns True if a row was updated."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "UPDATE bills SET paid_status = ? WHERE id = ?",
                ("Paid", bill_id),
            )
            connection.commit()
            return cursor.rowcount > 0
        except sqlite3.OperationalError as error:
            print(f"Database error while updating bill status: {error}")
            return False

    def get_bill(self, bill_id):
        """Retrieve a single bill record, joined with the patient's name."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT b.id, p.name, b.amount, b.paid_status, b.date "
                "FROM bills b JOIN patients p ON b.patient_id = p.id "
                "WHERE b.id = ?",
                (bill_id,),
            )
            return cursor.fetchone()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving bill: {error}")
            return None

    def view_bills_by_patient(self, patient_id):
        """Retrieve all bills issued to a specific patient."""
        try:
            connection = self._db_manager.get_connection()
            cursor = connection.cursor()
            cursor.execute(
                "SELECT id, amount, paid_status, date FROM bills WHERE patient_id = ?",
                (patient_id,),
            )
            return cursor.fetchall()
        except sqlite3.OperationalError as error:
            print(f"Database error while retrieving bills: {error}")
            return []

    def print_invoice(self, bill_id):
        """Print a formatted invoice for the given bill id, if it exists."""
        record = self.get_bill(bill_id)
        if record is None:
            print(f"No bill found with id {bill_id}.")
            return
        bill_row_id, patient_name, amount, paid_status, bill_date = record
        bill = Bill(patient_id=None, amount=amount, paid_status=paid_status,
                    bill_date=bill_date, bill_id=bill_row_id)
        print(bill.format_invoice(patient_name))
