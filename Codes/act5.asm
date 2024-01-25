[org 0x0100]

mov bx, 0
mov [num1+2], bx
mov ax, [num1]
add [num1+2], ax
add [num1+2], ax
add [num1+2], ax
add [num1+2], ax
add [num1+2], ax
add [num1+2], ax


mov ax, 0x4c00
int 0x21

num1: dw 6,0