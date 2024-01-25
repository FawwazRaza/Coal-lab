[org 0x0100]

jmp start

buffer: times 80 dw 0

start:

mov ax, 0xb800
mov ds, ax
mov si, 0

mov bx, buffer
mov es, bx
mov di, 0

mov cx, 80
cld

rep movsw

mov ax, 0x4c00
int 0x21