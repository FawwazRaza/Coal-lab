

[org 0x0100]

jmp start




start:


mov ax, 0xb800
mov es, ax ; point es to video base
mov ds, ax ; point ds to video base
xor si, si ; point di to top left column
mov di, 2080

mov cx, 

rep movsw


mov ax,0x4c00
int 0x21



