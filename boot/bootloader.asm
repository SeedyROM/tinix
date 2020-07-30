[org 0x7c00]
[bits 16]

section .text

global entrypoint

entrypoint:
cli ; Disable interrupts

jmp 0x0000:ZeroSegment ; Jump to the beginning of the program
ZeroSegment:
    xor ax, ax ; Clear ax

    ; Clear the segment registers 
    mov ss, ax 
    mov ds, ax
    mov es, ax
    mov gs, ax

    ; Point to our entrypoint
    mov sp, entrypoint
    cld ; 

sti ; Re-enable interrupts

; Clear our disk read and write positions
push ax
xor ax, ax
int 0x13
push ax

; Set video mode and clear the screen
mov ah, 0x00 ; 
mov al, 0x03 ; 3 color mode!
int 0x10 

; Print loading message
mov si, loading_message 
call printf

; Load the bootsector into memory
mov al, 1 ; Choose the sector
mov cl, 2 ; Choose the drive
call read_disk_bootsector

; Jump into the second sector
jmp loaded

; Load utils
%include "./boot/utils.asm"

; Pad the boot image and add the magic number
times 0x1fe-($-$$) db 0
dw 0xaa55

; Second sector
loaded:
mov si, loaded_message
call printf
jmp $

; Allocate our second sector
times 0x200 db 0