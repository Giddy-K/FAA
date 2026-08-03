      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 23, 2026
      *> PURPOSE: Address Formatter - reads raw, inconsistently
      *>          formatted addresses from ADDRESSES.DAT, collapses
      *>          space runs and title-cases the street and city
      *>          using UNSTRING/STRING with intrinsic functions,
      *>          validates the postal code length, and writes one
      *>          clean record per input line to CLEAN-ADDRESSES.DAT.
      *>
      *> NOTE: per the correction to this morning's INSPECT REPLACING
      *> demo, space-collapsing is done via TRIM + UNSTRING DELIMITED
      *> BY ALL SPACE, not INSPECT REPLACING (which requires equal-
      *> length search/replacement strings and cannot shrink "  " to
      *> " ").

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ADDRESS-FORMATTER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ADDRESS-FILE       ASSIGN TO "ADDRESSES.DAT"
                  ORGANIZATION IS LINE SEQUENTIAL.
           SELECT CLEAN-ADDRESS-FILE ASSIGN TO "CLEAN-ADDRESSES.DAT"
                  ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  ADDRESS-FILE.
       01  ADDRESS-RECORD       PIC X(60).

       FD  CLEAN-ADDRESS-FILE.
       01  CLEAN-ADDRESS-RECORD PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-EOF-FLAG        PIC X       VALUE "N".
       01  WS-RAW-STREET      PIC X(30).
       01  WS-RAW-CITY        PIC X(20).
       01  WS-RAW-POSTAL      PIC X(6).
       01  WS-TRIMMED         PIC X(30).
       01  WS-WORD-1          PIC X(15).
       01  WS-WORD-2          PIC X(15).
       01  WS-WORD-3          PIC X(15).
       01  WS-WORD-4          PIC X(15).
       01  WS-CLEAN-STREET    PIC X(40).
       01  WS-CLEAN-CITY      PIC X(40).
       01  WS-POSTAL-LEN      PIC 9(2).
       01  WS-STATUS          PIC X(7).

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           OPEN INPUT  ADDRESS-FILE
           OPEN OUTPUT CLEAN-ADDRESS-FILE

           PERFORM UNTIL WS-EOF-FLAG = "Y"
               READ ADDRESS-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-FLAG
                   NOT AT END
      *>               TODO 1: split the raw comma-separated line
      *>               into its three raw fields.
                       UNSTRING ADDRESS-RECORD DELIMITED BY ","
                           INTO WS-RAW-STREET,
                                WS-RAW-CITY,
                                WS-RAW-POSTAL
                       END-UNSTRING

                       PERFORM CLEAN-STREET
      *>               TODO 2: clean the city the same way the
      *>               street is cleaned above.
                       PERFORM CLEAN-CITY

      *>               TODO 3: validate the postal code length
      *>               after trimming it, and set WS-STATUS.
                       COMPUTE WS-POSTAL-LEN =
                           FUNCTION LENGTH(FUNCTION TRIM(WS-RAW-POSTAL))

                       IF WS-POSTAL-LEN = 5
                           MOVE "VALID"   TO WS-STATUS
                       ELSE
                           MOVE "INVALID" TO WS-STATUS
                       END-IF

      *>               TODO 4: build and write the clean output
      *>               record from the cleaned street, cleaned
      *>               city, trimmed postal code, and status.
                       MOVE SPACES TO CLEAN-ADDRESS-RECORD
                       STRING
                           FUNCTION TRIM(WS-CLEAN-STREET) DELIMITED BY SIZE
                           ", "                            DELIMITED BY SIZE
                           FUNCTION TRIM(WS-CLEAN-CITY)   DELIMITED BY SIZE
                           ", "                            DELIMITED BY SIZE
                           FUNCTION TRIM(WS-RAW-POSTAL)   DELIMITED BY SIZE
                           ", "                            DELIMITED BY SIZE
                           FUNCTION TRIM(WS-STATUS)       DELIMITED BY SIZE
                           INTO CLEAN-ADDRESS-RECORD
                       END-STRING

                       WRITE CLEAN-ADDRESS-RECORD
               END-READ
           END-PERFORM

           CLOSE ADDRESS-FILE, CLEAN-ADDRESS-FILE
           STOP RUN.

       CLEAN-STREET.
      *> WORKED EXAMPLE - this exact pattern is followed by
      *> CLEAN-CITY below: trim, split into words, title-case
      *> each word, rebuild with single spaces.
           MOVE FUNCTION TRIM(WS-RAW-STREET) TO WS-TRIMMED
           MOVE SPACES TO WS-WORD-1 WS-WORD-2 WS-WORD-3 WS-WORD-4

           UNSTRING WS-TRIMMED DELIMITED BY ALL SPACE
               INTO WS-WORD-1, WS-WORD-2, WS-WORD-3, WS-WORD-4
           END-UNSTRING

           IF WS-WORD-1 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-1) TO WS-WORD-1
               MOVE FUNCTION UPPER-CASE(WS-WORD-1(1:1))
                   TO WS-WORD-1(1:1)
           END-IF
           IF WS-WORD-2 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-2) TO WS-WORD-2
               MOVE FUNCTION UPPER-CASE(WS-WORD-2(1:1))
                   TO WS-WORD-2(1:1)
           END-IF
           IF WS-WORD-3 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-3) TO WS-WORD-3
               MOVE FUNCTION UPPER-CASE(WS-WORD-3(1:1))
                   TO WS-WORD-3(1:1)
           END-IF

           MOVE SPACES TO WS-CLEAN-STREET
           STRING WS-WORD-1 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-2 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-3 DELIMITED BY SPACE
                  INTO WS-CLEAN-STREET
           END-STRING.

       CLEAN-CITY.
      *> Same pattern as CLEAN-STREET, applied to WS-RAW-CITY
      *> instead, with the result stored in WS-CLEAN-CITY.
           MOVE FUNCTION TRIM(WS-RAW-CITY) TO WS-TRIMMED
           MOVE SPACES TO WS-WORD-1 WS-WORD-2 WS-WORD-3 WS-WORD-4

           UNSTRING WS-TRIMMED DELIMITED BY ALL SPACE
               INTO WS-WORD-1, WS-WORD-2, WS-WORD-3, WS-WORD-4
           END-UNSTRING

           IF WS-WORD-1 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-1) TO WS-WORD-1
               MOVE FUNCTION UPPER-CASE(WS-WORD-1(1:1))
                   TO WS-WORD-1(1:1)
           END-IF
           IF WS-WORD-2 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-2) TO WS-WORD-2
               MOVE FUNCTION UPPER-CASE(WS-WORD-2(1:1))
                   TO WS-WORD-2(1:1)
           END-IF
           IF WS-WORD-3 NOT = SPACES
               MOVE FUNCTION LOWER-CASE(WS-WORD-3) TO WS-WORD-3
               MOVE FUNCTION UPPER-CASE(WS-WORD-3(1:1))
                   TO WS-WORD-3(1:1)
           END-IF

           MOVE SPACES TO WS-CLEAN-CITY
           STRING WS-WORD-1 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-2 DELIMITED BY SPACE
                  " "       DELIMITED BY SIZE
                  WS-WORD-3 DELIMITED BY SPACE
                  INTO WS-CLEAN-CITY
           END-STRING.
