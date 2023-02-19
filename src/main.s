  .org $8000

  .include src/utils/via.s
  .include src/utils/screen.s

main:
  jsr init_via
  jsr init_lcd

  lda #<message
  ldy #>message
  jsr print_string

loop:
  jmp loop

message: .asciiz "Hello, world!"

  .org $FFFC
  .word main
  .word $0000
