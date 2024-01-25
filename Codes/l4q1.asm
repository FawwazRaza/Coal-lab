; : [Extended Subtraction] Write a program for subtracting 64 bits given below. 
; Initially
; num1: 1000 1000 0000 0000 0110 0000 1111 1111 0100 0000 0000 0000 1111 1111 1111 1111
; num2: 1000 1111 0000 1111 0000 0000 0000 0000 0100 0000 0000 0001 1000 0000 0000 0000
; result: 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 


[org 0x0100]

jmp start
num1: dd 10001000000000000110000011111111b, 01000000000000001111111111111111b;8800 60FF , 4000 FFFF
num2: dd 10001111000011110000000000000000b, 01000000000000011000000000000000b;8F0F 0000 , 4001 8000
result: dd 0,0 ;F8F1 60FE FFFF 7FFF
start:

mov cx,[num1]
mov dx,[result]

mov ax, [num1]
mov bx, [num2]

sub ax, bx
mov [result], ax

mov ax, [num1+2]
mov bx, [num2+2]
sbb ax, bx
mov [result+2], ax

mov ax, [num1+4]
mov bx, [num2+4]

sbb ax, bx
mov [result+4], ax

mov ax, [num1+6]
mov bx, [num2+6]

sbb ax, bx
mov [result+6], ax

ret
mov ax,0x4c00
int 0x21