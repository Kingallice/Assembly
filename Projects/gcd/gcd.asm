%include "asm_io.inc"

segment .data
input_string db "Find the GCD of ", 0
and_string db "and ", 0
output_string db "The GCD is ", 0
space db " ", 0

segment .bss
input1 resd 1
input2 resd 1
index resd 1
gcd resd 1

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, input_string
        call print_string
        call read_int
        mov [input1], eax
        mov eax, and_string
        call print_string
        call read_int
        mov [input2], eax
        mov eax, 0
        mov [index], eax
        mov eax, output_string
        call print_string

iter:   
        mov eax, [index]
        add eax, 1
        mov [index], eax
        mov eax, [input1]
        mov ecx, [index]
        cmp eax, ecx
        JB end
        mov edx, 0
        idiv ecx
        cmp edx, 0
        JE check_2
        JMP iter

check_2:
        mov eax, [input2]
        mov ecx, [index]
        cmp eax, ecx
        JB end
        mov edx, 0
        idiv ecx
        cmp edx, 0
        JE set_gcd
        JMP iter

set_gcd:
        mov eax, [index]
        mov [gcd], eax
        JMP iter

end:
        mov eax, output_string
        call print_string
        mov eax, [gcd]
        call print_int
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret