      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 12, 2026
      *> PURPOSE: Student Marks Processor - Week 3 Session 2 practice
      *>          exercise. Reads 10 marks one at a time with PERFORM
      *>          UNTIL, tracking a running total, highest, and lowest
      *>          without using an OCCURS table.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. MARKSPROC.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-MARK              PIC 999.
       01 WS-COUNTER            PIC 99.
       01 WS-TOTAL              PIC 9(4).
       01 WS-AVERAGE            PIC 999V99.
       01 WS-HIGHEST            PIC 999.
       01 WS-LOWEST             PIC 999.
       01 WS-SEPARATOR          PIC X(40) VALUE ALL "-".

       PROCEDURE DIVISION.

       MAIN-PARA.
           MOVE 1 TO WS-COUNTER
           MOVE 0 TO WS-TOTAL

           PERFORM UNTIL WS-COUNTER > 10
               DISPLAY "Enter mark " WS-COUNTER " (0-100): "
               ACCEPT WS-MARK

               ADD WS-MARK TO WS-TOTAL

               IF WS-COUNTER = 1
      *>           Seed highest/lowest from the FIRST mark read,
      *>           never from 0 - a mark of 0 is a valid low score.
                   MOVE WS-MARK TO WS-HIGHEST
                   MOVE WS-MARK TO WS-LOWEST
               ELSE
                   IF WS-MARK > WS-HIGHEST
                       MOVE WS-MARK TO WS-HIGHEST
                   END-IF
                   IF WS-MARK < WS-LOWEST
                       MOVE WS-MARK TO WS-LOWEST
                   END-IF
               END-IF

               ADD 1 TO WS-COUNTER
           END-PERFORM

           COMPUTE WS-AVERAGE ROUNDED = WS-TOTAL / 10

           DISPLAY " "
           DISPLAY "Marks entered   : 10"
           DISPLAY WS-SEPARATOR
           DISPLAY "Class Total     : " WS-TOTAL
           DISPLAY "Class Average   : " WS-AVERAGE
           DISPLAY "Highest Mark    : " WS-HIGHEST
           DISPLAY "Lowest Mark     : " WS-LOWEST
           DISPLAY " "

           STOP RUN.
