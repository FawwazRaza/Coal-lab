[org 0x0100]

;64 bit addition

jmp start

num1: dw 5,6,7,8
num2: dw 5,6,7,8

start:

mov si, 6
mov cx, 4
CLC

loop:
mov ax, [num1+si]
adc  [num2+si], ax
sub si, 2
sub cx,1
jnz loop

mov ax,0x4c00
int 0x21




int 0x21