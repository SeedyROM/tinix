;
; Helper functions
;

; Print a string
printf:
    pusha
    mov ah, 0x0e
.repeat:
    lodsb ; Load the byte from si into al
    cmp al, 0
    je .done
    int 0x10 ; Print
    jmp .repeat
.done:
    popa
    ret

; Read bootsector
read_disk_bootsector:
    pusha
    mov ah, 0x02 ; Read disk
    mov dl, 0x80 ; Read from hard disk
    mov ch, 0    ; Choose the cylinder
    mov dh, 0    ; Choose the head

    push bx ; Set the start of our segment register to 0
    mov bx, 0
    mov es, bx
    pop bx ; Set the end of our read segment
    mov bx, 0x7c00 + 0x200 ; Set the offset to 512 bytes from the origin

    int 0x13 ; Read the first 512 (0x200) bytes
    jc .disk_error ; If the carry flag is set handle our error

    popa 
    ret

    .disk_error:
        mov si, disk_error_message ; Print our error
        call printf
        jmp $ ; Loop forever, don't mess things up
        

;
; Strings
;

loading_message db "[ ] Loading Tinix from 16-bit realmode 0x7c00...", 0xa, 0xd, 0
disk_error_message db "[-] Error Reading Disk", 0xa, 0xd, 0
loaded_message db "[+] Successfully loaded bootloader into memory!", 0xa, 0xd, 0