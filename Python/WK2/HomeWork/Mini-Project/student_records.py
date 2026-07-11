"""
Student Record Management System

A dict-based console application supporting:
  1. Add Student Record
  2. View All Students
  3. Search Student by Name
  4. Update Student Marks
  5. Delete Student Record
  6. Display Class Statistics
  7. Exit

Data model:
  students = {
      "student_name": {"admission_no": str, "marks": float},
      ...
  }
"""


def add_student(students):
    """Prompt for a new student's details and add them to the records."""
    name = input("Enter student name: ").strip()

    if not name:
        print("Student name cannot be empty.\n")
        return

    if find_exact_student(students, name) is not None:
        print(f"'{name}' already exists. Use the update option instead.\n")
        return

    admission_no = input("Enter admission number: ").strip()
    if not admission_no:
        print("Admission number cannot be empty.\n")
        return

    marks = get_valid_marks("Enter marks (0-100): ")
    if marks is None:
        return

    students[name] = {"admission_no": admission_no, "marks": marks}
    print(f"'{name}' added successfully.\n")


def view_all_students(students):
    """Display all student records in a formatted table."""
    if not students:
        print("No student records found.\n")
        return

    print("\n" + "=" * 65)
    print(f"{'Name':<25}{'Admission No.':<18}{'Marks':<10}{'Grade':<10}")
    print("-" * 65)

    for name, details in students.items():
        grade = marks_to_grade(details["marks"])
        print(f"{name:<25}{details['admission_no']:<18}{details['marks']:<10.1f}{grade:<10}")

    print("=" * 65 + "\n")


def search_student(students):
    """Search for a student by name (case-insensitive, partial match)."""
    query = input("Enter student name to search: ").strip().lower()

    if not query:
        print("Search term cannot be empty.\n")
        return

    matches = {name: details for name, details in students.items() if query in name.lower()}

    if not matches:
        print(f"No students matching '{query}' found.\n")
        return

    print(f"\nFound {len(matches)} match(es):")
    print("-" * 65)
    for name, details in matches.items():
        grade = marks_to_grade(details["marks"])
        print(f"{name:<25}{details['admission_no']:<18}{details['marks']:<10.1f}{grade:<10}")
    print()


def find_exact_student(students, name):
    """Case-insensitive exact lookup. Returns the actual key stored, or None."""
    for key in students:
        if key.lower() == name.lower():
            return key
    return None


def update_student_marks(students):
    """Update a student's marks."""
    name = input("Enter student name to update: ").strip()
    actual_key = find_exact_student(students, name)

    if actual_key is None:
        print(f"'{name}' not found in records.\n")
        return

    print(f"Current marks for {actual_key}: {students[actual_key]['marks']:.1f}")

    new_marks = get_valid_marks("Enter new marks (0-100): ")
    if new_marks is None:
        return

    students[actual_key]["marks"] = new_marks
    print(f"'{actual_key}' updated successfully. New marks: {new_marks:.1f}\n")


def delete_student(students):
    """Delete a student record after confirmation."""
    name = input("Enter student name to delete: ").strip()
    actual_key = find_exact_student(students, name)

    if actual_key is None:
        print(f"'{name}' not found in records.\n")
        return

    confirm = input(f"Are you sure you want to delete '{actual_key}'? (y/n): ").strip().lower()
    if confirm == "y":
        del students[actual_key]
        print(f"'{actual_key}' deleted successfully.\n")
    else:
        print("Deletion cancelled.\n")


def display_class_statistics(students):
    """Calculate and display class-wide statistics."""
    if not students:
        print("No student records found. Cannot compute statistics.\n")
        return

    all_marks = [details["marks"] for details in students.values()]
    total = sum(all_marks)
    count = len(all_marks)
    average = total / count
    highest = max(all_marks)
    lowest = min(all_marks)

    top_student = next(name for name, d in students.items() if d["marks"] == highest)
    bottom_student = next(name for name, d in students.items() if d["marks"] == lowest)

    pass_count = sum(1 for m in all_marks if m >= 50)
    fail_count = count - pass_count
    pass_rate = (pass_count / count) * 100

    print("\n" + "=" * 45)
    print("          CLASS STATISTICS")
    print("=" * 45)
    print(f"Number of students : {count}")
    print(f"Class average      : {average:.2f}")
    print(f"Highest score      : {highest:.1f}  ({top_student})")
    print(f"Lowest score       : {lowest:.1f}  ({bottom_student})")
    print(f"Pass rate (>=50)   : {pass_rate:.1f}%  ({pass_count} passed, {fail_count} failed)")
    print("=" * 45 + "\n")


def marks_to_grade(marks):
    """Convert numeric marks to a letter grade."""
    if marks >= 80:
        return "A"
    elif marks >= 70:
        return "B"
    elif marks >= 60:
        return "C"
    elif marks >= 50:
        return "D"
    else:
        return "E"


def get_valid_marks(prompt):
    """Prompt until a valid mark between 0 and 100 is entered, or return None on cancel."""
    while True:
        raw = input(prompt).strip()
        if raw.lower() == "cancel":
            return None
        try:
            value = float(raw)
            if value < 0 or value > 100:
                print("Marks must be between 0 and 100. Type 'cancel' to abort.")
                continue
            return value
        except ValueError:
            print("Invalid number. Type 'cancel' to abort.")


def print_menu():
    print("=" * 45)
    print("     STUDENT RECORD MANAGEMENT SYSTEM")
    print("=" * 45)
    print("1. Add Student Record")
    print("2. View All Students")
    print("3. Search Student by Name")
    print("4. Update Student Marks")
    print("5. Delete Student Record")
    print("6. Display Class Statistics")
    print("7. Exit")
    print("=" * 45)


def seed_sample_data(students):
    """Preload a few sample students so the system isn't empty on first run."""
    students["Alice Wanjiru"] = {"admission_no": "SCT221-001", "marks": 85.0}
    students["Brian Otieno"] = {"admission_no": "SCT221-002", "marks": 42.5}
    students["Caroline Mwikali"] = {"admission_no": "SCT221-003", "marks": 67.0}
    students["David Kiptoo"] = {"admission_no": "SCT221-004", "marks": 91.5}
    students["Esther Nyambura"] = {"admission_no": "SCT221-005", "marks": 55.0}


def main():
    students = {}
    seed_sample_data(students)

    while True:
        print_menu()
        choice = input("Select an option (1-7): ").strip()

        if choice == "1":
            add_student(students)
        elif choice == "2":
            view_all_students(students)
        elif choice == "3":
            search_student(students)
        elif choice == "4":
            update_student_marks(students)
        elif choice == "5":
            delete_student(students)
        elif choice == "6":
            display_class_statistics(students)
        elif choice == "7":
            print("Exiting Student Record Management System. Goodbye!")
            break
        else:
            print("Invalid option. Please select 1-7.\n")


if __name__ == "__main__":
    main()
