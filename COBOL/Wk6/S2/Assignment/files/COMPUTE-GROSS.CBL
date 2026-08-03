      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 29, 2026
      *> PURPOSE: Subprogram - computes gross pay (basic + allowances)
      *>          for one employee. Called by MAIN-PAYROLL.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPUTE-GROSS.

       DATA DIVISION.
       LINKAGE SECTION.
       COPY "EMPREC.cpy".

       01 LS-GROSS                PIC 9(7)V99.

       PROCEDURE DIVISION USING EMPLOYEE-RECORD, LS-GROSS.
           COMPUTE LS-GROSS = EMP-BASIC + EMP-ALLOWANCES
           GOBACK.
