
%include "asm_io.inc"

segment .data
prompt1 db "In asm_main2",0

segment .bss

segment .text
        global  asm_main2

asm_main2:
	dump_regs 2
        enter   0,0               ; setup routine
        pusha

	mov eax, prompt1
	call print_string
	call print_nl
	dump_regs 3

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


