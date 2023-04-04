%include "asm_io.inc"
segment .data
start db "Find sum of all even Fibonacci numbers below ", 0
sum dd 0
;
; initialized data is put in the data segment here
;


segment .bss
input resd 1
indexl resd 1
indexc resd 1
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
        mov eax, 1
        mov [indexl], eax
        mov [indexc], eax
        
iter:
        ; places current num into eax and adds 1
        mov eax, [indexc]
        add eax, [indexl]
        mov ecx, [input]
        cmp ecx, eax
        JB end
        mov ecx, [indexc]
        mov [indexl], ecx
        mov [indexc], eax
        mov ebx, 2
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE add_to_sum
        JMP iter

add_to_sum:
        mov ecx, [sum]
        mov eax, [indexc]
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