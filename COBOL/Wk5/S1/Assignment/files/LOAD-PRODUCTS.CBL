      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 20, 2026
      *> PURPOSE: One-time loader that creates PRODUCTS.DAT (an
      *>          indexed file) and populates it with the 5 sample
      *>          products, so PRODUCT-LOOKUP.CBL has data to work
      *>          against. Not part of the graded deliverable itself -
      *>          simulates "this morning's class" having already
      *>          built the file.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOAD-PRODUCTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRODUCT-FILE
               ASSIGN TO "PRODUCTS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS PROD-CODE
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  PRODUCT-FILE.
       01  PRODUCT-RECORD.
           05 PROD-CODE             PIC X(4).
           05 PROD-NAME             PIC X(20).
           05 PROD-PRICE            PIC 9(5)V99.
           05 PROD-QTY              PIC 9(3).
           05 PROD-STATUS           PIC X.

       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS            PIC XX.

       PROCEDURE DIVISION.
       MAIN-PARA.
           OPEN OUTPUT PRODUCT-FILE

           MOVE "P001" TO PROD-CODE
           MOVE "Rice 5kg"           TO PROD-NAME
           MOVE 850.00               TO PROD-PRICE
           MOVE 40                   TO PROD-QTY
           MOVE "A"                  TO PROD-STATUS
           WRITE PRODUCT-RECORD

           MOVE "P002" TO PROD-CODE
           MOVE "Cooking Oil 2L"     TO PROD-NAME
           MOVE 650.00               TO PROD-PRICE
           MOVE 25                   TO PROD-QTY
           MOVE "A"                  TO PROD-STATUS
           WRITE PRODUCT-RECORD

           MOVE "P003" TO PROD-CODE
           MOVE "Sugar 2kg"          TO PROD-NAME
           MOVE 320.00               TO PROD-PRICE
           MOVE 60                   TO PROD-QTY
           MOVE "A"                  TO PROD-STATUS
           WRITE PRODUCT-RECORD

           MOVE "P004" TO PROD-CODE
           MOVE "Wheat Flour 2kg"    TO PROD-NAME
           MOVE 280.00               TO PROD-PRICE
           MOVE 45                   TO PROD-QTY
           MOVE "A"                  TO PROD-STATUS
           WRITE PRODUCT-RECORD

           MOVE "P005" TO PROD-CODE
           MOVE "Tea Leaves 500g"    TO PROD-NAME
           MOVE 410.00               TO PROD-PRICE
           MOVE 30                   TO PROD-QTY
           MOVE "A"                  TO PROD-STATUS
           WRITE PRODUCT-RECORD

           CLOSE PRODUCT-FILE
           DISPLAY "PRODUCTS.DAT created with 5 sample records."
           STOP RUN.
