%include "asm_io.inc"
segment .data
input_string db "Find if the following number is a palindrome. ", 0
isPalindrome db "Congratulations you found a palindrome",0
notPalindrome db "Sorry, not a palindrome",0

segment .bss
input resd 1
number resd 1
binary resd 1

segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
        mov eax, input_string
        call print_string
        call read_int
        mov [input], al
        mov bl, al

        mov ecx, 8

swap:
        mov dl, 0
        shr al, 1
        adc dl, 0
        shl bh, 1
        add bh, dl
        loop swap

        ;mov eax, [input]
        xor bl, bh
        JE palindrome

        mov eax, notPalindrome
        call print_string
        call print_nl

        JMP end

palindrome:
        mov eax, isPalindrome
        call print_string
        call print_nl

        JMP end

end:
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


