cli ; Disable interrupts

jmp 0x0000:ZeroSegment ; Jump to the beginning of the program
ZeroSegment:
    xor ax, ax ; Clear ax

    ; Clear the segment registers 
    mov ss, ax 
    mov ds, ax
    mov es, ax
    mov gs, ax

    mov sp, entrypoint ; Point to our entrypoint
    cld ; Clear the flags for the d register, ignore legacy BIOS

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