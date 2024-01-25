[org 0x0100]

jmp start



start:


mov ax, 0xb800
mov es, ax
mov ds, ax

infloop:


mov si, 2
mov di, 0

mov cx, 25
loop1:
push cx
mov ax, [ds:si]
mov cx, 79
rep movsw
mov [es:di], ax
add di,2
add si,2

pop cx
loop loop1

call delay
loop infloop

mov ax, 0x4c00
int 0x21


delay:
pusha
mov cx, 5000
delayloop:
mov ax, 0xffff

loop delayloop
popa
ret



