;      Author: Matthew Healy   <mhealy@mst.edu>
;              Jaxson Johnston <jnjt37@mst.edu>
;              Lukas Grbesa    <lgqq3@mst.edu>
;       Group: NULL
;        Date: 29 November 2017
;     License: MIT License
; Description: This program simulates the functionality of a
;              carry lookahead fast adder using an 8051 microcontroller.
;              Since this is a software simulation, it does not perform as
;              quickly as an implementation in logic gates, but it serves
;              as a proof-of-concept.

        MOV R3, #40H   ; #10H bit
        MOV R0, #48H   ; #40H bit
        MOV R1, #50H   ; #70H bit
        MOV R5, R2     ; length of operands stored in R2

  LOAD: MOV R4, @R0    ; temp hold for byte of R6 data
        XRL @R0, @R1   ; propagate
        ANL @R1, R4    ; generate
        INC R0         ; move to next bit of P
        INC R1         ; move to next bit of G
        DNJZ R5, LOAD

        MOV R5, R2     ; reset R5
        MUL R5, #8H    ; switch to bit counter
        MOV R5, A      ; load counter with length*8
        CLR C          ; C will be used as Ci in boolean equation
        MOV R0, #040H  ; bit addr
        MOV R1, #070H  ; bit addr

 CARRY: ANL C, @R0     ; intermediate = Ci AND P(i+1)
        ORL C, @R1     ; C(i+1) = intermediate OR G(i+1)
        MOV @R1, C     ; store C(i+1) in carry string
        INC R3         ; move to next bit of carry string
        INC R0         ; move to next bit of P
        INC R1         ; move to next bit of G
        DJNZ R5, CARRY

        MOV R1, #40H   ; reload R3 with start of carry string
        MOV R0, #48H   ; reload R6 with start of P
        MOV R5, R2     ; reload counter with length

   SUM: XRL @R0 @R1    ; compute final sum
        INC R0         ; move to next bit of P
        INC R1         ; move to next bit of Carry string
        DJNZ R5, SUM

        MOV R0, #48H   ; reset R6 to beginning of result string
        RET            ; result string pointed to by R6
