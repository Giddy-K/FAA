"""
Persistent Student Logger

A file-based student logger that saves records permanently between
program runs, using a JSON file as storage.

Lab tasks covered:
  - Data persists between runs (loaded from / saved to students.json)
  - search_by_name()
  - delete_student()
"""

import json
import os

DATA_FILE = "students.json"


def load_students():
    """Load student records from the JSON file. Returns an empty dict
    if the file doesn't exist yet (first run)."""
    if not os.path.exists(DATA_FILE):
        return {}

    try:
        with open(DATA_FILE, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError):
        print("Warning: could not read existing data file. Starting fresh.")
        return {}


def save_students(students):
    """Save the current student records dict to the JSON file."""
    with open(DATA_FILE, "w") as f:
        json.dump(students, f, indent=2)


def add_student(students):
    """Prompt for a new student and add them to the records."""
    name = input("Enter student name: ").strip()

    if not name:
        print("Student name cannot be empty.\n")
        return

    if find_exact_student(students, name) is not None:
        print(f"'{name}' already exists.\n")
        return

    admission_no = input("Enter admission number: ").strip()
    course = input("Enter course: ").strip()

    students[name] = {"admission_no": admission_no, "course": course}
    save_students(students)
    print(f"'{name}' added and saved.\n")


def view_all_students(students):
    """Display all logged students in a formatted table."""
    if not students:
        print("No student records found.\n")
        return

    print("\n" + "=" * 60)
    print(f"{'Name':<25}{'Admission No.':<18}{'Course':<17}")
    print("-" * 60)
    for name, details in students.items():
        print(f"{name:<25}{details.get('admission_no', ''):<18}{details.get('course', ''):<17}")
    print("=" * 60 + "\n")


def find_exact_student(students, name):
    """Case-insensitive exact lookup. Returns the actual key stored, or None."""
    for key in students:
        if key.lower() == name.lower():
            return key
    return None


def search_by_name(students):
    """Search for students by name (case-insensitive, partial match)."""
    query = input("Enter name to search: ").strip().lower()

    if not query:
        print("Search term cannot be empty.\n")
        return

    matches = {name: details for name, details in students.items() if query in name.lower()}

    if not matches:
        print(f"No students matching '{query}' found.\n")
        return

    print(f"\nFound {len(matches)} match(es):")
    print("-" * 60)
    for name, details in matches.items():
        print(f"{name:<25}{details.get('admission_no', ''):<18}{details.get('course', ''):<17}")
    print()


def delete_student(students):
    """Delete a student record by name, after confirmation, and save."""
    name = input("Enter student name to delete: ").strip()
    actual_key = find_exact_student(students, name)

    if actual_key is None:
        print(f"'{name}' not found.\n")
        return

    confirm = input(f"Are you sure you want to delete '{actual_key}'? (y/n): ").strip().lower()
    if confirm == "y":
        del students[actual_key]
        save_students(students)
        print(f"'{actual_key}' deleted and saved.\n")
    else:
        print("Deletion cancelled.\n")


def print_menu():
    print("=" * 40)
    print("     PERSISTENT STUDENT LOGGER")
    print("=" * 40)
    print("1. Add student")
    print("2. View all students")
    print("3. Search by name")
    print("4. Delete student")
    print("5. Exit")
    print("=" * 40)


def main():
    students = load_students()
    print(f"Loaded {len(students)} existing student record(s) from {DATA_FILE}.\n")

    while True:
        print_menu()
        choice = input("Select an option (1-5): ").strip()

        if choice == "1":
            add_student(students)
        elif choice == "2":
            view_all_students(students)
        elif choice == "3":
            search_by_name(students)
        elif choice == "4":
            delete_student(students)
        elif choice == "5":
            print("Exiting. All changes have been saved. Goodbye!")
            break
        else:
            print("Invalid option. Please select 1-5.\n")


if __name__ == "__main__":
    main()
