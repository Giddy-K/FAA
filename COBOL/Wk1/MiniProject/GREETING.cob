       IDENTIFICATION DIVISION.
       PROGRAM-ID. GREETING.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MY-NAME PIC X(20).
       PROCEDURE DIVISION.
           MOVE 'Gideon' TO MY-NAME.
           DISPLAY 'Hello, ' MY-NAME.
           DISPLAY 'Welcome to COBOL!'.
           STOP RUN.
