[org 0x7c00] ; Start code from the designated bootloader memory space
[bits 16] ; 16 bit mode

section .text ; The bootloader code

global entrypoint ; Tell the compiler where our application starts

entrypoint: ; The main entrypoint of the operating system

; Inject our entrypoint code (KISS)
%include "./boot/entrypoint.asm"
jmp loaded

; Load utils
%include "./boot/utils.asm"

; Pad the boot image and add the magic number
times 0x1fe-($-$$) db 0
dw 0xaa55

; Bootloader sector
loaded:
mov si, loaded_message
call printf

mov dx, 0x0666
call printh

jmp $

; Allocate the bootloader sector
; I think it's backwards to pad out compiled output? Not sure
times 0x200 db 0