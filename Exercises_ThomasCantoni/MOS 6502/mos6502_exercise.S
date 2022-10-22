.org $8000
start:
    LDX #$FF    ; number of clear stack
    TXS         ; transfer x to stack

    LDA #05     ;
    STA $05    
    LDA #0
    STA $00
    LDY #0
    LDA #0      
    JSR clear_crt
    LDX #0
    LDA #0
    JSR clear_zero_page_loop

    LDX #0 ; starting x point of the dot
    STX $06
    LDX #0 ; starting y point of the dot
    STX $07
    
    LDX #1   ; increase y = go up
    STX $00
    LDX #2   ; decrease y = go down
    STX $01
    LDX #4   ; decrease x = go left
    STX $02
    LDX #8   ; increase x = go right
    STX $03

    LDA #05     ;
    STA $05 
    JMP game_loop

clear_zero_page_loop:
    STA $06,X
    INX
    BNE clear_zero_page_loop
    RTS

clear_crt:
    STA $06,X
    INX
    BNE clear_crt
    RTS

game_loop:
    
    LDA $4000
    CMP $00
    BEQ move_up
    LDA $4000
    CMP $01
    BEQ move_down
    LDA $4000
    CMP $02
    BEQ move_left
    LDA $4000
    CMP $03
    BEQ move_right

colorPosition:
    JSR update_position
    LDA $05
    STA $0200,X
    JMP game_loop

update_position:
    CLC     ;otherwise cell is not cleared properly
    LDA #0  
    ADC $07
    ASL A
    ASL A
    ASL A
    ASL A
    ADC $06
    STA $08     ; momentarily store Accumulator's value in a new address to move it to X
    LDX $08     ; i read A's value and move it to x
    RTS

move_up:
    JSR removePreviousCell
    SEC
    LDA $07
    SBC #1
    JSR clear_leftmost_halfbyte
    STA $07
    CLC
    JMP colorPosition

move_down:
    JSR removePreviousCell
    LDA $07
    ADC #1
    
    JSR clear_leftmost_halfbyte
    STA $07
    CLC
    JMP colorPosition

move_left:
    JSR removePreviousCell
    SEC
    LDA $06
    SBC #1
    JSR clear_leftmost_halfbyte
    STA $06
    CLC
    JMP colorPosition

move_right:
    JSR removePreviousCell
    LDA $06
    ADC #1
    JSR clear_leftmost_halfbyte
    STA $06
    CLC
    JMP colorPosition

clear_leftmost_halfbyte:        
        ; I DO THIS TO PREVENT INACCURATE MOVEMENT AND SQUARE MOVING DOWN/UP ON HORIZONTAL OVERFLOW
        ; when i move, i am adding numbers to either $06 or $07 , when i reach 16 it counts up a digit so the square goes up or down
        ; in order to prevent this i just clear the most significative nibble with shifting all bits left then back to the right
    ASL A
    ASL A
    ASL A
    ASL A
    LSR A
    LSR A
    LSR A
    LSR A
    RTS

removePreviousCell:
    JSR update_position
    LDA #0
    STA $0200,X
    RTS

.goto $FFFA
.dw start
.dw start
.dw start