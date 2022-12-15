IDENTIFICATION DIVISION.
PROGRAM-ID. matrix-reader.

DATA DIVISION.

WORKING-STORAGE SECTION.

01 matrix.
   05 row PIC X(99) OCCURS 99.

01 i PIC 9(4) VALUE ZERO.
01 j PIC 9(4) VALUE ZERO.
01 l PIC 9(4) VALUE ZERO.
01 k PIC 9(4) VALUE ZERO.
01 GOOD PIC 9(8) VALUE ZERO.
01 SCORE PIC 9(8) VALUE ZERO.
01 BEST PIC 9(8) VALUE ZERO.
01 LEN PIC 9(8) VALUE ZERO.

PROCEDURE DIVISION.

read-matrix.
   PERFORM VARYING l FROM 1 BY 1 UNTIL l > 99
      ACCEPT row(l)
   END-PERFORM.

solve.
    MOVE 0 to BEST.
    PERFORM VARYING i FROM 3 BY 1 UNTIL i > 99
        PERFORM VARYING j FROM 2 BY 1 UNTIL j > 99
            MOVE 1 TO SCORE
            
            COMPUTE LEN = j - 1
            PERFORM VARYING l FROM 1 BY 1 UNTIL j - l <= 0
                COMPUTE k = j - l
                IF row(i)(k:1) >= row(i)(j:1)  AND LEN > l
                    MOVE l TO LEN
                END-IF
            END-PERFORM
            COMPUTE SCORE = SCORE * LEN
            COMPUTE LEN = 99 - j
            PERFORM VARYING l FROM 1 BY 1 UNTIL l + j > 99
                COMPUTE k = l + j
                IF row(i)(k:1) >= row(i)(j:1)  AND LEN > l
                    MOVE l TO LEN
                END-IF
            END-PERFORM
            
            COMPUTE SCORE = SCORE * LEN
            
            
            COMPUTE LEN = i - 1
            PERFORM VARYING l FROM 1 BY 1 UNTIL l >= i
                COMPUTE k = i - l
                IF row(k)(j:1) >= row(i)(j:1) AND LEN > l
                    MOVE l TO LEN
                END-IF
            END-PERFORM
            COMPUTE SCORE = SCORE * LEN
            

            COMPUTE LEN = 99 - i
            PERFORM VARYING l FROM 1 BY 1 UNTIL l + i > 99
                IF row(l + i)(j:1) >= row(i)(j:1) AND LEN > l
                    MOVE l TO LEN
                END-IF
            END-PERFORM
            COMPUTE SCORE = SCORE * LEN
            IF SCORE > BEST
                MOVE SCORE TO BEST
            END-IF
        END-PERFORM
    END-PERFORM.
    DISPLAY BEST
GOBACK.

