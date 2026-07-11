      *> AUTHOR: Gideon
      *> DATE: July 07, 2026
      *> PURPOSE: Assignment 2 - Student Registration Form DATA DIVISION
      *>          WORKING-STORAGE SECTION only; each logical group is
      *>          padded with FILLER to a multiple of 10 bytes.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. STUDENTREG.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> ---------------------------------------------------------
      *> Student name - group item with first/surname sub-fields
      *> 15 + 15 = 30 bytes (already a multiple of 10, no filler)
      *> ---------------------------------------------------------
       01 STUDENT-NAME.
           05 FIRST-NAME          PIC X(15).
           05 SURNAME             PIC X(15).

      *> ---------------------------------------------------------
      *> Student ID - 8-digit numeric
      *> 8 bytes + 2 filler = 10
      *> ---------------------------------------------------------
       01 STUDENT-ID              PIC 9(8).
       01 FILLER                  PIC X(2)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Marks for 4 subjects - each 0-100, so 3 digits each
      *> 4 x 3 = 12 bytes + 8 filler = 20
      *> ---------------------------------------------------------
       01 SUBJECT-MARKS.
           05 MARK-1              PIC 9(3).
           05 MARK-2              PIC 9(3).
           05 MARK-3              PIC 9(3).
           05 MARK-4              PIC 9(3).
       01 FILLER                  PIC X(8)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Total marks - max possible sum is 400, fits in 3 digits
      *> 3 bytes + 7 filler = 10
      *> ---------------------------------------------------------
       01 TOTAL-MARKS             PIC 9(3).
       01 FILLER                  PIC X(7)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Average mark - 2 decimal places (max 100.00)
      *> 5 bytes (3 int + 2 dec) + 5 filler = 10
      *> ---------------------------------------------------------
       01 AVERAGE-MARK            PIC 9(3)V99.
       01 FILLER                  PIC X(5)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Grade - single character (A, B, C, D, F)
      *> 1 byte + 9 filler = 10
      *> ---------------------------------------------------------
       01 GRADE                   PIC X(1).
       01 FILLER                  PIC X(9)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Registration date - stored as 8-digit YYYYMMDD integer
      *> 8 bytes + 2 filler = 10
      *> ---------------------------------------------------------
       01 REGISTRATION-DATE       PIC 9(8).
       01 FILLER                  PIC X(2)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Average mark display - edited, suppresses leading zeros
      *> 6 bytes (ZZ9.99) + 4 filler = 10
      *> ---------------------------------------------------------
       01 AVERAGE-MARK-DISPLAY    PIC ZZ9.99.
       01 FILLER                  PIC X(4)  VALUE SPACES.

      *> ---------------------------------------------------------
      *> Counter - number of students processed, starts at ZERO
      *> 4 bytes + 6 filler = 10
      *> ---------------------------------------------------------
       01 STUDENT-COUNTER         PIC 9(4)  VALUE ZERO.
       01 FILLER                  PIC X(6)  VALUE SPACES.

       PROCEDURE DIVISION.
           STOP RUN.
