[org 0x0100]


mov ah, 07h         ; Scroll text downward function
    mov al, 01h         ; Number of window lines to scroll downward by 1
    mov bh, 0           ; Color attribute (0 for default)
    mov ch, 2           ; Upper left corner of the window (row)
    mov cl, 6           ; Upper left corner of the window (column)
    mov dh,15          ; Lower right corner of the window (row)
    mov dl, 34          ; Lower right corner of the window (column)
    int 10h             ; BIOS video services interrupt
	
