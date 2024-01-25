
 ; Write a program that swaps the value of two registers using a data label i.e. given 
; these initial values: ax=100, bx=200. After rotation, ax=200, bx=100.

[org 0x0100]

mov ax,100
mov bx,200

mov cx,ax
mov ax,bx
mov bx,cx

mov ax, 0x4c00
int 0x21
