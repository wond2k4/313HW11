; Wonder Akpabio CMSC313 HW11 8:30-9:45am section

section .data
    ; data for hex to ascii
    inputBuf: db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputBufEnd:                                    ; end of data
    inputLen: equ inputBufEnd - inputBuf             ;  calculates buffer size

section .bss
    outputBuf: resb 80                                

section .text
global main

main:
    mov esi, inputBuf                                ; pointer to input
    mov edi, outputBuf                                ; pointer to output
    mov ecx, inputLen                                ; byte counter initialization

; main loop for conversion
converting_byte:                                        
    movzx eax, byte [esi]                            ; get currrnt hex byte

    ; handles first hex digit
    mov ebx, eax                                     
    shr ebx, 4                                       ; isolate high 4 bits
    call convert_hex                                 ; convert to ASCII character
    mov [edi], bl                                    
    inc edi                                          

    ; handles second hex digit
    mov ebx, eax                                     ; get byte 
    and ebx, 0Fh                                     
    call convert_hex                                 ; convert to ASCII character
    mov [edi], bl                                    ; store it
    inc edi                                          ; next output spot

    ; check if added space is required, if so add the space (except it is the last byte)
    cmp ecx, 1                                       ; check if last byte
    je space_handling                                ; skip space
    mov byte [edi], ' '                              ; add space
    inc edi                                          ; next output spot

space_handling:
    inc esi                                          ; next input byte
    dec ecx                                          ; decrement counter
    jnz converting_byte                              ; continue until all bytes processed

    ; add newline
    mov byte [edi], 10                               ; newline char
    inc edi                                          ; next output spot

    ; print output
    mov eax, 4                                       ; system call: write
    mov ebx, 1                                       ; file descriptor: stdout
    mov ecx, outputBuf                               ; output buffer
    mov edx, edi                                     ; calculate output length
    sub edx, outputBuf
    int 0x80                                         ; call kernel

    ; exit
    mov eax, 1                                       ; system call: exit
    xor ebx, ebx                                     ; return 0
    int 0x80                                         ; call kernel

; hex to ascii
convert_hex:                                         
    cmp bl, 9                                        ; <= 9??
    jle if_digit                                     
    add bl, 'A' - 10                                 ; convert values 10-15 to 'A'-'F'
    jmp converted                                    

if_digit:
    add bl, '0'                                      ; convert values 0-9 to their char version

converted:
    ret