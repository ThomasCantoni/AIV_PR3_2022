.org $8000
start:
LDX #$FF 
TXS

LDA #$17
LDA #1 ;red
LDX #0 ;offset

loop:
LDA $4000
ASL A
BEQ start
STA $0200,X                         ; 0x0200 + x ;

INX
JSR dummyfunc
BNE loop

JMP start

dummyfunc:
LDY #5
RTS 

.goto $FFFA
.dw start ; non maskable
.dw start ; reset
.dw start ; interrupt


moveup:         ;bitmask is 000001 => hex 1

movedown:       ;bitmask is 000010 => hex 2

moveleft:       ;bitmask is 000100 => hex 4
DEX
moveright:      ;bitmask is 001000 => hex 8
INX