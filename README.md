# CMSC-313-HW-11

#How to compile and execute code: 
all:
	nasm -f elf hw11translate2Ascii.asm
	ld -m elf_i386 -o hw11translate2Ascii hw11translate2Ascii.o

clean:
	rm -f *.o hw11translate2Ascii

### Commands:
```bash
make
./hw11translate2Ascii

#To clean up just do:
make clean


#Description of what the program does:
An output buffer (outputBuf) is used to store the results of this program's translation of a predetermined array of eight binary data
bytes (inputBuf) into their two-digit hexadecimal (base-16) ASCII representation. The upper four bits of each byte (for instance, 0x83)
are referred to as the high nibble, and the lower four bits are known as the low nibble. A subroutine named nibbleToAscii is then used to transform each of these nibbles into ASCII characters separately. Hexadecimal digits are represented by the characters '0' through '9'
for values 0–9 and 'A' through 'F' for values 10–15. The byteToHex procedure, which is called once for each byte in the input, does
this conversion.
Each byte in inputBuf is processed by the program using a loop, which then uses the function to convert it and stores the two ASCII characters that are produced in outputBuf. To ensure that the output shows neatly on the terminal, a newline character (0x0A) is
appended to the end of the output buffer after every byte has been translated. Lastly, the program prints the contents of the buffer
to the screen using Linux's sys_write system call. A string of hexadecimal numbers (such as 83 6A 88 DE 9A C3 54 9A → 836A88DE9AC3549A) displayed on a single line is the end result. This procedure illustrates register-level memory operations, system-level output, and basic binary-to-text translation in 32-bit x86 Assembly using NASM.

#Lets say input buffer has: 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A then the output will be: 836A88DE9AC3549A

