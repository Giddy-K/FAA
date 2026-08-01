      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 20, 2026
      *> PURPOSE: Payroll Batch - reads EMPLOYEES.DAT, computes gross
      *>          pay, NHIF, PAYE, and net pay per employee, writes a
      *>          pay-advice line per employee to PAYADVICE.DAT, and
      *>          writes one company-wide summary record to
      *>          SALARYSUMMARY.DAT after the loop ends.
      *>
      *> NOTE: NHIF and PAYE rates here are simplified, fictional
      *> figures for this exercise only - not real statutory rates.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROLL-BATCH.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLOYEE-FILE
               ASSIGN TO "EMPLOYEES.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT PAY-ADVICE-FILE
               ASSIGN TO "PAYADVICE.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT SALARY-SUMMARY-FILE
               ASSIGN TO "SALARYSUMMARY.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  EMPLOYEE-FILE.
       01  EMPLOYEE-RECORD.
           05 EMP-ID               PIC X(5).
           05 EMP-NAME              PIC X(20).
           05 BASIC-SALARY          PIC 9(6)V99.
           05 ALLOWANCES            PIC 9(5)V99.

       FD  PAY-ADVICE-FILE.
       01  PAY-ADVICE-RECORD        PIC X(80).

       FD  SALARY-SUMMARY-FILE.
       01  SALARY-SUMMARY-RECORD    PIC X(150).

       WORKING-STORAGE SECTION.

       01 WS-EOF                    PIC X       VALUE "N".
           88 END-OF-FILE               VALUE "Y".

      *> Per-employee computed values
       01 GROSS-PAY                 PIC 9(6)V99.
       01 WS-NHIF                   PIC 9(5)V99.
       01 WS-PAYE                   PIC 9(5)V99.
       01 NET-PAY                   PIC 9(6)V99.

      *> Running totals across the whole file - all initialised to
      *> ZERO before the loop begins.
       01 WS-EMP-COUNT              PIC 9(3)    VALUE ZERO.
       01 WS-TOTAL-GROSS            PIC 9(8)V99 VALUE ZERO.
       01 WS-TOTAL-NHIF             PIC 9(8)V99 VALUE ZERO.
       01 WS-TOTAL-PAYE             PIC 9(8)V99 VALUE ZERO.
       01 WS-TOTAL-NET              PIC 9(8)V99 VALUE ZERO.

      *> Formatted pay-advice output line, built in working-storage
      *> then moved to PAY-ADVICE-RECORD before each WRITE.
       01 WS-PAY-LINE.
           05 WS-PL-ID              PIC X(6).
           05 WS-PL-NAME            PIC X(22).
           05 WS-PL-GROSS           PIC ZZZ,ZZ9.99.
           05 FILLER                PIC X(2)  VALUE SPACES.
           05 WS-PL-NHIF            PIC ZZ,ZZ9.99.
           05 FILLER                PIC X(2)  VALUE SPACES.
           05 WS-PL-PAYE            PIC ZZ,ZZ9.99.
           05 FILLER                PIC X(2)  VALUE SPACES.
           05 WS-PL-NET             PIC ZZZ,ZZ9.99.

      *> Formatted summary output line - written exactly once.
       01 WS-SUMMARY-LINE.
           05 FILLER                PIC X(18) VALUE
               "Total Employees : ".
           05 WS-SL-COUNT           PIC ZZ9.
           05 FILLER                PIC X(4)  VALUE SPACES.
           05 FILLER                PIC X(14) VALUE
               "Total Gross : ".
           05 WS-SL-GROSS           PIC ZZZ,ZZZ,ZZ9.99.
           05 FILLER                PIC X(4)  VALUE SPACES.
           05 FILLER                PIC X(13) VALUE
               "Total NHIF : ".
           05 WS-SL-NHIF            PIC ZZZ,ZZ9.99.
           05 FILLER                PIC X(4)  VALUE SPACES.
           05 FILLER                PIC X(13) VALUE
               "Total PAYE : ".
           05 WS-SL-PAYE            PIC ZZZ,ZZ9.99.
           05 FILLER                PIC X(4)  VALUE SPACES.
           05 FILLER                PIC X(12) VALUE
               "Total Net : ".
           05 WS-SL-NET             PIC ZZZ,ZZZ,ZZ9.99.

       01 WS-HEADER-LINE            PIC X(80) VALUE
           "ID     NAME                     GROSS       NHIF      PAYE       NET".

       PROCEDURE DIVISION.

       MAIN-PARA.
           OPEN INPUT  EMPLOYEE-FILE
                OUTPUT PAY-ADVICE-FILE
                OUTPUT SALARY-SUMMARY-FILE

           WRITE PAY-ADVICE-RECORD FROM WS-HEADER-LINE

           READ EMPLOYEE-FILE
               AT END
                   MOVE "Y" TO WS-EOF
           END-READ

           PERFORM UNTIL END-OF-FILE
               PERFORM PROCESS-EMPLOYEE
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       CONTINUE
               END-READ
           END-PERFORM

           PERFORM WRITE-SUMMARY

           CLOSE EMPLOYEE-FILE
                 PAY-ADVICE-FILE
                 SALARY-SUMMARY-FILE

           STOP RUN.

      *> ---------------------------------------------------------
      *> Compute gross pay, NHIF, PAYE, and net pay for the current
      *> employee record, accumulate the running totals, and write
      *> one formatted pay-advice line.
      *> ---------------------------------------------------------
       PROCESS-EMPLOYEE.
           COMPUTE GROSS-PAY ROUNDED =
               BASIC-SALARY + ALLOWANCES

           COMPUTE WS-NHIF ROUNDED =
               GROSS-PAY * 0.025

           COMPUTE WS-PAYE ROUNDED =
               (GROSS-PAY - WS-NHIF) * 0.10

           COMPUTE NET-PAY ROUNDED =
               GROSS-PAY - WS-NHIF - WS-PAYE

           ADD 1          TO WS-EMP-COUNT
           ADD GROSS-PAY  TO WS-TOTAL-GROSS
           ADD WS-NHIF    TO WS-TOTAL-NHIF
           ADD WS-PAYE    TO WS-TOTAL-PAYE
           ADD NET-PAY    TO WS-TOTAL-NET

           MOVE EMP-ID    TO WS-PL-ID
           MOVE EMP-NAME  TO WS-PL-NAME
           MOVE GROSS-PAY TO WS-PL-GROSS
           MOVE WS-NHIF   TO WS-PL-NHIF
           MOVE WS-PAYE   TO WS-PL-PAYE
           MOVE NET-PAY   TO WS-PL-NET

           WRITE PAY-ADVICE-RECORD FROM WS-PAY-LINE.

      *> ---------------------------------------------------------
      *> Writes the single company-wide summary record. Called once,
      *> after the read loop has finished - never inside it.
      *> ---------------------------------------------------------
       WRITE-SUMMARY.
           MOVE WS-EMP-COUNT   TO WS-SL-COUNT
           MOVE WS-TOTAL-GROSS TO WS-SL-GROSS
           MOVE WS-TOTAL-NHIF  TO WS-SL-NHIF
           MOVE WS-TOTAL-PAYE  TO WS-SL-PAYE
           MOVE WS-TOTAL-NET   TO WS-SL-NET

           WRITE SALARY-SUMMARY-RECORD FROM WS-SUMMARY-LINE.
