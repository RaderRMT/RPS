build:
	vasm6502_oldstyle -Fbin -dotdir -c02 src/main.s

write:
	minipro -p 28C256 -w a.out

all: build write
