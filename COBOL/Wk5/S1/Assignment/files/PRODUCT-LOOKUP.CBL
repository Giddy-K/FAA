      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 20, 2026
      *> PURPOSE: Product Lookup with FILE STATUS error handling.
      *>          Extends the morning's lookup/add/update/discontinue
      *>          program so every file operation checks WS-FILE-STATUS
      *>          and shows a message specific to what happened -
      *>          not-found, duplicate-key, file-not-found, or an
      *>          unexpected code - instead of one generic error line.
      *>
      *> FILE STATUS and INVALID KEY are used TOGETHER: INVALID KEY
      *> stays on every keyed READ/WRITE/REWRITE as required syntax
      *> for indexed I/O, but the actual message shown to the user is
      *> always chosen by evaluating WS-FILE-STATUS afterward via the
      *> 88-level condition names below - not by literal comparisons.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRODUCT-LOOKUP.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRODUCT-FILE
               ASSIGN TO "PRODUCTS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS PROD-CODE
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  PRODUCT-FILE.
       01  PRODUCT-RECORD.
           05 PROD-CODE              PIC X(4).
           05 PROD-NAME              PIC X(20).
           05 PROD-PRICE             PIC 9(5)V99.
           05 PROD-QTY               PIC 9(3).
           05 PROD-STATUS            PIC X.

       WORKING-STORAGE SECTION.

      *> ---------------------------------------------------------
      *> FILE STATUS field and the 88-level condition names required
      *> by the assignment - used throughout instead of comparing
      *> WS-FILE-STATUS to literal "00", "23", "22", "35" directly.
      *> ---------------------------------------------------------
       01 WS-FILE-STATUS             PIC XX.
           88 FS-SUCCESS                 VALUE "00".
           88 FS-NOT-FOUND                VALUE "23".
           88 FS-DUPLICATE-KEY            VALUE "22".
           88 FS-FILE-NOT-FOUND           VALUE "35".

       01 WS-MENU-CHOICE             PIC 9.
       01 WS-SEARCH-CODE             PIC X(4).
       01 WS-CONTINUE-FLAG           PIC X   VALUE "Y".
           88 KEEP-RUNNING               VALUE "Y", "y".

       01 WS-NEW-PRICE               PIC 9(5)V99.
       01 WS-NEW-QTY                 PIC 9(3).

       01 WS-SEPARATOR               PIC X(45) VALUE ALL "-".

       PROCEDURE DIVISION.

       MAIN-PARA.
           OPEN I-O PRODUCT-FILE
           PERFORM CHECK-OPEN-STATUS

           IF FS-SUCCESS
               PERFORM UNTIL NOT KEEP-RUNNING
                   PERFORM SHOW-MENU
                   ACCEPT WS-MENU-CHOICE
                   PERFORM DISPATCH-MENU-CHOICE
               END-PERFORM
               CLOSE PRODUCT-FILE
           END-IF

           STOP RUN.

      *> ---------------------------------------------------------
      *> Checks FILE STATUS immediately after OPEN, per requirement.
      *> A missing file (35) ends the program gracefully with a
      *> clear message instead of crashing on the first READ.
      *> ---------------------------------------------------------
       CHECK-OPEN-STATUS.
           EVALUATE TRUE
               WHEN FS-SUCCESS
                   CONTINUE
               WHEN FS-FILE-NOT-FOUND
                   DISPLAY "ERROR: The product file could not be found."
                   DISPLAY "The program cannot continue and will now exit."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR on OPEN. FILE STATUS = "
                       WS-FILE-STATUS
                   DISPLAY "The program cannot continue and will now exit."
           END-EVALUATE.

       SHOW-MENU.
           DISPLAY " ".
           DISPLAY "===== PRODUCT LOOKUP SYSTEM =====".
           DISPLAY "1. Look up product".
           DISPLAY "2. Add product".
           DISPLAY "3. Update price/quantity".
           DISPLAY "4. Discontinue product".
           DISPLAY "5. Exit".
           DISPLAY "Select an option (1-5): ".

       DISPATCH-MENU-CHOICE.
           EVALUATE WS-MENU-CHOICE
               WHEN 1 PERFORM LOOK-UP-PRODUCT
               WHEN 2 PERFORM ADD-PRODUCT
               WHEN 3 PERFORM UPDATE-PRODUCT
               WHEN 4 PERFORM DISCONTINUE-PRODUCT
               WHEN 5 MOVE "N" TO WS-CONTINUE-FLAG
               WHEN OTHER
                   DISPLAY "Invalid option. Please select 1-5."
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Look up a product by code. INVALID KEY / NOT INVALID KEY
      *> are kept on the READ as required syntax; the actual message
      *> shown is chosen afterward from WS-FILE-STATUS.
      *> ---------------------------------------------------------
       LOOK-UP-PRODUCT.
           DISPLAY " ".
           DISPLAY "Enter product code to look up: ".
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PROD-CODE

           READ PRODUCT-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY WS-SEPARATOR
                   DISPLAY "Code     : " PROD-CODE
                   DISPLAY "Name     : " PROD-NAME
                   DISPLAY "Price    : " PROD-PRICE
                   DISPLAY "Quantity : " PROD-QTY
                   DISPLAY WS-SEPARATOR
               WHEN FS-NOT-FOUND
                   DISPLAY "Product not found: " WS-SEARCH-CODE
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Add a new product. A duplicate code (22) and success (00)
      *> get their own distinct messages.
      *> ---------------------------------------------------------
       ADD-PRODUCT.
           DISPLAY " ".
           DISPLAY "Enter new product code: ".
           ACCEPT PROD-CODE
           DISPLAY "Enter product name: ".
           ACCEPT PROD-NAME
           DISPLAY "Enter price: ".
           ACCEPT PROD-PRICE
           DISPLAY "Enter quantity: ".
           ACCEPT PROD-QTY
           MOVE "A" TO PROD-STATUS

           WRITE PRODUCT-RECORD
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-WRITE

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Product added successfully: " PROD-CODE
               WHEN FS-DUPLICATE-KEY
                   DISPLAY "ERROR: Product code " PROD-CODE
                       " is already in use."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Update price/quantity for an existing product. Reads first
      *> to confirm the product exists, then REWRITEs. Both the READ
      *> and the REWRITE are checked against WS-FILE-STATUS.
      *> ---------------------------------------------------------
       UPDATE-PRODUCT.
           DISPLAY " ".
           DISPLAY "Enter product code to update: ".
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PROD-CODE

           READ PRODUCT-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   DISPLAY "Enter new price: "
                   ACCEPT WS-NEW-PRICE
                   DISPLAY "Enter new quantity: "
                   ACCEPT WS-NEW-QTY
                   MOVE WS-NEW-PRICE TO PROD-PRICE
                   MOVE WS-NEW-QTY   TO PROD-QTY

                   REWRITE PRODUCT-RECORD
                       INVALID KEY
                           CONTINUE
                       NOT INVALID KEY
                           CONTINUE
                   END-REWRITE

                   EVALUATE TRUE
                       WHEN FS-SUCCESS
                           DISPLAY "Product " WS-SEARCH-CODE
                               " updated successfully."
                       WHEN OTHER
                           DISPLAY "UNEXPECTED FILE ERROR on update. "
                               "FILE STATUS = " WS-FILE-STATUS
                   END-EVALUATE

               WHEN FS-NOT-FOUND
                   DISPLAY "Product not found: " WS-SEARCH-CODE
                   DISPLAY "Nothing was updated."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.

      *> ---------------------------------------------------------
      *> Soft-delete: mark a product as discontinued (PROD-STATUS =
      *> "D") via REWRITE rather than a hard DELETE.
      *> ---------------------------------------------------------
       DISCONTINUE-PRODUCT.
           DISPLAY " ".
           DISPLAY "Enter product code to discontinue: ".
           ACCEPT WS-SEARCH-CODE
           MOVE WS-SEARCH-CODE TO PROD-CODE

           READ PRODUCT-FILE
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   CONTINUE
           END-READ

           EVALUATE TRUE
               WHEN FS-SUCCESS
                   MOVE "D" TO PROD-STATUS

                   REWRITE PRODUCT-RECORD
                       INVALID KEY
                           CONTINUE
                       NOT INVALID KEY
                           CONTINUE
                   END-REWRITE

                   EVALUATE TRUE
                       WHEN FS-SUCCESS
                           DISPLAY "Product " WS-SEARCH-CODE
                               " discontinued successfully."
                       WHEN OTHER
                           DISPLAY "UNEXPECTED FILE ERROR on "
                               "discontinue. FILE STATUS = "
                               WS-FILE-STATUS
                   END-EVALUATE

               WHEN FS-NOT-FOUND
                   DISPLAY "Product not found: " WS-SEARCH-CODE
                   DISPLAY "Nothing was discontinued."
               WHEN OTHER
                   DISPLAY "UNEXPECTED FILE ERROR. FILE STATUS = "
                       WS-FILE-STATUS
           END-EVALUATE.
