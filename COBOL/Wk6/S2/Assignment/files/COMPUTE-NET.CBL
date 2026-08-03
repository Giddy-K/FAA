      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 29, 2026
      *> PURPOSE: Subprogram - computes net pay as gross minus tax.
      *>          Called by MAIN-PAYROLL last in the chain, after
      *>          both COMPUTE-GROSS and COMPUTE-TAX.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPUTE-NET.

       DATA DIVISION.
       LINKAGE SECTION.
       01 LS-GROSS                PIC 9(7)V99.
       01 LS-TAX                  PIC 9(7)V99.
       01 LS-NET                  PIC 9(7)V99.

       PROCEDURE DIVISION USING LS-GROSS, LS-TAX, LS-NET.
           COMPUTE LS-NET = LS-GROSS - LS-TAX
           GOBACK.
