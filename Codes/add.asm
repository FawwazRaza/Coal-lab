[org 0x0100]

jmp start

dest: dd 40000  ;9C40
src: dd 80000	;13880

start:

mov ax, [src]
add word [dest], ax
mov ax, [src+2]
adc word [dest+2], ax

mov ax,0x4c00
int 0x21