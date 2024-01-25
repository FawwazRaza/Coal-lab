[org 0x0100]

mov bx, 0
mov [num1+10], bx
mov ax, [num1]
add [num1+10], ax
mov ax, [num1+2]
add [num1+10], ax
mov ax, [num1+4]
add [num1+10], ax
mov ax, [num1+6]
add  [num1+10], ax
mov ax, [num1+8]
add  [num1+10], ax

mov ax, 0x4c00
int 0x21








num1: dw 3,6,9,12,15,0