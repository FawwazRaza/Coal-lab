 ; Write instructions to do the following. Visualize the memory contents using 
; memory windows to see if instruction is executed correctly. (Use m2 DS:offset to visualize the 
; memory contents at the specified offset)
; a. Copy contents of memory location with offset 0025 into AX.
; b. Copy AX into memory location with offset 0FFF.
; c. Move contents of memory location with offset 0010 to memory location with offset 002F

[org 0x0100]

mov ax,[0025h]
mov [0025h],ax
mov cx,[0010h]
mov [002fh],cx

mov ax, 0x4c00
int 0x21
