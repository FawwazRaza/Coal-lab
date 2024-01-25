
; Write a program which determines largest number from the given array.
; array: dw 111, 999, 888, 888, 11, 99, 88, 88, 1, 9, 8, 8
[org 0x0100] 
 
jmp start
array: dw 111, 999, 888, 888, 11, 99, 88, 88, 1, 9, 8, 8
len:dw 12

start:
mov ax,0
mov bx,0
mov cx,0
l1:
mov ax,[array + bx]
l2:
add bx,2
add cx,1
cmp ax,[array + bx]
jl l1
cmp cx,[len]
jl l2

mov ax, 0x4c00 
int 0x21