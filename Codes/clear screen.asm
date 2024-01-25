;clear screen

[org 0x0100]

jmp start


start:

mov ax, 0xb800
mov es, ax

mov ax, 0x0720
mov cx, 4000
xor di, di
cld

rep stosw

jmp exit

exit:
mov ax, 0x4c00
int 0x21