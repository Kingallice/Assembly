%include "asm_io.inc"
segment .data
input_string db "Please insert a number between -128 and 127. ", 0
cold_str db "Cold", 0
cool_str db "Cool", 0
okay_str db "Ok", 0
hot_str db "Hot", 0

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

        cmp eax, 0
        JL cold
        cmp eax, 32
        JL cool
        cmp eax, 80
        JL okay
        mov eax, hot_str
        jmp end

cold:
        mov eax, cold_str
        jmp end
cool:
        mov eax, cool_str
        jmp end
okay:
        mov eax, okay_str
        jmp end

end:
        call print_string
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


