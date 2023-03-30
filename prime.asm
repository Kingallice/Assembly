%include "linux-ex/asm_io.inc"
segment .data
space db " ", 0
np db " is not a prime number.", 0
pr db " is a prime number. ", 0
input_string db "Please insert a number. ", 0
 
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

L1:
        mov bx, 2
        cmp ax, bx
        JE Prime
        mov dx, 0
        div bx
        cmp dx, 0
        JE Not_Prime
        mov bx, 1
        JMP iter
        
iter:
        mov ax, [input]
        add bx, 2
        mov cx, [input]
        shr cx, 1
        cmp bx, cx
        JG Prime
        mov dx, 0
        div bx
        cmp dx, 0
        JE Not_Prime
        mov ax, bx
        call print_int
        mov ax, space
        call print_string
        JMP iter

Not_Prime:
        mov eax, [input]
        call print_int
        mov eax, np
        call print_string
        jmp end

Prime:
        mov eax, 0
        mov eax, [input]
        call print_nl
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