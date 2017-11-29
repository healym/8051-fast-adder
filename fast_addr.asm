; kiel compiler

        MOV R3, #40H   ; #10H bit
        MOV R6, #48H   ; #40H bit
        MOV R7, #50H   ; #70H bit
        MOV R5, R2     ; length of operands stored in R2

  LOAD: MOV R4, @R6    ; temp hold for byte of R6 data
        XRL @R6, @R7   ; propagate
        ANL @R7, R4    ; generate
        INC R6
        INC R7
        DNJZ R5, LOAD

        MOV R5, R2     ; reset R5
        MUL R5, #8H    ; switch to bit counter
        MOV R5, A
        CLR C
        MOV R6, #040H  ; bit addr
        MOV R7, #070H  ; bit addr
 CARRY: ANL C, @R6
        ORL C, @R7
        MOV @R3, C
        INC R3
        INC R6
        INC R7
        DJNZ R5, CARRY

        MOV R5, #8H
   SUM: XRL @R6 @R3
        INC R6
        INC R3
        DJNZ R5, SUM   ; result is in @R6
