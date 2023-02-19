PORTB = $6000
PORTA = $6001

DDRB = $6002
DDRA = $6003

E  = %01000000
RW = %00100000
RS = %00010000

init_via:
  lda #$FF              ; Set PORT B to output
  sta DDRB

  lda #%00000000        ; Set PORT A to input
  sta DDRA
  rts
