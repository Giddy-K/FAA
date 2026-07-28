      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 08, 2026
      *> PURPOSE: Employee Bonus Calculator - First Advantage Consulting
      *>          Validates department code and performance rating using
      *>          88-level condition names, then determines the bonus
      *>          tier using EVALUATE ALSO on performance and tenure bands.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. BONUSCALC.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-EMPLOYEE-NAME        PIC X(20).

       01 WS-DEPT-CODE            PIC XX.
           88 VALID-DEPT-SALES        VALUE "SL".
           88 VALID-DEPT-IT           VALUE "IT".
           88 VALID-DEPT-HR           VALUE "HR".
           88 VALID-DEPT-FINANCE      VALUE "FN".
           88 VALID-DEPARTMENT        VALUES "SL", "IT", "HR", "FN".

       01 WS-PERFORMANCE-RATING   PIC 9.
           88 LOW-PERFORMER            VALUES 1 2.
           88 AVERAGE-PERFORMER        VALUE  3.
           88 HIGH-PERFORMER           VALUES 4 5.
           88 VALID-RATING             VALUES 1 THRU 5.

       01 WS-YEARS-SERVICE        PIC 99.
           88 JUNIOR-TENURE            VALUES 0 1.
           88 MID-TENURE               VALUES 2 THRU 4.
           88 SENIOR-TENURE            VALUES 5 THRU 99.

       01 WS-BASE-SALARY          PIC 9(6)V99.
       01 WS-BONUS-PERCENT        PIC V99.
       01 WS-BONUS-PCT-DISPLAY    PIC 99.
       01 WS-BONUS-AMOUNT         PIC 9(6)V99.
       01 WS-BONUS-TIER           PIC X(8).

       01 WS-PERF-BAND-TEXT       PIC X(17).
       01 WS-TENURE-BAND-TEXT     PIC X(13).

       01 WS-VALID-INPUT          PIC X       VALUE "Y".
       01 WS-SEPARATOR            PIC X(40)   VALUE ALL "-".

       PROCEDURE DIVISION.

       MAIN-PARA.
           PERFORM GET-INPUT
           PERFORM VALIDATE-INPUT
           IF WS-VALID-INPUT = "Y"
               PERFORM DETERMINE-BAND-TEXT
               PERFORM DETERMINE-BONUS-TIER
               PERFORM CALCULATE-BONUS
               PERFORM DISPLAY-VALID-RESULT
           ELSE
               PERFORM DISPLAY-INVALID-RESULT
           END-IF
           STOP RUN.

       GET-INPUT.
           DISPLAY "Enter employee name: ".
           ACCEPT WS-EMPLOYEE-NAME.
           DISPLAY "Enter department code (SL/IT/HR/FN): ".
           ACCEPT WS-DEPT-CODE.
           DISPLAY "Enter performance rating (1-5): ".
           ACCEPT WS-PERFORMANCE-RATING.
           DISPLAY "Enter years of service: ".
           ACCEPT WS-YEARS-SERVICE.
           DISPLAY "Enter base salary: ".
           ACCEPT WS-BASE-SALARY.

       VALIDATE-INPUT.
           MOVE "Y" TO WS-VALID-INPUT

           IF NOT VALID-DEPARTMENT
               DISPLAY "ERROR: Department code " WS-DEPT-CODE
                   " is not recognized."
               MOVE "N" TO WS-VALID-INPUT
           END-IF

           IF WS-VALID-INPUT = "Y" AND NOT VALID-RATING
               DISPLAY "ERROR: Performance rating "
                   WS-PERFORMANCE-RATING " is not valid (must be 1-5)."
               MOVE "N" TO WS-VALID-INPUT
           END-IF.

       DETERMINE-BAND-TEXT.
           EVALUATE TRUE
               WHEN LOW-PERFORMER
                   MOVE "Low Performer" TO WS-PERF-BAND-TEXT
               WHEN AVERAGE-PERFORMER
                   MOVE "Average Performer" TO WS-PERF-BAND-TEXT
               WHEN HIGH-PERFORMER
                   MOVE "High Performer" TO WS-PERF-BAND-TEXT
           END-EVALUATE

           EVALUATE TRUE
               WHEN JUNIOR-TENURE
                   MOVE "Junior Tenure" TO WS-TENURE-BAND-TEXT
               WHEN MID-TENURE
                   MOVE "Mid Tenure" TO WS-TENURE-BAND-TEXT
               WHEN SENIOR-TENURE
                   MOVE "Senior Tenure" TO WS-TENURE-BAND-TEXT
           END-EVALUATE.

       DETERMINE-BONUS-TIER.
           EVALUATE TRUE ALSO TRUE
               WHEN LOW-PERFORMER     ALSO JUNIOR-TENURE
               WHEN LOW-PERFORMER     ALSO MID-TENURE
               WHEN AVERAGE-PERFORMER ALSO JUNIOR-TENURE
                   MOVE "BRONZE" TO WS-BONUS-TIER
                   MOVE .05     TO WS-BONUS-PERCENT
                   MOVE 05      TO WS-BONUS-PCT-DISPLAY

               WHEN LOW-PERFORMER     ALSO SENIOR-TENURE
               WHEN AVERAGE-PERFORMER ALSO MID-TENURE
               WHEN HIGH-PERFORMER    ALSO JUNIOR-TENURE
                   MOVE "SILVER" TO WS-BONUS-TIER
                   MOVE .10     TO WS-BONUS-PERCENT
                   MOVE 10      TO WS-BONUS-PCT-DISPLAY

               WHEN AVERAGE-PERFORMER ALSO SENIOR-TENURE
               WHEN HIGH-PERFORMER    ALSO MID-TENURE
                   MOVE "GOLD"   TO WS-BONUS-TIER
                   MOVE .15     TO WS-BONUS-PERCENT
                   MOVE 15      TO WS-BONUS-PCT-DISPLAY

               WHEN HIGH-PERFORMER    ALSO SENIOR-TENURE
                   MOVE "PLATINUM" TO WS-BONUS-TIER
                   MOVE .20        TO WS-BONUS-PERCENT
                   MOVE 20         TO WS-BONUS-PCT-DISPLAY
           END-EVALUATE.

       CALCULATE-BONUS.
           COMPUTE WS-BONUS-AMOUNT ROUNDED =
               WS-BASE-SALARY * WS-BONUS-PERCENT.

       DISPLAY-VALID-RESULT.
           DISPLAY " ".
           DISPLAY "Employee Name    : " WS-EMPLOYEE-NAME.
           DISPLAY "Department       : " WS-DEPT-CODE.
           DISPLAY "Performance      : " WS-PERFORMANCE-RATING
               " (" WS-PERF-BAND-TEXT ")".
           DISPLAY "Years of Service : " WS-YEARS-SERVICE
               " (" WS-TENURE-BAND-TEXT ")".
           DISPLAY WS-SEPARATOR.
           DISPLAY "Bonus Tier       : " WS-BONUS-TIER.
           DISPLAY "Bonus Percent    : " WS-BONUS-PCT-DISPLAY "%".
           DISPLAY "Bonus Amount     : " WS-BONUS-AMOUNT.
           DISPLAY " ".

       DISPLAY-INVALID-RESULT.
           DISPLAY " ".
           DISPLAY "Employee Name    : " WS-EMPLOYEE-NAME.
           DISPLAY WS-SEPARATOR.
           DISPLAY "No bonus was calculated.".
           DISPLAY " ".
