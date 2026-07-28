"""Hospital Management System console application entry point.

This module only contains the menu loop and user-input dispatch.
All business logic lives in the utils package.
"""

from utils.db_manager import HospitalDB
from utils.patient_ops import PatientOps
from utils.doctor_ops import DoctorOps
from utils.appointment_ops import AppointmentOps
from utils.billing import BillingOps
from utils.ward_ops import WardOps


def print_main_menu():
    """Display the top-level menu options."""
    print("\n===== HOSPITAL MANAGEMENT SYSTEM =====")
    print("1. Patient Registration")
    print("2. Doctor Management")
    print("3. Appointment System")
    print("4. Billing System")
    print("5. Ward Management")
    print("6. Exit")


def patient_menu(patient_ops):
    """Display and handle the patient registration submenu."""
    while True:
        print("\n--- Patient Registration ---")
        print("1. Add patient")
        print("2. View all patients")
        print("3. Search patient by name")
        print("4. Update patient")
        print("5. Delete patient")
        print("6. Back to main menu")
        choice = input("Choose an option: ").strip()

        try:
            if choice == "1":
                name = input("Name: ").strip()
                dob = input("Date of birth (YYYY-MM-DD): ").strip()
                phone = input("Phone: ").strip()
                blood_type = input("Blood type: ").strip()
                ward = input("Ward (leave blank if none): ").strip() or None
                new_id = patient_ops.add_patient(name, dob, phone, blood_type, ward)
                if new_id is not None:
                    print(f"Patient added with id {new_id}.")
            elif choice == "2":
                records = patient_ops.view_all_patients()
                if not records:
                    print("No patients found.")
                for record in records:
                    print(record)
            elif choice == "3":
                name_query = input("Name to search: ").strip()
                results = patient_ops.search_patient_by_name(name_query)
                if not results:
                    print("No matching patients found.")
                for record in results:
                    print(record)
            elif choice == "4":
                patient_id = int(input("Patient id to update: ").strip())
                name = input("New name: ").strip()
                dob = input("New date of birth: ").strip()
                phone = input("New phone: ").strip()
                blood_type = input("New blood type: ").strip()
                ward = input("New ward (leave blank if none): ").strip() or None
                if patient_ops.update_patient(patient_id, name, dob, phone, blood_type, ward):
                    print("Patient updated successfully.")
                else:
                    print("No patient found with that id.")
            elif choice == "5":
                patient_id = int(input("Patient id to delete: ").strip())
                if patient_ops.delete_patient(patient_id):
                    print("Patient deleted successfully.")
                else:
                    print("No patient found with that id.")
            elif choice == "6":
                break
            else:
                print("Invalid option. Please try again.")
        except ValueError as error:
            print(f"Invalid input: {error}")


def doctor_menu(doctor_ops):
    """Display and handle the doctor management submenu."""
    while True:
        print("\n--- Doctor Management ---")
        print("1. Add doctor")
        print("2. View all doctors")
        print("3. Search doctor by name")
        print("4. Search doctor by department")
        print("5. Back to main menu")
        choice = input("Choose an option: ").strip()

        try:
            if choice == "1":
                name = input("Name: ").strip()
                phone = input("Phone: ").strip()
                specialisation = input("Specialisation: ").strip()
                department = input("Department: ").strip()
                new_id = doctor_ops.add_doctor(name, phone, specialisation, department)
                if new_id is not None:
                    print(f"Doctor added with id {new_id}.")
            elif choice == "2":
                records = doctor_ops.view_all_doctors()
                if not records:
                    print("No doctors found.")
                for record in records:
                    print(record)
            elif choice == "3":
                name_query = input("Name to search: ").strip()
                results = doctor_ops.search_by_name(name_query)
                if not results:
                    print("No matching doctors found.")
                for record in results:
                    print(record)
            elif choice == "4":
                department_query = input("Department to search: ").strip()
                results = doctor_ops.search_by_department(department_query)
                if not results:
                    print("No matching doctors found.")
                for record in results:
                    print(record)
            elif choice == "5":
                break
            else:
                print("Invalid option. Please try again.")
        except ValueError as error:
            print(f"Invalid input: {error}")


def appointment_menu(appointment_ops):
    """Display and handle the appointment system submenu."""
    while True:
        print("\n--- Appointment System ---")
        print("1. Book appointment")
        print("2. View appointments by date")
        print("3. View appointments by patient")
        print("4. Update appointment status")
        print("5. Back to main menu")
        choice = input("Choose an option: ").strip()

        try:
            if choice == "1":
                patient_id = int(input("Patient id: ").strip())
                doctor_id = int(input("Doctor id: ").strip())
                appointment_date = input("Date (YYYY-MM-DD): ").strip()
                appointment_time = input("Time (HH:MM): ").strip()
                reason = input("Reason: ").strip()
                new_id = appointment_ops.book_appointment(
                    patient_id, doctor_id, appointment_date, appointment_time, reason
                )
                if new_id is not None:
                    print(f"Appointment booked with id {new_id}.")
            elif choice == "2":
                appointment_date = input("Date to search (YYYY-MM-DD): ").strip()
                results = appointment_ops.view_by_date(appointment_date)
                if not results:
                    print("No appointments found for that date.")
                for record in results:
                    print(record)
            elif choice == "3":
                patient_id = int(input("Patient id: ").strip())
                results = appointment_ops.view_by_patient(patient_id)
                if not results:
                    print("No appointments found for that patient.")
                for record in results:
                    print(record)
            elif choice == "4":
                appointment_id = int(input("Appointment id: ").strip())
                status = input("New status (Scheduled/Completed/Cancelled): ").strip()
                if appointment_ops.update_status(appointment_id, status):
                    print("Appointment status updated.")
                else:
                    print("No appointment found with that id.")
            elif choice == "5":
                break
            else:
                print("Invalid option. Please try again.")
        except ValueError as error:
            print(f"Invalid input: {error}")


def billing_menu(billing_ops):
    """Display and handle the billing system submenu."""
    while True:
        print("\n--- Billing System ---")
        print("1. Generate bill")
        print("2. Mark bill as paid")
        print("3. View bills for a patient")
        print("4. Print invoice")
        print("5. Back to main menu")
        choice = input("Choose an option: ").strip()

        try:
            if choice == "1":
                patient_id = int(input("Patient id: ").strip())
                amount = float(input("Amount: ").strip())
                new_id = billing_ops.generate_bill(patient_id, amount)
                if new_id is not None:
                    print(f"Bill generated with id {new_id}.")
            elif choice == "2":
                bill_id = int(input("Bill id to mark as paid: ").strip())
                if billing_ops.mark_as_paid(bill_id):
                    print("Bill marked as paid.")
                else:
                    print("No bill found with that id.")
            elif choice == "3":
                patient_id = int(input("Patient id: ").strip())
                results = billing_ops.view_bills_by_patient(patient_id)
                if not results:
                    print("No bills found for that patient.")
                for record in results:
                    print(record)
            elif choice == "4":
                bill_id = int(input("Bill id: ").strip())
                billing_ops.print_invoice(bill_id)
            elif choice == "5":
                break
            else:
                print("Invalid option. Please try again.")
        except ValueError as error:
            print(f"Invalid input: {error}")


def ward_menu(ward_ops):
    """Display and handle the ward management submenu."""
    while True:
        print("\n--- Ward Management ---")
        print("1. Add ward")
        print("2. View all wards")
        print("3. Admit patient to ward")
        print("4. Discharge patient from ward")
        print("5. View available beds in a ward")
        print("6. Back to main menu")
        choice = input("Choose an option: ").strip()

        try:
            if choice == "1":
                ward_name = input("Ward name: ").strip()
                total_beds = int(input("Total beds: ").strip())
                if ward_ops.add_ward(ward_name, total_beds):
                    print("Ward added successfully.")
            elif choice == "2":
                records = ward_ops.view_wards()
                if not records:
                    print("No wards found.")
                for record in records:
                    print(record)
            elif choice == "3":
                ward_name = input("Ward name: ").strip()
                patient_id = int(input("Patient id: ").strip())
                if ward_ops.admit_patient(ward_name, patient_id):
                    print("Patient admitted successfully.")
            elif choice == "4":
                ward_name = input("Ward name: ").strip()
                patient_id = int(input("Patient id: ").strip())
                if ward_ops.discharge_patient(ward_name, patient_id):
                    print("Patient discharged successfully.")
            elif choice == "5":
                ward_name = input("Ward name: ").strip()
                available = ward_ops.available_beds(ward_name)
                if available is None:
                    print(f"No ward found named '{ward_name}'.")
                else:
                    print(f"Available beds in '{ward_name}': {available}")
            elif choice == "6":
                break
            else:
                print("Invalid option. Please try again.")
        except ValueError as error:
            print(f"Invalid input: {error}")


def main():
    """Run the hospital management system's main menu loop."""
    db_manager = HospitalDB()
    patient_ops = PatientOps(db_manager)
    doctor_ops = DoctorOps(db_manager)
    appointment_ops = AppointmentOps(db_manager)
    billing_ops = BillingOps(db_manager)
    ward_ops = WardOps(db_manager)

    try:
        while True:
            print_main_menu()
            choice = input("Choose an option: ").strip()

            if choice == "1":
                patient_menu(patient_ops)
            elif choice == "2":
                doctor_menu(doctor_ops)
            elif choice == "3":
                appointment_menu(appointment_ops)
            elif choice == "4":
                billing_menu(billing_ops)
            elif choice == "5":
                ward_menu(ward_ops)
            elif choice == "6":
                print("Goodbye.")
                break
            else:
                print("Invalid option. Please try again.")
    finally:
        db_manager.close()


if __name__ == "__main__":
    main()
