%include "asm_io.inc"
segment .data
start db "Find sum of all multiples of 3 or 5 below ", 0
sum dd 0
;
; initialized data is put in the data segment here
;


segment .bss
input resd 1
index resd 1
;
; uninitialized data is put in the bss segment
;


 

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, start
        call print_string
        call read_int
        mov [input], eax
        mov eax, 0
        mov [index], eax
        
iter:
        ; places current num into eax and adds 1
        mov eax, [index]
        add eax, 1
        mov [index], eax
        mov eax, [index]
        mov ecx, [input]
        cmp ecx, eax
        JE end
        mov ebx, 3
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE add_to_sum
        mov eax, [index]
        mov ebx, 5
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE add_to_sum
        JMP iter

add_to_sum:
        mov ecx, [sum]
        mov eax, [index]
        add eax, ecx
        mov [sum], eax
        JMP iter

end:
        mov eax, [sum]
        call print_int
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret