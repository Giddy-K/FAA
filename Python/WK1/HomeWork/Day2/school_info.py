"""
school_info.py

Task 2 - Person A (Driver)
A short Python script that displays school information: school name,
logo, favourite subjects, and teacher's name.

Requirements covered:
  1. Display school name and logo
  2. Add favourite 3 subjects
  3. Include teacher's name
  4. Today's date as a comment
  5. Uses both single-line and multi-line comments
"""

# Today's date: 05 July 2026

# --- School Logo (ASCII art banner) ---
SCHOOL_LOGO = r"""
     ____    __       __ 
    |       /  \     /  \
    |----  /____\   /____\
    |     /      \ /      \
"""

# School name — single-line comment
SCHOOL_NAME = "First Advantage Academy"

"""
Favourite subjects list.
These are the three subjects the student enjoys most, stored as a
simple Python list so they can be looped over and displayed.
"""
FAVOURITE_SUBJECTS = [
    "Cybersecurity & Ethical Hacking",
    "Software Engineering",
    "Database Systems"
]

# Teacher's name — replace with your actual instructor's name
TEACHER_NAME = "Dr. James Njoroge"


def display_school_info():
    """Print the school name, logo, favourite subjects, and teacher name."""
    print(SCHOOL_LOGO)
    print(f"School Name: {SCHOOL_NAME}\n")

    print("My Favourite Subjects:")
    for index, subject in enumerate(FAVOURITE_SUBJECTS, start=1):
        print(f"  {index}. {subject}")

    print(f"\nTeacher: {TEACHER_NAME}")


if __name__ == "__main__":
    display_school_info()
