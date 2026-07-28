# Hospital Management System

A console-based Hospital Management System written in Python, backed by a
local SQLite database. It provides a menu-driven interface for managing
patients, doctors, appointments, billing, and ward occupancy in a single
hospital.

## Features

1. **Patient Registration** — add, view all, search by name (partial,
   case-insensitive), update, and delete patient records (id, name, dob,
   phone, blood type, ward).
2. **Doctor Management** — add doctors with a specialisation and assigned
   department, and search doctors by name or department.
3. **Appointment System** — book appointments linking a patient and a doctor
   to a date, time, and reason, and view appointments by date or by patient.
4. **Billing System** — generate a bill for a patient visit, mark bills as
   paid/unpaid, and print a formatted invoice.
5. **Ward Management** — track total vs. occupied beds per ward, admit a
   patient to a ward (failing gracefully when full), discharge a patient,
   and view available beds per ward.

Data is persisted between runs in a local SQLite database file
(`hospital.db`), which is created automatically on first run.

## Setup Instructions

```bash
git clone <your-repository-url>
cd hospital_system
python main.py
```

No external dependencies are required — `sqlite3` is part of the Python
standard library, so `requirements.txt` is intentionally empty.

## Tech Stack

- **Language:** Python 3.12
- **Database:** SQLite3 (via the standard library `sqlite3` module)
- **Design:** Object-Oriented Programming — a `Person` base class with
  `Patient` and `Doctor` subclasses, plus dedicated `*Ops` classes
  (`PatientOps`, `DoctorOps`, `AppointmentOps`, `BillingOps`, `WardOps`)
  encapsulating all database access behind parameterized queries.

## Project Structure

```
hospital_system/
├── main.py                  # Menu loop and user interaction only
├── .gitignore
├── requirements.txt
├── README.md
└── utils/
    ├── __init__.py
    ├── db_manager.py         # HospitalDB: connection + schema creation
    ├── patient_ops.py        # Person, Patient, PatientOps
    ├── doctor_ops.py         # Doctor, DoctorOps
    ├── appointment_ops.py    # Appointment, AppointmentOps
    ├── billing.py            # Bill, BillingOps
    └── ward_ops.py           # Ward, WardOps
```
