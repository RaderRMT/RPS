MESSAGE_POSITION = $0000 ; 2 bytes

;
; Initialize the LCD
; This takes no parameters
;
init_lcd:
  lda #$02
  sta PORTB
  ora #E
  sta PORTB
  and #$0F
  sta PORTB

  lda #%00101000        ; Set 4-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00001110        ; Display on; Cursor on; Blink off
  jsr lcd_instruction
  lda #%00000110        ; Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda #%00000001        ; Clear display
  jsr lcd_instruction

  rts


;
; Print a null-terminated string to the LCD
;
; Parameters:
;   - A: The string's address's least significant byte
;   - Y: The string's address's most significant byte
;
print_string:
  sta MESSAGE_POSITION
  sty MESSAGE_POSITION + 1

  ldy #0
.print_next_char:
  lda (MESSAGE_POSITION), y
  beq .end_print
  jsr print_char
  iny
  jmp .print_next_char

.end_print:
  rts


;
; Print a character to the LCD
;
; Parameters:
;   - A: The character to send
;
print_char:
  jsr lcd_wait

  pha
  lsr
  lsr
  lsr
  lsr
  ora #RS
  sta PORTB
  ora #E
  sta PORTB
  eor #E
  sta PORTB
  pla
  and #$0F
  ora #RS
  sta PORTB
  ora #E
  sta PORTB
  eor #E
  sta PORTB

  rts



;=======================;
;                       ;
;    Private methods    ;
;                       ;
;=======================;


;
; Wait until the LCD is not busy anymore
; This takes no parameters
;
lcd_wait:
  pha
  lda #%11110000 ; set lcd data to input
  sta DDRB

.lcd_busy:
  ; read high nibble
  lda #RW
  sta PORTB
  lda #(RW | E)
  sta PORTB
  lda PORTB
  ; the high nibble contains the busy flag
  ; so we push it on the stack to not lose it
  pha

  ; read low nibble
  lda #RW
  sta PORTB
  lda #(RW | E)
  sta PORTB
  lda PORTB
  ; we pull the high nibble from the stack,
  ; that overwrites the accumulator but we don't care
  pla

  and #$08
  bne .lcd_busy

  lda #RW
  sta PORTB
  lda #$FF ; set all pins of portb to output
  sta DDRB
  pla
  rts

;
; Sends an instruction to the LCD
;
; Parameters:
;   - A: The instruction to send
;
lcd_instruction:
  jsr lcd_wait

  pha
  lsr
  lsr
  lsr
  lsr
  sta PORTB
  ora #E
  sta PORTB
  eor #E
  sta PORTB
  pla
  and #$0F
  sta PORTB
  ora #E
  sta PORTB
  eor #E
  sta PORTB

  rts
