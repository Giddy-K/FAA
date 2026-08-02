      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 23, 2026
      *> PURPOSE: Customer Ledger System - Phase 2 comprehensive
      *>          assignment. Menu-driven CRUD (Add/Update/Display/
      *>          Delete) against an indexed file keyed on customer
      *>          ID, with full FILE STATUS error handling on every
      *>          operation and a genuine Y/N confirmation before
      *>          delete.
      *>
      *> FILE STATUS and INVALID KEY are used TOGETHER throughout:
      *> INVALID KEY / NOT INVALID KEY stay on every keyed READ/
      *> WRITE/REWRITE/DELETE as required syntax, but the actual
      *> message shown to the user is always chosen afterward by
      *> evaluating WS-FILE-STATUS via the 88-level condition names
      *> below - never by comparing literal status codes directly.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTOMER-LEDGER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE
               ASSIGN TO "CUSTOMERS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS CUST-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTOMER-FILE.
       01  CUSTOMER-RECORD.
           05 CUST-ID                 PIC X(5).
           05 CUST-NAME               PIC X(25).
           05 CUST-PHONE              PIC X(13).
           05 CUST-BALANCE            PIC 9(7)V99.

       WORKING-STORAGE SECTION.

      *> ---------------------------------------------------------
      *> FILE STATUS field and required 88-level condition names.
      *> Used throughout instead of comparing WS-FILE-STATUS to
      *> literal "00", "23", "22", "35" directly.
      *> ---------------------------------------------------------
       01 WS-FILE-STATUS              PIC XX.
           88 FS-SUCCESS                  VALUE "00".
           88 FS-NOT-FOUND                 VALUE "23".
           88 FS-DUPLICATE-KEY             VALUE "22".
           88 FS-FILE-NOT-FOUND            VALUE "35".

       01 WS-MENU-CHOICE              PIC 9.
       01 WS-SEARCH-ID                PIC X(5).
       01 WS-CONTINUE-FLAG            PIC X   VALUE "Y".
           88 KEEP-RUNNING                VALUE "Y", "y".

       01 WS-CONFIRM                  PIC X.
           88 CONFIRM-YES                 VALUE "Y", "y".

       01 WS-NEW-NAME                 PIC X(25).
       01 WS-NEW-PHONE                PIC X(13).
       01 WS-NEW-BALANCE              PIC 9(7)V99.

       01 WS-SEPARATOR                PIC X(45) VALUE ALL "-".

       PROCEDURE DIVISION.

       MAIN-PARA.
           OPEN I-O CUSTOMER-FILE
           PERFORM CHECK-OPEN-STATUS

           IF FS-SUCCESS
               PERFORM UNTIL NOT KEEP-RUNNING
                   PERFORM SHOW-MENU
                   ACCEPT WS-MENU-CHOICE
                   PERFORM DISPATCH-MENU-CHOICE
               END-PERFORM
               CLOSE CUSTOMER-FILE
           END-IF

           STOP RUN.

      *> ---------------------------------------------------------
      *> Checks FILE STATUS immediately after OPEN. A missing file
      *> (35) ends the program gracefully with a clear message
      *> instead of crashing on the first READ/WRITE.
      *> ---------------------------------------------------------
       CHECK-OPEN-STATUS.
           EVALUATE TRUE
               WHEN FS-SUCCESS
                   CONTINUE
               WHEN FS-FILE-NOT-FOUND
                   DISPLAY "ERROR: The customer file could not be found."
                   DISPLAY "The program cannot continue and will now exit."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR on OPEN. FILE STATUS = "
                       WS-FILE-STATUS
                   DISPLAY "The program cannot continue and will now exit."
           END-EVALUATE.

       SHOW-MENU.
           DISPLAY " ".
           DISPLAY "===== CUSTOMER LEDGER =====".
           DISPLAY "1. Add customer".
           DISPLAY "2. Update customer".
           DISPLAY "3. Display customer".
           DISPLAY "4. Delete customer".
           DISPLAY "5. Exit".
           DISPLAY "============================".
           DISPLAY "Enter your choice: ".

       DISPATCH-MENU-CHOICE.
           EVALUATE WS-MENU-CHOICE
               WHEN 1 PERFORM ADD-CUSTOMER
               WHEN 2 PERFORM UPDATE-CUSTOMER
               WHEN 3 PERFORM DISPLAY-CUSTOMER
               WHEN 4 PERFORM DELETE-CUSTOMER
               WHEN 5 MOVE "N" TO WS-CONTINUE-FLAG
               WHEN OTHER
                   DISPLAY "Invalid option. Please select 1-5."
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Add a new customer. Duplicate ID (22) and success (00) get
      *> distinct messages.
      *> ---------------------------------------------------------
       ADD-CUSTOMER.
           DISPLAY " ".
           DISPLAY "Enter new customer ID: ".
           ACCEPT CUST-ID
           DISPLAY "Enter customer name: ".
           ACCEPT CUST-NAME
           DISPLAY "Enter phone number: ".
           ACCEPT CUST-PHONE
           DISPLAY "Enter starting balance: ".
           ACCEPT CUST-BALANCE

           WRITE CUSTOMER-RECORD
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-WRITE

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Customer added successfully: " CUST-ID
               WHEN FS-DUPLICATE-KEY
                   DISPLAY "ERROR: Customer ID " CUST-ID
                       " is already in use."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Update an existing customer. READs first (required before
      *> REWRITE), then asks per-field whether to change it, so
      *> fields the user skips remain exactly as read from the file.
      *> ---------------------------------------------------------
       UPDATE-CUSTOMER.
           DISPLAY " ".
           DISPLAY "Enter customer ID to update: ".
           ACCEPT WS-SEARCH-ID
           MOVE WS-SEARCH-ID TO CUST-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Current Name    : " CUST-NAME
                   DISPLAY "Current Phone   : " CUST-PHONE
                   DISPLAY "Current Balance : " CUST-BALANCE
                   DISPLAY " "

                   DISPLAY "Update name? (Y/N): "
                   ACCEPT WS-CONFIRM
                   IF CONFIRM-YES
                       DISPLAY "Enter new name: "
                       ACCEPT WS-NEW-NAME
                       MOVE WS-NEW-NAME TO CUST-NAME
                   END-IF

                   DISPLAY "Update phone? (Y/N): "
                   ACCEPT WS-CONFIRM
                   IF CONFIRM-YES
                       DISPLAY "Enter new phone: "
                       ACCEPT WS-NEW-PHONE
                       MOVE WS-NEW-PHONE TO CUST-PHONE
                   END-IF

                   DISPLAY "Update balance? (Y/N): "
                   ACCEPT WS-CONFIRM
                   IF CONFIRM-YES
                       DISPLAY "Enter new balance: "
                       ACCEPT WS-NEW-BALANCE
                       MOVE WS-NEW-BALANCE TO CUST-BALANCE
                   END-IF

                   REWRITE CUSTOMER-RECORD
                       INVALID KEY
                           CONTINUE
                       NOT INVALID KEY
                           CONTINUE
                   END-REWRITE

                   EVALUATE TRUE
                       WHEN FS-SUCCESS
                           DISPLAY "Customer " WS-SEARCH-ID
                               " updated successfully."
                       WHEN OTHER
                           DISPLAY "UNEXPECTED FILE ERROR on update. "
                               "FILE STATUS = " WS-FILE-STATUS
                   END-EVALUATE

               WHEN FS-NOT-FOUND
                   DISPLAY "Customer not found: " WS-SEARCH-ID
                   DISPLAY "Nothing was updated."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Display a customer's full details by ID.
      *> ---------------------------------------------------------
       DISPLAY-CUSTOMER.
           DISPLAY " ".
           DISPLAY "Enter customer ID to display: ".
           ACCEPT WS-SEARCH-ID
           MOVE WS-SEARCH-ID TO CUST-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY WS-SEPARATOR
                   DISPLAY "ID      : " CUST-ID
                   DISPLAY "Name    : " CUST-NAME
                   DISPLAY "Phone   : " CUST-PHONE
                   DISPLAY "Balance : " CUST-BALANCE
                   DISPLAY WS-SEPARATOR
               WHEN FS-NOT-FOUND
                   DISPLAY "Customer not found: " WS-SEARCH-ID
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Delete a customer, with a genuine Y/N confirmation prompt
      *> after showing the record - a "N" cancels with no change.
      *> ---------------------------------------------------------
       DELETE-CUSTOMER.
           DISPLAY " ".
           DISPLAY "Enter customer ID to delete: ".
           ACCEPT WS-SEARCH-ID
           MOVE WS-SEARCH-ID TO CUST-ID

           READ CUSTOMER-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Customer found:"
                   DISPLAY "  ID      : " CUST-ID
                   DISPLAY "  Name    : " CUST-NAME
                   DISPLAY "  Phone   : " CUST-PHONE
                   DISPLAY "  Balance : " CUST-BALANCE
                   DISPLAY " "
                   DISPLAY "Are you sure you want to delete this "
                       "customer? (Y/N): "
                   ACCEPT WS-CONFIRM

                   IF CONFIRM-YES
                       DELETE CUSTOMER-FILE
                           INVALID KEY
                               CONTINUE
                           NOT INVALID KEY
                               CONTINUE
                       END-DELETE

                       EVALUATE TRUE
                           WHEN FS-SUCCESS
                               DISPLAY "Customer " WS-SEARCH-ID
                                   " deleted successfully."
                           WHEN OTHER
                               DISPLAY "UNEXPECTED FILE ERROR on "
                                   "delete. FILE STATUS = "
                                   WS-FILE-STATUS
                       END-EVALUATE
                   ELSE
                       DISPLAY "Deletion cancelled. No changes made."
                   END-IF

               WHEN FS-NOT-FOUND
                   DISPLAY "Customer not found: " WS-SEARCH-ID
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.
