"""
Lab 3: University Admission System

Requirements:
  1. Accept KCSE grade (A, B, C, D, E)
  2. Accept course choice
  3. Match grade to course requirements
  4. Display admission decision
"""

# Grade ranking: higher value = better grade
GRADE_RANK = {"A": 5, "B": 4, "C": 3, "D": 2, "E": 1}

# Minimum grade required per course
COURSE_REQUIREMENTS = {
    "Medicine": "B",       # Medicine: A or B only -> minimum B
    "Engineering": "B",    # Engineering: B or higher
    "Business": "C",       # Business: C or higher
    "Education": "D",      # Education: D or higher
}


def get_grade():
    """Prompt until a valid KCSE grade (A-E) is entered."""
    while True:
        raw = input("Enter your KCSE grade (A/B/C/D/E): ").strip().upper()
        if raw in GRADE_RANK:
            return raw
        print("Invalid grade. Please enter one of A, B, C, D, E.")


def get_course_choice():
    """Prompt until a valid course from the fixed list is chosen."""
    courses = list(COURSE_REQUIREMENTS.keys())

    print("\nAvailable courses:")
    for i, course in enumerate(courses, start=1):
        print(f"  {i}. {course}")

    while True:
        raw = input("Enter course name (or number): ").strip()

        # Allow selection by number
        if raw.isdigit():
            index = int(raw) - 1
            if 0 <= index < len(courses):
                return courses[index]
            print("Invalid number. Please choose from the list.")
            continue

        # Allow selection by typed name (case-insensitive)
        for course in courses:
            if course.lower() == raw.lower():
                return course

        print("Invalid course. Please choose from the list above.")


def check_admission(grade, course):
    """
    Compare the applicant's grade against the course's minimum requirement.
    Returns (admitted: bool, required_grade: str)
    """
    required_grade = COURSE_REQUIREMENTS[course]
    admitted = GRADE_RANK[grade] >= GRADE_RANK[required_grade]
    return admitted, required_grade


def main():
    print("=" * 45)
    print("      UNIVERSITY ADMISSION SYSTEM")
    print("=" * 45)

    grade = get_grade()
    course = get_course_choice()

    admitted, required_grade = check_admission(grade, course)

    print("\n" + "-" * 45)
    print(f"Applicant grade : {grade}")
    print(f"Course choice   : {course}")
    print(f"Minimum required: {required_grade}")
    print("-" * 45)

    if admitted:
        print(f"✅ Admitted to {course}!")
    else:
        print(f"❌ Not admitted — {course} requires at least grade {required_grade}.")
    print("-" * 45 + "\n")


if __name__ == "__main__":
    main()
