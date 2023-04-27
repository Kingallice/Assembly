%include "asm_io.inc"
segment .data
prompt1 db "Dumping Memory", 13, 0
prompt2 db "Stack Memory", 13, 0

segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        global  asm_main

asm_main:
    enter 0,0
    push_af

    mov eax, prompt1
    call print_string
    call print_nl
    dump_mem 1, 0, 200

    mov eax, prompt2
    call print_string
    call print_nl
    dump_stack 1, 50, 50

end:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret