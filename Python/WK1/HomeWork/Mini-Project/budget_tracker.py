"""
Interactive Personal Budget Tracker
FAC Academy - Python & Django Programme
Week 1, Session 5 - Mini Project

Requirements covered:
  1. Accept user's monthly income (float)
  2. Accept 5 expense categories with amounts
  3. Calculate total expenses and savings
  4. Determine savings % of income
  5. Display formatted budget summary (f-strings)
  6. Show 'SURPLUS' or 'DEFICIT' message
"""

NUM_EXPENSE_CATEGORIES = 5


def get_income():
    """Prompt for and validate the user's monthly income."""
    while True:
        raw = input("Enter your monthly income (KES): ").strip()
        try:
            income = float(raw)
            if income < 0:
                print("Income cannot be negative. Please try again.")
                continue
            return income
        except ValueError:
            print("Invalid input. Please enter a number (e.g. 50000 or 50000.50).")


def get_expenses():
    """Prompt for 5 expense categories and their amounts. Returns a dict."""
    expenses = {}
    print(f"\nEnter your {NUM_EXPENSE_CATEGORIES} expense categories and amounts:")

    for i in range(1, NUM_EXPENSE_CATEGORIES + 1):
        category = input(f"  Category {i} name: ").strip()
        if not category:
            category = f"Category {i}"  # fallback if left blank

        while True:
            raw_amount = input(f"  Amount spent on {category} (KES): ").strip()
            try:
                amount = float(raw_amount)
                if amount < 0:
                    print("  Amount cannot be negative. Please try again.")
                    continue
                break
            except ValueError:
                print("  Invalid input. Please enter a number.")

        expenses[category] = amount

    return expenses


def calculate_summary(income, expenses):
    """Calculate total expenses, savings, and savings percentage."""
    total_expenses = sum(expenses.values())
    savings = income - total_expenses

    # Avoid division by zero if income is 0
    savings_percent = (savings / income * 100) if income > 0 else 0.0

    return total_expenses, savings, savings_percent


def display_summary(income, expenses, total_expenses, savings, savings_percent):
    """Print a nicely formatted budget summary using f-strings."""
    print("\n" + "=" * 45)
    print(f"{'PERSONAL BUDGET SUMMARY':^45}")
    print("=" * 45)
    print(f"{'Monthly Income:':<25}KES {income:>12,.2f}")
    print("-" * 45)
    print("Expense Breakdown:")

    for category, amount in expenses.items():
        print(f"  {category:<23}KES {amount:>10,.2f}")

    print("-" * 45)
    print(f"{'Total Expenses:':<25}KES {total_expenses:>12,.2f}")
    print(f"{'Savings:':<25}KES {savings:>12,.2f}")
    print(f"{'Savings % of Income:':<25}{savings_percent:>12.1f}%")
    print("=" * 45)

    if savings >= 0:
        print(f"SURPLUS — You saved KES {savings:,.2f} this month!")
    else:
        print(f"DEFICIT — You overspent by KES {abs(savings):,.2f} this month.")

    print("=" * 45 + "\n")


def main():
    print("=" * 45)
    print(f"{'INTERACTIVE PERSONAL BUDGET TRACKER':^45}")
    print("=" * 45)

    income = get_income()
    expenses = get_expenses()
    total_expenses, savings, savings_percent = calculate_summary(income, expenses)
    display_summary(income, expenses, total_expenses, savings, savings_percent)


if __name__ == "__main__":
    main()
