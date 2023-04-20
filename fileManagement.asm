%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;

segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

open_file:
        mov ebx, eax
        mov eax, 5
        mov ecx, 2
        mov edx, 0777
        int 0x80
        ret

end:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


