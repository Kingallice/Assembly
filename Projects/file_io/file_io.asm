segment .data
;
; initialized data is put in the data segment here
;

segment .bss
;
; uninitialized data is put in the bss segment
;

segment .text
        global  create_file, open_file, read_file, write_to_file, seek_file, close_file

create_file:
        mov ebx, eax    ;filename
        mov eax, 8      ;sys_creat()
        mov ecx, 0777
        int 0x80
        ret

open_file:
        mov ebx, eax    ;filename
        mov eax, 5      ;sys_open()
        mov ecx, 2
        mov edx, 0777
        int 0x80
        ret

read_file:
        mov ecx, eax    ;store location
        mov eax, 3      ;sys_read()
        mov edx, 0FFFFFFFFh     ;bytes to read
        int 0x80
        ret

write_to_file:
        mov ecx, eax    ;msg to write
        mov edx, 0      
        call get_length
        mov eax, 4      ;sys_write()
        int 0x80
        ret

seek_file:
        mov eax, 19
        mov ecx, 0
        mov edx, 2
        int 0x80
        ret

close_file:
        mov eax, 6
        int 0x80

get_length:
        push eax
        dec eax
.loop: inc eax
        cmp byte [eax], 0
        JNE .loop
        sub eax, [esp]
        mov edx, eax
        pop eax
        ret

