%include "asm_io.inc"
segment .data
start db "Find the largest prime factor of ", 0
;
; initialized data is put in the data segment here
;


segment .bss
lp resd 1
factor resd 1
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
        mov [index], eax

initial:
        mov eax, 2
        mov [factor], eax
        mov eax, [index]
        cmp eax, 1
        JE end
        mov ebx, [factor]
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE set_igpf
        add ebx, 1
        mov [factor], ebx
        JMP iter
        
iter:
        ; places current num into eax and adds 1
        mov eax, [index]
        cmp eax, 1
        JE end
        mov ebx, [factor]
        mov edx, 0
        idiv ebx
        cmp edx, 0
        JE set_gpf
        add ebx, 2
        mov [factor], ebx
        JMP iter
set_igpf:
        mov [index], eax
        mov [factor], ebx
        JMP initial

set_gpf:
        mov [index], eax
        mov [factor], ebx
        JMP iter

check_prime:
        mov eax, [factor]


end:
        mov eax, [factor]
        call print_int
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret