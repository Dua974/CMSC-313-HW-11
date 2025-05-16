section .data
inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
inputLen equ $ - inputBuf        ; Number of bytes in inputBuf (8 bytes total)
newline db 0x0A                  ; newline char

section .bss
outputBuf resb 80                ; enough for translations

section .text
global _start

_start:
    mov esi, inputBuf            ; ESI points to the current input byte
    mov edi, outputBuf           ; EDI points to the current write position in output buffer
    mov ecx, inputLen            ; how many bytes to translate

translate_loop:
    lodsb                        ; load byte from [ESI] into AL and increment ESI
    call byteToHex               ; convert AL to 2 ASCII hex characters → stored at [EDI]
    add edi, 2                   ;  Move to next write position in outputBuf
    loop translate_loop

    ; append newline
    mov byte [edi], 0x0A         ; Append newline to end the printed output cleanly
    inc edi

    ; write to stdout
    mov eax, 4                   ; syscall: sys_write
    mov ebx, 1                   ; file descriptor 1 = stdout
    mov ecx, outputBuf
    sub edi, outputBuf           ; length = current edi - start of outputBuf
    mov edx, edi                 ; EDX = number of bytes to printed
    int 0x80                     ; will show to screen

    ; exit
    mov eax, 1                   ; syscall: sys_exit
    xor ebx, ebx
    int 0x80

; ========== SUBROUTINE Part from HW for extra credit ========== 
; Converts byte in AL to two ASCII hex characters stored at [EDI]
byteToHex:
    push eax
    push ebx                    ; Save EBX

    mov bl, al
    shr bl, 4                    ; upper nibble
    call nibbleToAscii           ; Convert upper nibble to ASCII
    mov [edi], al                ; Store ASCII char in output buffer

    pop eax
    push eax

    mov bl, al
    and bl, 0x0F                 ; lower nibble
    call nibbleToAscii
    mov [edi+1], al              ; Store second ASCII char

    pop ebx
    pop eax
    ret                           ; Return to caller

; Converts nibble in BL to ASCII (0-9 -> '0'-'9', 10-15 -> 'A'-'F')
nibbleToAscii:
    cmp bl, 9                   ;  Is the nibble <= 9?
    jbe .is_digit               ; If yes, it’s a digit (0-9)
    add bl, 55                  ; 'A' = 65, A(10) + 55 = 65
    mov al, bl
    ret
.is_digit:
    add bl, '0'                ; Convert 0-9 to ASCII by adding ASCII value of '0'
    mov al, bl
    ret
