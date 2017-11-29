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

        MOV 40H,         ; Input A
        MOV 41H,
        MOV 42H,
        MOV 43H,
        MOV 44H,
        MOV 45H,
        MOV 46H,
        MOV 47H,

        MOV 48H,        ; Input B
        MOV 49H,
        MOV 4AH,
        MOV 4BH,
        MOV 4CH,
        MOV 4DH,
        MOV 4EH,
        MOV 4FH,

        MOV R2,        ; Length of longest operand

        MOV R0, #40H   ; #40H bit
        MOV R1, #48H   ; #70H bit
        MOV A, R2
        MOV R5, A      ; length of operands stored in R2

        MOV TMOD, #00010000B
        MOV TL1, #00H  ; start timer at 0
        MOV TLH, #00H  ; start timer at 0

INPUTA: MOV P1, @R0    ; output byte of A
        INC R0         ; move to next byte
        DJNZ R5, INPUTA
        MOV R0, #40H   ; reset to beginning of A

        MOV A, R2      ; reset counter
        MOV R5, A
INPUTB: MOV P1, @R1    ; output byte of B
        INC R1
        DJNZ R5, INPUTB
        MOV R1, #48H   ; reset to beginning of B

        SETB TR1       ; start timer
        MOV A, R2      ; init counter
        MOV R5, A
LOAD:   MOV R4, @R0    ; temp hold for byte of R6 data
        MOV A, @R0
        XRL A, @R1     ; propagate
        MOV @R0, A

        MOV A, @R1
        ANL A, R4      ; generate
        MOV @R1, A
        INC R0         ; move to next bit of P
        INC R1         ; move to next bit of G
        DJNZ R5, LOAD

        MOV A, R2      ; reset R5
        MOV B, #8H
        MUL AB         ; switch to bit counter
        MOV R5, A      ; load counter with length*8
        CLR C          ; C will be used as Ci in boolean equation
        MOV R0, #040H  ; bit addr
        MOV R1, #070H  ; bit addr

CARRY:  ANL C, @R0     ; intermediate = Ci AND P(i+1)
        ORL C, @R1     ; C(i+1) = intermediate OR G(i+1)
        MOV @R1, C     ; store C(i+1) in carry string
        INC R0         ; move to next bit of P
        INC R1         ; move to next bit of G
        DJNZ R5, CARRY

        MOV R1, #40H   ; reload R3 with start of carry string
        MOV R0, #48H   ; reload R6 with start of P
        MOV A, R2
        MOV R5, A      ; reload counter with length

SUM:    MOV A, @R0
        XRL A, @R1
        MOV @R0, A     ; compute final sum
        INC R0         ; move to next bit of P
        INC R1         ; move to next bit of Carry string
        DJNZ R5, SUM
        CLR TR1        ; stop timer

TIME:   ; output time on serial

        MOV R0, #48H   ; reset R0 to beginning of result string
OUT:    ; output sum
        RET            ; result string pointed to by R6
