 ; Develop an assembly program that reads 1 number each from 5 different data 
; labels to a register and stores their sum in some other memory location labeled as result.

[org 0x0100]

mov cx,10
mov bx,0

l1:
mov ax,[num1 + bx]
add bx,2
add [sum],ax
sub cx,2
jnz l1
mov ax,[sum]

mov ax, 0x4c00
int 0x21

num1:dw 5
num2:dw 10
num3:dw 15
num4:dw 20
num5:dw  25
sum:dw 0