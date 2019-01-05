       IDENTIFICATION DIVISION.
       PROGRAM-ID. SQRT.
      * Calculate square roots of using the Babylonian algorithm,
      * aka Heron's method.
      * Starting with an estimate r0 for the root of s,
      * iteratively improve the estimate using the formula:
      * r(n+1) = (r(n) + s/r(n)) / 2

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 R  PIC S9(3)V9(15) USAGE IS COMPUTATIONAL.
       01 S  PIC S9(3)V9(15) USAGE IS COMPUTATIONAL.
       01 X  PIC 99 USAGE IS COMPUTATIONAL.

       PROCEDURE DIVISION.
       SQRT.
           DISPLAY "Enter square: " WITH NO ADVANCING END-DISPLAY
           ACCEPT S END-ACCEPT.
           COMPUTE R = S / 2 END-COMPUTE
           PERFORM VARYING X FROM 0 BY 1 UNTIL X > 25 
                   COMPUTE R = (R + S / R) / 2 END-COMPUTE
           END-PERFORM
           DISPLAY "sqrt(", S, ") = ", R END-DISPLAY.
           STOP RUN.
