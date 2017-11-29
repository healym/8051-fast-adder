; kiel compiler

        MOV R3, #40H   ; #10H bit
        MOV R6, #48H   ; #40H bit
        MOV R7, #50H   ; #70H bit
        MOV R5, R2     ; length of operands stored in R2

  LOAD: MOV R4, @R6    ; temp hold for byte of R6 data
        XRL @R6, @R7   ; propagate
        ANL @R7, R4    ; generate
        INC R6         ; move to next bit of P
        INC R7         ; move to next bit of G
        DNJZ R5, LOAD

        MOV R5, R2     ; reset R5
        MUL R5, #8H    ; switch to bit counter
        MOV R5, A      ; load counter with length*8
        CLR C          ; C will be used as Ci in boolean equation
        MOV R6, #040H  ; bit addr
        MOV R7, #070H  ; bit addr

 CARRY: ANL C, @R6     ; intermediate = Ci AND P(i+1)
        ORL C, @R7     ; C(i+1) = intermediate OR G(i+1)
        MOV @R3, C     ; store C(i+1) in carry string
        INC R3         ; move to next bit of carry string
        INC R6         ; move to next bit of P
        INC R7         ; move to next bit of G
        DJNZ R5, CARRY

        MOV R5, R2     ; reload counter with length
   SUM: XRL @R6 @R3    ; compute final sum
        INC R6         ; move to next bit of P
        INC R3         ; move to next bit of Carry string
        DJNZ R5, SUM
        RET            ; result is in what was P string
