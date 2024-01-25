[org 0x0100]

jmp start

num1: dd 0x7E945FA2
num2: dd 0xB2654104


start:

mov ax, [num1]
mov ax, [num1+2]
mov bx, [num2+1]
mov ax, [0x0200]


