"""
Library File Management System

A CSV-based library management console application. All data is
persisted to library_system.csv between program runs.

CSV columns: title, author, isbn, year, copies

Requirements covered:
  - Add Book       -> appended to CSV
  - View All Books -> read CSV, display as formatted table
  - Search Book    -> by title or author, partial + case-insensitive
  - Update Copies  -> change available copies for a given ISBN
  - Delete Book    -> remove by ISBN, rewrite file
  - Borrow/Return  -> adjust copies, never below 0
  - Save & Load    -> persistence via the CSV file itself
"""

import csv
import os

CSV_FILE = "library_system.csv"
FIELDNAMES = ["title", "author", "isbn", "year", "copies"]


def load_books():
    """Load all book records from the CSV file into a list of dicts.
    Returns an empty list if the file doesn't exist yet."""
    if not os.path.exists(CSV_FILE):
        return []

    books = []
    with open(CSV_FILE, "r", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            row["year"] = int(row["year"])
            row["copies"] = int(row["copies"])
            books.append(row)
    return books


def save_books(books):
    """Overwrite the CSV file with the current list of book records."""
    with open(CSV_FILE, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writeheader()
        for book in books:
            writer.writerow(book)


def append_book(book):
    """Append a single book record to the CSV file without rewriting
    the whole file (used by add_book for efficiency)."""
    file_exists = os.path.exists(CSV_FILE)
    with open(CSV_FILE, "a", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        if not file_exists:
            writer.writeheader()
        writer.writerow(book)


def find_book_by_isbn(books, isbn):
    """Return the book dict matching the given ISBN, or None."""
    for book in books:
        if book["isbn"] == isbn:
            return book
    return None


def add_book(books):
    """Prompt for a new book's details and append it to the CSV file."""
    title = input("Enter book title: ").strip()
    if not title:
        print("Title cannot be empty.\n")
        return

    author = input("Enter author: ").strip()

    isbn = input("Enter ISBN: ").strip()
    if not isbn:
        print("ISBN cannot be empty.\n")
        return

    if find_book_by_isbn(books, isbn) is not None:
        print(f"A book with ISBN '{isbn}' already exists.\n")
        return

    year = get_valid_int("Enter publication year: ")
    if year is None:
        return

    copies = get_valid_int("Enter number of copies: ")
    if copies is None:
        return

    book = {"title": title, "author": author, "isbn": isbn, "year": year, "copies": copies}
    books.append(book)
    append_book(book)
    print(f"'{title}' added and saved to {CSV_FILE}.\n")


def view_all_books(books):
    """Display all books in a formatted table."""
    if not books:
        print("No books in the library.\n")
        return

    print("\n" + "=" * 90)
    print(f"{'Title':<25}{'Author':<20}{'ISBN':<16}{'Year':<8}{'Copies':<8}")
    print("-" * 90)
    for book in books:
        print(f"{book['title']:<25}{book['author']:<20}{book['isbn']:<16}"
              f"{book['year']:<8}{book['copies']:<8}")
    print("=" * 90 + "\n")


def search_book(books):
    """Search books by title or author, partial + case-insensitive."""
    query = input("Enter title or author to search: ").strip().lower()

    if not query:
        print("Search term cannot be empty.\n")
        return

    matches = [b for b in books if query in b["title"].lower() or query in b["author"].lower()]

    if not matches:
        print(f"No books matching '{query}' found.\n")
        return

    print(f"\nFound {len(matches)} match(es):")
    print("-" * 90)
    for book in matches:
        print(f"{book['title']:<25}{book['author']:<20}{book['isbn']:<16}"
              f"{book['year']:<8}{book['copies']:<8}")
    print()


def update_copies(books):
    """Change the available copies count for a book, identified by ISBN."""
    isbn = input("Enter ISBN of the book to update: ").strip()
    book = find_book_by_isbn(books, isbn)

    if book is None:
        print(f"No book found with ISBN '{isbn}'.\n")
        return

    print(f"Current copies for '{book['title']}': {book['copies']}")
    new_copies = get_valid_int("Enter new copies count: ")
    if new_copies is None:
        return

    book["copies"] = new_copies
    save_books(books)
    print(f"Copies updated to {new_copies} and saved.\n")


def delete_book(books):
    """Remove a book record by ISBN and rewrite the CSV file."""
    isbn = input("Enter ISBN of the book to delete: ").strip()
    book = find_book_by_isbn(books, isbn)

    if book is None:
        print(f"No book found with ISBN '{isbn}'.\n")
        return

    confirm = input(f"Delete '{book['title']}' (ISBN {isbn})? (y/n): ").strip().lower()
    if confirm == "y":
        books.remove(book)
        save_books(books)
        print(f"'{book['title']}' deleted and file updated.\n")
    else:
        print("Deletion cancelled.\n")


def borrow_book(books):
    """Decrease a book's copies by 1, refusing if it would go below 0."""
    isbn = input("Enter ISBN of the book to borrow: ").strip()
    book = find_book_by_isbn(books, isbn)

    if book is None:
        print(f"No book found with ISBN '{isbn}'.\n")
        return

    if book["copies"] <= 0:
        print(f"'{book['title']}' has no copies available to borrow.\n")
        return

    book["copies"] -= 1
    save_books(books)
    print(f"'{book['title']}' borrowed. Copies remaining: {book['copies']}\n")


def return_book(books):
    """Increase a book's copies by 1 (a returned book)."""
    isbn = input("Enter ISBN of the book to return: ").strip()
    book = find_book_by_isbn(books, isbn)

    if book is None:
        print(f"No book found with ISBN '{isbn}'.\n")
        return

    book["copies"] += 1
    save_books(books)
    print(f"'{book['title']}' returned. Copies now: {book['copies']}\n")


def get_valid_int(prompt):
    """Prompt until a valid non-negative integer is entered, or None on cancel."""
    while True:
        raw = input(prompt).strip()
        if raw.lower() == "cancel":
            return None
        try:
            value = int(raw)
            if value < 0:
                print("Value cannot be negative. Type 'cancel' to abort.")
                continue
            return value
        except ValueError:
            print("Invalid whole number. Type 'cancel' to abort.")


def print_menu():
    print("=" * 40)
    print("   LIBRARY FILE MANAGEMENT SYSTEM")
    print("=" * 40)
    print("1. Add Book")
    print("2. View All Books")
    print("3. Search Book")
    print("4. Update Copies")
    print("5. Delete Book")
    print("6. Borrow Book")
    print("7. Return Book")
    print("8. Exit")
    print("=" * 40)


def main():
    books = load_books()
    print(f"Loaded {len(books)} book record(s) from {CSV_FILE}.\n")

    while True:
        print_menu()
        choice = input("Select an option (1-8): ").strip()

        if choice == "1":
            add_book(books)
        elif choice == "2":
            view_all_books(books)
        elif choice == "3":
            search_book(books)
        elif choice == "4":
            update_copies(books)
        elif choice == "5":
            delete_book(books)
        elif choice == "6":
            borrow_book(books)
        elif choice == "7":
            return_book(books)
        elif choice == "8":
            print("Exiting. All changes have been saved. Goodbye!")
            break
        else:
            print("Invalid option. Please select 1-8.\n")


if __name__ == "__main__":
    main()
