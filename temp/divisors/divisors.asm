%include "asm_io.inc"
segment .data
space db " ", 0
input_string db "Please insert a number: ", 0
index dd 2
 
segment .bss

N      resW 1
input  resd 1

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, input_string
        call print_string
        call read_int
        mov [input], eax

        mov ecx, eax
        mov bx, index
        JMP iter
        
iter:
        mov ax, [input]
        add bx, 1
        mov cx, [input]
        shr cx, 1
        cmp bx, cx
        JE end
        mov ax, bx
        call print_int
        mov ax, space
        call print_string
        JMP iter

end:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret