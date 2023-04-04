%include "linux-ex/asm_io.inc"

segment .data
input_string db "Find all divisors of ", 0
output_string db "The divisors are ", 0
space db " ", 0

segment .bss
input resd 1
index resd 1

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, input_string
        call print_string
        call read_int
        mov [input], eax
        mov eax, 0
        mov [index], eax
        mov eax, output_string
        call print_string

iter:   
        mov eax, [index]
        add eax, 1
        mov [index], eax
        mov eax, [input]
        mov ecx, [index]
        cmp eax, ecx
        JB end
        mov edx, 0
        idiv ecx
        cmp edx, 0
        JE print
        JMP iter

print:
        mov eax, [index]
        call print_int
        mov eax, space
        call print_string
        JMP iter

end:
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret