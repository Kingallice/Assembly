%include "asm_io.inc"
segment .data
input_string db "Find the square root of ", 0
output_string db "The square root is ", 0
decimal db "The sqrt is a decimal", 0

segment .bss
input resd 1
remain resd 1
index resd 1
sqrt resd 1

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
        mov eax, input_string
        call print_string
        call read_int
        mov [input], eax

iter:
        mov ecx, [input]
        mov eax, [index]
        imul eax
        cmp eax, ecx
        JG checkend
        mov eax, [index]
        mov [sqrt], eax
        inc eax
        mov [index], eax
        mov ebx, 4
        mov edx, 0
        idiv ebx
        dump_regs [index]
        JMP iter

checkend:
        mov ecx, [input]
        mov eax, [sqrt]
        imul eax
        cmp eax, ecx
        JE end
        sub ecx, eax
        mov [remain], ecx
        JMP next

next:
        mov eax, [remain]
        imul 10
        mov [remain], eax
        call print_int
        mov eax, decimal
        call print_string
        call print_nl
        JMP end

end:
        mov eax, output_string
        call print_string
        mov eax, [sqrt]
        call print_int
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


