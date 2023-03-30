%include "asm_io.inc"
segment .data
np db "Not a prime number.", 0
pr db "prime number.", 0
input_string db "Insert.", 0
 
segment .bss

N       resW 1
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
        mov ax, 13
        mov [N], ax

        mov ax, [N]

        mov bx, 2
        mov dx, 0
        div bxcmp dx, 0
        JE Not_Prime
        mov bx, 1

iter:
        mov ax, [N]
        add bx, 2
        mov cx, [N]
        shr cx, 1
        cmp bx, cx
        JG Prime
        mov dx, 0
        div bxcmp dx, 0
        JE Not_Prime
        JMP iter

Not_Prime:
        jmp end

Prime:
        mov eax, 0
        mov WORD eax, [N]
        call print_int
        call print_nl
        jmp end

end:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret