"""
Lab 2: ATM Withdrawal Validator

Requirements:
  1. Accept current balance and withdrawal amount
  2. Check: withdrawal > 0
  3. Check: withdrawal <= balance
  4. Check: withdrawal <= 70,000 (daily limit)
"""

DAILY_LIMIT = 70000


def get_positive_amount(prompt):
    """Prompt until a valid non-negative number is entered."""
    while True:
        raw = input(prompt).strip()
        try:
            value = float(raw)
            if value < 0:
                print("Amount cannot be negative. Please try again.")
                continue
            return value
        except ValueError:
            print("Invalid input. Please enter a number.")


def validate_withdrawal(balance, withdrawal):
    """
    Validate a withdrawal request against three rules, in order:
      1. withdrawal > 0
      2. withdrawal <= balance
      3. withdrawal <= DAILY_LIMIT
    Returns (is_valid: bool, message: str)
    """
    if withdrawal <= 0:
        return False, "Withdrawal amount must be greater than 0."

    if withdrawal > balance:
        return False, f"Insufficient funds. Your balance is KES {balance:,.2f}."

    if withdrawal > DAILY_LIMIT:
        return False, f"Withdrawal exceeds the daily limit of KES {DAILY_LIMIT:,.2f}."

    return True, "Withdrawal approved."


def main():
    print("=" * 40)
    print("      ATM WITHDRAWAL VALIDATOR")
    print("=" * 40)

    balance = get_positive_amount("Enter current balance (KES): ")
    withdrawal = get_positive_amount("Enter withdrawal amount (KES): ")

    is_valid, message = validate_withdrawal(balance, withdrawal)

    print("\n" + "-" * 40)
    if is_valid:
        new_balance = balance - withdrawal
        print(f"✅ {message}")
        print(f"Amount withdrawn : KES {withdrawal:,.2f}")
        print(f"New balance      : KES {new_balance:,.2f}")
    else:
        print(f"❌ Transaction declined: {message}")
    print("-" * 40 + "\n")


if __name__ == "__main__":
    main()
