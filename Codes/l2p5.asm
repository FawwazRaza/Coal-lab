;Write a program to add three numbers using byte variables. What will happen if we add 
;these numbers in ax?

[org 0x0100]

mov ah,0
add ah,[num1]
add ah,[num2]
add ah,[num3]

mov ax, 0x4c00
int 0x21

num1 db 1
num2 db 2
num3 db 3
