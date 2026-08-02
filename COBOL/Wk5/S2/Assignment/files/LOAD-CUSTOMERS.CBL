      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 23, 2026
      *> PURPOSE: One-time loader that creates CUSTOMERS.DAT (an
      *>          indexed file) and populates it with the 5 sample
      *>          customers, so CUSTOMER-LEDGER.CBL has data to work
      *>          against. Not part of the graded deliverable itself.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOAD-CUSTOMERS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE
               ASSIGN TO "CUSTOMERS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS CUST-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  CUSTOMER-FILE.
       01  CUSTOMER-RECORD.
           05 CUST-ID                PIC X(5).
           05 CUST-NAME              PIC X(25).
           05 CUST-PHONE             PIC X(13).
           05 CUST-BALANCE           PIC 9(7)V99.

       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS             PIC XX.

       PROCEDURE DIVISION.
       MAIN-PARA.
           OPEN OUTPUT CUSTOMER-FILE

           MOVE "C001" TO CUST-ID
           MOVE "Alice Wanjiru"   TO CUST-NAME
           MOVE "0712345678"     TO CUST-PHONE
           MOVE 15000.00         TO CUST-BALANCE
           WRITE CUSTOMER-RECORD

           MOVE "C002" TO CUST-ID
           MOVE "Brian Otieno"    TO CUST-NAME
           MOVE "0723456789"     TO CUST-PHONE
           MOVE 0.00             TO CUST-BALANCE
           WRITE CUSTOMER-RECORD

           MOVE "C003" TO CUST-ID
           MOVE "Grace Mwikali"   TO CUST-NAME
           MOVE "0734567890"     TO CUST-PHONE
           MOVE 8500.50          TO CUST-BALANCE
           WRITE CUSTOMER-RECORD

           MOVE "C004" TO CUST-ID
           MOVE "David Kiptoo"    TO CUST-NAME
           MOVE "0745678901"     TO CUST-PHONE
           MOVE 32000.00         TO CUST-BALANCE
           WRITE CUSTOMER-RECORD

           MOVE "C005" TO CUST-ID
           MOVE "Esther Njoki"    TO CUST-NAME
           MOVE "0756789012"     TO CUST-PHONE
           MOVE 1200.75          TO CUST-BALANCE
           WRITE CUSTOMER-RECORD

           CLOSE CUSTOMER-FILE
           DISPLAY "CUSTOMERS.DAT created with 5 sample records."
           STOP RUN.
