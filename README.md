# 313HW11
DESC: The program loops through a list of bytes and splits each byte into two nibbles. 
It then takes the nibbles and converts them to their ASCII version. 
It then stores the results in the output buffer and prints them with a space between bytes.

Compilation Instructions: 
nasm -f elf hw11translate2Ascii.asm
gcc -m32 -o hw11translate2Ascii hw11translate2Ascii.o

Run:
./hw11translate2Ascii
