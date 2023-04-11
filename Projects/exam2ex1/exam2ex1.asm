
%include "asm_io.inc"

segment .data
prompt1 db "Please insert a number between 0 and 255: ",0
prompt2 db "Congratulations you found a palindrome",0
prompt3 db "Sorry, not a palindrome",0

segment .bss

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov     eax, prompt1      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     bl, al       	  ; the integer to be checked is now stored in bl
	
	mov	ecx, 8 
	mov	edx, 0
swap:
	mov 	dl, 0
	shr	al, 1
	adc	dl, 0
	shl	bh, 1
	add	bh, dl
	loop	swap
	
	;Now, the inserted number is in bl and the its swapped version is in bh

	XOR bh, bl	; If bh and bl are identical the output of the xor operation should be zero
	JZ  palindrome

	mov     eax, prompt3      ; Not a palindrome
        call    print_string
	call print_nl
	JMP END


palindrome:
	mov     eax, prompt2      ; It is a palindrome
        call    print_string
	call print_nl
	JMP END
	

END:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret