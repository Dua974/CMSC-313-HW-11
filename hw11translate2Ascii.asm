section .data
inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
inputLen equ $ - inputBuf        ; 8 bytes
newline db 0x0A                  ; newline char

section .bss
outputBuf resb 80                ; enough for translations

section .text
global _start

_start:
    mov esi, inputBuf            ; source pointer
    mov edi, outputBuf           ; destination pointer
    mov ecx, inputLen            ; how many bytes to translate

translate_loop:
    lodsb                        ; load byte from [ESI] into AL and increment ESI
    call byteToHex               ; convert AL to 2 ASCII hex characters → stored at [EDI]
    add edi, 2                   ; move EDI past the 2 written chars
    loop translate_loop

    ; append newline
    mov byte [edi], 0x0A
    inc edi

    ; write to stdout
    mov eax, 4                   ; syscall: sys_write
    mov ebx, 1                   ; stdout
    mov ecx, outputBuf
    sub edi, outputBuf           ; length = current edi - start of outputBuf
    mov edx, edi
    int 0x80

    ; exit
    mov eax, 1                   ; syscall: sys_exit
    xor ebx, ebx
    int 0x80

; ========== SUBROUTINE Part from HW for extra credit ========== 
; Converts byte in AL to two ASCII hex characters stored at [EDI]
byteToHex:
    push eax
    push ebx

    mov bl, al
    shr bl, 4                    ; upper nibble
    call nibbleToAscii
    mov [edi], al

    pop eax
    push eax

    mov bl, al
    and bl, 0x0F                 ; lower nibble
    call nibbleToAscii
    mov [edi+1], al

    pop ebx
    pop eax
    ret

; Converts nibble in BL to ASCII (0-9 -> '0'-'9', 10-15 -> 'A'-'F')
nibbleToAscii:
    cmp bl, 9
    jbe .is_digit
    add bl, 55                  ; 'A' = 65, A(10) + 55 = 65
    mov al, bl
    ret
.is_digit:
    add bl, '0'
    mov al, bl
    ret
