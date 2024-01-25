[org 0x0100]

mov ax, 3
mov bx, 6
add ax,bx
mov bx, 9
add ax,bx
mov bx, 12
add ax,bx
mov bx, 15
add ax,bx

mov ax, 0x4c00
int 0x21