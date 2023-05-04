
%include "asm_io.inc"
%include "second.inc"

segment .data
prompt1 db "Dumping memory",0
prompt2 db "Dumping stack",0

segment .bss

segment .text
        global  asm_main

asm_main:    
	enter   0,0               ; setup routine
	pusha

	call print_nl
	mov eax, prompt1
	call print_string
	call print_nl
	mov eax, 0
	dump_mem 1, eax, 100

	call print_nl
	mov eax, prompt2
	call print_string
	call print_nl
	
	;dump_stack 1, 500, 500
	;dump_mem 1, asm_main, 100

	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret


