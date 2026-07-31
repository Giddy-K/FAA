      *> AUTHOR: Gideon Kipamet Kaiyian
      *> DATE: July 20, 2026
      *> PURPOSE: Inventory Management - OCCURS table, SEARCH, and
      *>          table totalling exercise. Stores 10 products in an
      *>          OCCURS table, produces a stock report with total
      *>          inventory value, and supports repeated product
      *>          lookup by code.
      *>
      *> ASSUMPTION: Product code search is case-SENSITIVE - typing
      *> "p001" (lowercase) is treated as not found, since the table
      *> is populated with uppercase codes and no case-folding is
      *> applied to the entered search code. (See test case 4.)

       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVENTORY.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> ---------------------------------------------------------
      *> Raw product data, hard-coded via VALUE clauses. Each 34-byte
      *> line packs CODE(4) + NAME(20) + PRICE(7 digits, 9(5)V99)
      *> + QTY(3 digits, 9(3)) with no separators, in table order.
      *> This area is REDEFINED below as the actual OCCURS table.
      *> ---------------------------------------------------------
       01 WS-PRODUCT-DATA.
           05 FILLER PIC X(34) VALUE "P001Rice 5kg            0085000040".
           05 FILLER PIC X(34) VALUE "P002Cooking Oil 2L      0065000025".
           05 FILLER PIC X(34) VALUE "P003Sugar 2kg           0032000060".
           05 FILLER PIC X(34) VALUE "P004Wheat Flour 2kg     0028000045".
           05 FILLER PIC X(34) VALUE "P005Tea Leaves 500g     0041000030".
           05 FILLER PIC X(34) VALUE "P006Bar Soap            0008500100".
           05 FILLER PIC X(34) VALUE "P007Toothpaste          0017500080".
           05 FILLER PIC X(34) VALUE "P008Milk Powder 400g    0056000020".
           05 FILLER PIC X(34) VALUE "P009Salt 1kg            0004500120".
           05 FILLER PIC X(34) VALUE "P010Detergent 1kg       0031000035".

       01 WS-PRODUCT-TABLE REDEFINES WS-PRODUCT-DATA.
           05 WS-PRODUCT OCCURS 10 TIMES INDEXED BY WS-IDX.
               10 WS-CODE          PIC X(4).
               10 WS-NAME          PIC X(20).
               10 WS-PRICE         PIC 9(5)V99.
               10 WS-QTY           PIC 9(3).

       01 WS-VALUE                 PIC 9(8)V99.
       01 WS-TOTAL-VALUE           PIC 9(9)V99.

       01 WS-SEARCH-CODE           PIC X(4).
       01 WS-FOUND-FLAG            PIC X       VALUE "N".
           88 CODE-FOUND               VALUE "Y".
           88 CODE-NOT-FOUND            VALUE "N".

       01 WS-SEARCH-AGAIN           PIC X       VALUE "Y".
           88 SEARCH-AGAIN               VALUE "Y", "y".

       01 WS-SEPARATOR              PIC X(58)   VALUE ALL "-".
       01 WS-DOUBLE-SEPARATOR       PIC X(58)   VALUE ALL "=".

       PROCEDURE DIVISION.

       MAIN-PARA.
           PERFORM PRINT-STOCK-REPORT
           PERFORM SEARCH-LOOP
           STOP RUN.

      *> ---------------------------------------------------------
      *> Loop over all 10 table entries once, using PERFORM VARYING,
      *> to display each product's row and accumulate the grand
      *> total. The total is computed here, never hard-coded.
      *> ---------------------------------------------------------
       PRINT-STOCK-REPORT.
           MOVE ZERO TO WS-TOTAL-VALUE

           DISPLAY WS-DOUBLE-SEPARATOR
           DISPLAY "                 STOCK REPORT"
           DISPLAY WS-DOUBLE-SEPARATOR
           DISPLAY "CODE  NAME                    PRICE      QTY      VALUE"
           DISPLAY WS-SEPARATOR

           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > 10

               COMPUTE WS-VALUE =
                   WS-PRICE (WS-IDX) * WS-QTY (WS-IDX)

               ADD WS-VALUE TO WS-TOTAL-VALUE

               DISPLAY WS-CODE (WS-IDX) "  "
                   WS-NAME (WS-IDX) "  "
                   WS-PRICE (WS-IDX) "  "
                   WS-QTY (WS-IDX) "  "
                   WS-VALUE
           END-PERFORM

           DISPLAY WS-SEPARATOR
           DISPLAY "TOTAL INVENTORY VALUE:                          "
               WS-TOTAL-VALUE
           DISPLAY WS-DOUBLE-SEPARATOR.

      *> ---------------------------------------------------------
      *> Repeated search: prompts for a code, searches the table,
      *> and asks the user whether to search again.
      *> ---------------------------------------------------------
       SEARCH-LOOP.
           PERFORM UNTIL NOT SEARCH-AGAIN
               PERFORM DO-ONE-SEARCH
               DISPLAY " "
               DISPLAY "Search again? (Y/N): "
               ACCEPT WS-SEARCH-AGAIN
           END-PERFORM.

       DO-ONE-SEARCH.
           DISPLAY " "
           DISPLAY "Enter product code to search: "
           ACCEPT WS-SEARCH-CODE

      *>   SET the index to 1 before every SEARCH, as required -
      *>   otherwise a search after the first would resume from
      *>   wherever the previous SEARCH left the index.
           SET WS-IDX TO 1
           MOVE "N" TO WS-FOUND-FLAG

           SEARCH WS-PRODUCT
               AT END
                   MOVE "N" TO WS-FOUND-FLAG
               WHEN WS-CODE (WS-IDX) = WS-SEARCH-CODE
                   MOVE "Y" TO WS-FOUND-FLAG
           END-SEARCH

           IF CODE-FOUND
               COMPUTE WS-VALUE =
                   WS-PRICE (WS-IDX) * WS-QTY (WS-IDX)
               DISPLAY "Product Found:"
               DISPLAY "  Code     : " WS-CODE (WS-IDX)
               DISPLAY "  Name     : " WS-NAME (WS-IDX)
               DISPLAY "  Price    : " WS-PRICE (WS-IDX)
               DISPLAY "  Quantity : " WS-QTY (WS-IDX)
               DISPLAY "  Value    : " WS-VALUE
           ELSE
               DISPLAY "Product not found: " WS-SEARCH-CODE
           END-IF.
