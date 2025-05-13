; Wonder Akpabio CMSC313 HW11 8:30-9:45am section

section .data
    ; data for hex to ascii
    inputBuf: db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputBufEnd:                                    ; end of data
    inputLen: equ inputBufEnd - inputBuf            ; calculates buffer size
    space: db ' '                                   ; space character

section .bss
    outputBuf: resb 80                              ; output buffer

section .text
global main

main:
    mov esi, inputBuf                               ; pointer to input
    mov edi, outputBuf                              ; pointer to output
    mov ecx, inputLen                               ; byte counter initialization

; main loop for conversion
converting_byte:                                        
    movzx eax, byte [esi]                           ; get current hex byte
    
    ; process the entire byte through function
    call process_byte                               ; process the byte
    
    ; add space unless it is the last byte
    cmp ecx, 1                                      ; check if last byte
    je skip_space                                   ; skip space if last byte
    call add_space                                  ; add space between bytes
    
skip_space:
    ; loop control
    inc esi                                         ; next input byte
    dec ecx                                         ; decrement counter
    jnz converting_byte                             ; continue until all bytes processed

    ; add newline
    mov byte [edi], 10                              ; newline char
    inc edi                                         ; next output spot
    
    ; print output
    call print_output                               ; call print function
    
    ; exit
    call exit_program                               ; call exit function

; convert a single byte into two hex ASCII characters
process_byte:
    push ecx                                        ; save counter
    call first_dig_handling                        ; process high 4 bits
    call second_dig_handling                         ; process low 4 bits
    pop ecx                                         ; restore counter
    ret

; first hex digit handling
first_dig_handling:
    push eax                                        ; save original byte
    shr eax, 4                                      ; isolate high 4 bits
    call convert_hex                                ; convert to ASCII
    mov [edi], al                                   ; store ASCII char
    inc edi                                         ; next output position
    pop eax                                         ; restore original byte
    ret

; second hex digit handling
second_dig_handling:
    push eax                                        ; save byte
    and eax, 0Fh                                    ; mask low 4 bits
    call convert_hex                                ; convert to ASCII
    mov [edi], al                                   ; store ASCII char
    inc edi                                         ; next output position
    pop eax                                         ; restore byte
    ret

add_space:
    push eax                                        ; save eax
    mov al, [space]                                 ; get space character
    mov [edi], al                                   ; store space
    inc edi                                         ; next output position
    pop eax                                         ; restore eax
    ret

; hex to ascii conversion
convert_hex:                                         
    cmp al, 9                                       ; <= 9??
    jle if_digit                                     
    add al, 'A' - 10                                ; convert values 10-15 to 'A'-'F'
    jmp converted                                    

if_digit:
    add al, '0'                                     ; convert values 0-9 to their char version

converted:
    ret

; print the output buffer
print_output:
    mov eax, 4                                      ; system call: write
    mov ebx, 1                                      
    mov ecx, outputBuf                              ; output buffer
    mov edx, edi                                    ; calculate output length
    sub edx, outputBuf
    int 0x80                                        ; call kernel
    ret

; exit the program
exit_program:
    push 0                                          ; exit code 0
    push 1                                          ; syscall number (exit)
    pop eax                                         ; syscall number to eax
    pop ebx                                         ; exit code to ebx
    int 0x80                                        ; call kernel
    ret
