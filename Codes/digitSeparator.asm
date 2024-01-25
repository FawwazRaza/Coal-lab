[org 0x0100]

d1: db 0
d2: db 0
d3: db 0
d4: db 0
r: dw 0
l: dw 0

jmp start


start:

mov ax, 0x1234
push ax
call digitSeparator


exit:
mov ax, 0x4c00
int 0x21



digitSeparator:
push bp
mov bp, sp
push ax
push bx


mov ax, [bp+4]
mov bh, ah
shr bh, 4
mov bl, 0
mov [d1], bh

mov bh, ah
shl bh,4 
shr bh, 4

mov [d2], bh


mov bh, al
shr bh, 4
mov [d3], bh

mov bh, al
shl bh,4 
shr bh,4 
mov [d4], bh

pop bx
pop ax

pop bp
ret




