IDENTIFICATION DIVISION.
PROGRAM-ID. matrix-reader.

DATA DIVISION.

WORKING-STORAGE SECTION.

01 matrix.
   05 row PIC X(100) OCCURS 100.

01 i PIC 9(3) VALUE ZERO.
01 j PIC 9(3) VALUE ZERO.
01 l PIC 9(3) VALUE ZERO.
01 k PIC 9(3) VALUE ZERO.
01 GOOD PIC 9(3) VALUE ZERO.
01 WORKS PIC 9(3) VALUE ZERO.
01 total PIC 9(4) VALUE ZERO.
01 cnt PIC 9(4) VALUE ZERO.

PROCEDURE DIVISION.

read-matrix.
   PERFORM VARYING l FROM 0 BY 1 UNTIL l >= 99
      ACCEPT row(l)
      DISPLAY row(l)
   END-PERFORM.

solve.
    MOVE 0 to total.
    MOVE 0 to cnt.
    PERFORM VARYING i FROM 0 BY 1 UNTIL i >= 99
        PERFORM VARYING j FROM 1 BY 1 UNTIL j > 99
            ADD 1 TO cnt
            MOVE 1 TO GOOD
            MOVE 0 TO WORKS
            
            PERFORM VARYING l FROM 1 BY 1 UNTIL l >= j
                IF row(i)(l:1) >= row(i)(j:1)
                    MOVE 0 TO GOOD
                END-IF
            END-PERFORM
            IF GOOD > 0
                MOVE 1 TO WORKS
            END-IF
        
            MOVE 1 TO GOOD
            PERFORM VARYING l FROM 1 BY 1 UNTIL l + j > 99
                COMPUTE k = l + j
                IF row(i)(k:1) >= row(i)(j:1)
                    MOVE 0 TO GOOD
                END-IF
            END-PERFORM
            IF GOOD > 0
                MOVE 1 TO WORKS
            END-IF
            
            MOVE 1 TO GOOD
            PERFORM VARYING l FROM 0 BY 1 UNTIL l >= i
                IF row(l)(j:1) >= row(i)(j:1)
                    MOVE 0 TO GOOD
                END-IF
            END-PERFORM
            IF GOOD > 0
                MOVE 1 TO WORKS
            END-IF
            
            MOVE 1 TO GOOD
            PERFORM VARYING l FROM 1 BY 1 UNTIL l + i >= 99
                COMPUTE k = l + i
                IF row(k)(j:1) >= row(i)(j:1)
                    MOVE 0 TO GOOD
                END-IF
            END-PERFORM
            IF GOOD > 0
                MOVE 1 TO WORKS
            END-IF
            
            
            IF WORKS > 0
                ADD 1 TO total
            END-IF
        END-PERFORM
    END-PERFORM.
    DISPLAY total
    DISPLAY cnt
GOBACK.

