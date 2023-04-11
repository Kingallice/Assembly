%include "asm_io.inc"
segment .data
input_string db "Please insert a number. ", 0
output_string db " ones found within the number. ", 0

segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, input_string
        call print_string

        call read_int
        mov ebx, 0
        
iter:
        cmp eax, 0
        JE end
        shr eax, 1
        adc ebx, 0
        JMP iter

end:
        mov eax, ebx
        call print_int
        mov eax, output_string
        call print_string
        call print_nl

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


