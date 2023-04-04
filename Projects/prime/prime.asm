%include "asm_io.inc"
segment .data
np db " is not a prime number.", 0
pr db " is a prime number. ", 0
input_string db "Enter a number to check for primality: ", 0
 
segment .bss
input  resd 1
index   resd 1

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, input_string
        call print_string
        call read_int
        mov [input], eax
        cmp eax, 1
        JE Not_Prime
        cmp eax, 2
        JE Prime
        mov ebx, 2
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE Not_Prime
        add ebx, 1
        mov [index], ebx
iter:
        mov eax, [input]
        mov ebx, 2
        mov edx, 0
        idiv ebx
        mov ecx, [index]
        cmp ecx, eax
        JG Prime
        mov eax, [input]
        mov ebx, [index]
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE Not_Prime
        mov ebx, [index]
        add ebx, 2
        mov [index], ebx
        JMP iter

Not_Prime:
        mov eax, [input]
        call print_int
        mov eax, np
        call print_string
        call print_nl
        jmp end

Prime:
        mov eax, 0
        mov eax, [input]
        call print_int
        mov eax, pr
        call print_string
        call print_nl
        jmp end

end:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret