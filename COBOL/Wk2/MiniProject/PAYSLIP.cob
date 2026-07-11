      *> AUTHOR: Gideon
      *> DATE: July 01, 2026
      *> PURPOSE: Employee Pay Slip Generator - computes NHIF deduction
      *>          and net pay from basic salary input

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYSLIP.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-EMPLOYEE-NAME    PIC X(30).
       01 WS-BASIC-SALARY     PIC 9(7)V99.
       01 WS-NHIF-DEDUCTION   PIC 9(5)V99.
       01 WS-NET-PAY          PIC 9(7)V99.
       01 WS-SEPARATOR        PIC X(40) VALUE ALL "=".

       PROCEDURE DIVISION.
           DISPLAY "Enter Employee Name: ".
           ACCEPT WS-EMPLOYEE-NAME.

           DISPLAY "Enter Basic Salary: ".
           ACCEPT WS-BASIC-SALARY.

           COMPUTE WS-NHIF-DEDUCTION = WS-BASIC-SALARY * 0.0275.
           COMPUTE WS-NET-PAY = WS-BASIC-SALARY - WS-NHIF-DEDUCTION.

           DISPLAY WS-SEPARATOR.
           DISPLAY "            EMPLOYEE PAY SLIP".
           DISPLAY WS-SEPARATOR.
           DISPLAY "Employee Name  : " WS-EMPLOYEE-NAME.
           DISPLAY "Basic Salary   : " WS-BASIC-SALARY.
           DISPLAY "NHIF Deduction : " WS-NHIF-DEDUCTION.
           DISPLAY "Net Pay        : " WS-NET-PAY.
           DISPLAY WS-SEPARATOR.

           STOP RUN.
