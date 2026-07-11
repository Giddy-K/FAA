"""
User Info Card Generator

Asks the user for their name, age, and home city, calculates their
approximate birth year, and prints a formatted summary card using f-strings.
"""


def get_user_info():
    """Prompt for and return the user's name, age, and city."""
    name = input("Enter your name: ").strip()

    while True:
        age_input = input("Enter your age: ").strip()
        try:
            age = int(age_input)
            if age < 0 or age > 120:
                print("Please enter a realistic age (0-120).")
                continue
            break
        except ValueError:
            print("Invalid input. Please enter a whole number for age.")

    city = input("Enter your home city: ").strip()

    return name, age, city


def calculate_birth_year(age, reference_year=2024):
    """Estimate birth year based on age and a reference year."""
    return reference_year - age


def print_info_card(name, age, city, birth_year):
    """Print a nicely formatted info card using f-strings."""
    print("\n" + "=" * 40)
    print(f"{'USER INFO CARD':^40}")
    print("=" * 40)
    print(f"Name          : {name}")
    print(f"Age           : {age} years old")
    print(f"Home City     : {city}")
    print(f"Birth Year    : ~{birth_year}")
    print("=" * 40)
    print(f"Hi {name}! You're {age} and from {city}. You were likely born around {birth_year}.")
    print("=" * 40 + "\n")


def main():
    name, age, city = get_user_info()
    birth_year = calculate_birth_year(age)
    print_info_card(name, age, city, birth_year)


if __name__ == "__main__":
    main()
