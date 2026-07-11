"""
Inventory Management System
Day 2 Task - Group Work

A dict-based console inventory manager supporting:
  1. Add new products
  2. Display all inventory in tabular format
  3. Search product by name
  4. Update product price or quantity
  5. Delete a product
  6. Low stock alert (qty < 10)
  7. Total inventory value

Data model:
  inventory = {
      "product_name": {"price": float, "quantity": int},
      ...
  }
"""

LOW_STOCK_THRESHOLD = 10


def add_product(inventory):
    """Prompt for a new product's details and add it to the inventory."""
    name = input("Enter product name: ").strip()

    if not name:
        print("Product name cannot be empty.\n")
        return

    if name.lower() in (key.lower() for key in inventory):
        print(f"'{name}' already exists. Use the update option instead.\n")
        return

    price = get_positive_float("Enter price: ")
    if price is None:
        return

    quantity = get_non_negative_int("Enter quantity: ")
    if quantity is None:
        return

    inventory[name] = {"price": price, "quantity": quantity}
    print(f"'{name}' added successfully.\n")


def display_inventory(inventory):
    """Display all products in a formatted table."""
    if not inventory:
        print("Inventory is empty.\n")
        return

    print("\n" + "=" * 60)
    print(f"{'Product':<25}{'Price (KES)':<15}{'Quantity':<10}{'Value':<10}")
    print("-" * 60)

    for name, details in inventory.items():
        value = details["price"] * details["quantity"]
        print(f"{name:<25}{details['price']:<15.2f}{details['quantity']:<10}{value:<10.2f}")

    print("=" * 60 + "\n")


def search_product(inventory):
    """Search for a product by name (case-insensitive, partial match)."""
    query = input("Enter product name to search: ").strip().lower()

    if not query:
        print("Search term cannot be empty.\n")
        return

    matches = {name: details for name, details in inventory.items() if query in name.lower()}

    if not matches:
        print(f"No products matching '{query}' found.\n")
        return

    print(f"\nFound {len(matches)} match(es):")
    print("-" * 60)
    for name, details in matches.items():
        value = details["price"] * details["quantity"]
        print(f"{name:<25}{details['price']:<15.2f}{details['quantity']:<10}{value:<10.2f}")
    print()


def find_exact_product(inventory, name):
    """Case-insensitive exact lookup. Returns the actual key stored, or None."""
    for key in inventory:
        if key.lower() == name.lower():
            return key
    return None


def update_product(inventory):
    """Update a product's price and/or quantity."""
    name = input("Enter product name to update: ").strip()
    actual_key = find_exact_product(inventory, name)

    if actual_key is None:
        print(f"'{name}' not found in inventory.\n")
        return

    print(f"Current price: {inventory[actual_key]['price']:.2f}")
    print(f"Current quantity: {inventory[actual_key]['quantity']}")

    choice = input("Update (P)rice, (Q)uantity, or (B)oth? ").strip().lower()

    if choice in ("p", "both", "b"):
        new_price = get_positive_float("Enter new price: ")
        if new_price is not None:
            inventory[actual_key]["price"] = new_price

    if choice in ("q", "both", "b"):
        new_quantity = get_non_negative_int("Enter new quantity: ")
        if new_quantity is not None:
            inventory[actual_key]["quantity"] = new_quantity

    if choice not in ("p", "q", "b", "both"):
        print("Invalid choice. No changes made.\n")
        return

    print(f"'{actual_key}' updated successfully.\n")


def delete_product(inventory):
    """Delete a product from the inventory after confirmation."""
    name = input("Enter product name to delete: ").strip()
    actual_key = find_exact_product(inventory, name)

    if actual_key is None:
        print(f"'{name}' not found in inventory.\n")
        return

    confirm = input(f"Are you sure you want to delete '{actual_key}'? (y/n): ").strip().lower()
    if confirm == "y":
        del inventory[actual_key]
        print(f"'{actual_key}' deleted successfully.\n")
    else:
        print("Deletion cancelled.\n")


def low_stock_alert(inventory):
    """Display products with quantity below the low stock threshold."""
    low_stock = {name: details for name, details in inventory.items()
                 if details["quantity"] < LOW_STOCK_THRESHOLD}

    if not low_stock:
        print(f"No low stock items. All products have quantity >= {LOW_STOCK_THRESHOLD}.\n")
        return

    print(f"\nLOW STOCK ALERT (quantity < {LOW_STOCK_THRESHOLD}):")
    print("-" * 40)
    for name, details in low_stock.items():
        print(f"{name:<25}Qty: {details['quantity']}")
    print()


def total_inventory_value(inventory):
    """Calculate and display the total value of all inventory."""
    if not inventory:
        print("Inventory is empty. Total value: 0.00\n")
        return

    total = sum(details["price"] * details["quantity"] for details in inventory.values())
    print(f"\nTotal Inventory Value: KES {total:,.2f}\n")


def get_positive_float(prompt):
    """Prompt until a valid positive float is entered, or return None on cancel."""
    while True:
        raw = input(prompt).strip()
        if raw.lower() == "cancel":
            return None
        try:
            value = float(raw)
            if value <= 0:
                print("Price must be greater than 0. Type 'cancel' to abort.")
                continue
            return value
        except ValueError:
            print("Invalid number. Type 'cancel' to abort.")


def get_non_negative_int(prompt):
    """Prompt until a valid non-negative integer is entered, or return None on cancel."""
    while True:
        raw = input(prompt).strip()
        if raw.lower() == "cancel":
            return None
        try:
            value = int(raw)
            if value < 0:
                print("Quantity cannot be negative. Type 'cancel' to abort.")
                continue
            return value
        except ValueError:
            print("Invalid whole number. Type 'cancel' to abort.")


def print_menu():
    print("=" * 40)
    print("     INVENTORY MANAGEMENT SYSTEM")
    print("=" * 40)
    print("1. Add new product")
    print("2. Display all inventory")
    print("3. Search product by name")
    print("4. Update product price/quantity")
    print("5. Delete a product")
    print("6. Show low stock alert")
    print("7. Calculate total inventory value")
    print("8. Exit")
    print("=" * 40)


def seed_sample_data(inventory):
    """Preload a few sample products so the system isn't empty on first run."""
    inventory["Rice 2kg"] = {"price": 250.00, "quantity": 45}
    inventory["Cooking Oil 1L"] = {"price": 320.00, "quantity": 8}
    inventory["Sugar 1kg"] = {"price": 180.00, "quantity": 60}
    inventory["Flour 2kg"] = {"price": 210.00, "quantity": 5}
    inventory["Milk 500ml"] = {"price": 65.00, "quantity": 120}


def main():
    inventory = {}
    seed_sample_data(inventory)

    while True:
        print_menu()
        choice = input("Select an option (1-8): ").strip()

        if choice == "1":
            add_product(inventory)
        elif choice == "2":
            display_inventory(inventory)
        elif choice == "3":
            search_product(inventory)
        elif choice == "4":
            update_product(inventory)
        elif choice == "5":
            delete_product(inventory)
        elif choice == "6":
            low_stock_alert(inventory)
        elif choice == "7":
            total_inventory_value(inventory)
        elif choice == "8":
            print("Exiting Inventory Management System. Goodbye!")
            break
        else:
            print("Invalid option. Please select 1-8.\n")


if __name__ == "__main__":
    main()
