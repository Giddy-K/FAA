"""
Lab 1: Voting Eligibility Checker

Requirements:
  1. Accept citizen's age and ID number
  2. Check age >= 18 AND ID number is exactly 8 digits long
  3. Display eligible/ineligible message
  4. Show next election year if eligible
"""

ELECTION_CYCLE_START = 2022
ELECTION_CYCLE_LENGTH = 5


def get_age():
    """Prompt until a valid non-negative integer age is entered."""
    while True:
        raw = input("Enter your age: ").strip()
        try:
            age = int(raw)
            if age < 0 or age > 120:
                print("Please enter a realistic age (0-120).")
                continue
            return age
        except ValueError:
            print("Invalid input. Please enter a whole number.")


def get_id_number():
    """Prompt for an ID number (digits only, any length accepted here;
    validity of length is checked separately in check_eligibility)."""
    while True:
        raw = input("Enter your ID number: ").strip()
        if raw.isdigit():
            return raw
        print("ID number must contain digits only. Please try again.")


def check_eligibility(age, id_number):
    """Return True if age >= 18 AND ID number is exactly 8 digits long."""
    age_ok = age >= 18
    id_ok = len(id_number) == 8
    return age_ok and id_ok


def next_election_year():
    """Calculate the next election year based on a fixed 5-year cycle
    starting in 2022 (2022, 2027, 2032, ...)."""
    import datetime
    current_year = datetime.date.today().year

    year = ELECTION_CYCLE_START
    while year <= current_year:
        year += ELECTION_CYCLE_LENGTH
    return year


def main():
    print("=" * 40)
    print("      VOTING ELIGIBILITY CHECKER")
    print("=" * 40)

    age = get_age()
    id_number = get_id_number()

    eligible = check_eligibility(age, id_number)

    print("\n" + "-" * 40)
    if eligible:
        print("Result: ELIGIBLE to vote ✅")
        print(f"Next election year: {next_election_year()}")
    else:
        print("Result: INELIGIBLE to vote ❌")
        if age < 18:
            print(f"  Reason: Age ({age}) is below the required 18.")
        if len(id_number) != 8:
            print(f"  Reason: ID number must be exactly 8 digits (yours has {len(id_number)}).")
    print("-" * 40 + "\n")


if __name__ == "__main__":
    main()
