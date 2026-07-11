      *> AUTHOR: Gideon
      *> DATE: July 07, 2026
      *> PURPOSE: Assignment 1 - Hospital Patient Record DATA DIVISION
      *>          WORKING-STORAGE SECTION only, per specification.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PATIENTREC.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> ---------------------------------------------------------
      *> Patient ID - 6-digit numeric identifier
      *> ---------------------------------------------------------
       01 PATIENT-ID              PIC 9(6).

      *> ---------------------------------------------------------
      *> Full name - split into first name and surname sub-fields,
      *> combined total of 45 characters
      *> ---------------------------------------------------------
       01 PATIENT-NAME.
           05 FIRST-NAME          PIC X(20).
           05 SURNAME             PIC X(25).

      *> ---------------------------------------------------------
      *> Age - whole years, 0-150 (3 digits covers up to 150)
      *> ---------------------------------------------------------
       01 PATIENT-AGE             PIC 9(3).

      *> ---------------------------------------------------------
      *> Ward code - 3-letter code (e.g. ICU, GEN, MTC)
      *> ---------------------------------------------------------
       01 WARD-CODE               PIC X(3).

      *> ---------------------------------------------------------
      *> Diagnosis code - up to 10 characters (ICD-10 format)
      *> ---------------------------------------------------------
       01 DIAGNOSIS-CODE          PIC X(10).

      *> ---------------------------------------------------------
      *> Test results 1-3 - up to 3 integer digits, 2 decimal places
      *> ---------------------------------------------------------
       01 TEST-RESULTS.
           05 TEST-RESULT-1       PIC 9(3)V99.
           05 TEST-RESULT-2       PIC 9(3)V99.
           05 TEST-RESULT-3       PIC 9(3)V99.

      *> ---------------------------------------------------------
      *> Attending doctor - up to 30 characters
      *> ---------------------------------------------------------
       01 ATTENDING-DOCTOR        PIC X(30).

      *> ---------------------------------------------------------
      *> Display field for test results - edited, suppresses
      *> leading zeros; used for printing only (not for arithmetic)
      *> ---------------------------------------------------------
       01 TEST-RESULT-DISPLAY     PIC ZZ9.99.

      *> ---------------------------------------------------------
      *> Separator line - 50-character line of dashes for reports
      *> ---------------------------------------------------------
       01 SEPARATOR-LINE          PIC X(50) VALUE ALL "-".

       PROCEDURE DIVISION.
           STOP RUN.
