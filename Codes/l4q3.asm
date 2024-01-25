[org 0x0100]


jmp start


num1: db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
num2: db 2
siz: dw 20


start:

mov al, [num2]
mov bx, [siz]
mov si, [siz]
shr si, 1
mov cx, [siz]



check:

cmp al, [num1+si]
jz found
jc less

sub bx, si
mov si, bx
shr si,1
jmp check


less:
shr si,1
jmp check


found:
mov ax, 1



mov ax,0x4c00
int 0x21




int 0x21