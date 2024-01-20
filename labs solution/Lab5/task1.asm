
[org 0x100]
jmp start

mov bx,0
binaryones:
push ax
mov cx,8

l2:
jz l3
shl ax,1
jc l1
jnc l2

l1: add bx,1
    dec cx
jnz l2
l3:pop ax
ret
start: mov ax,0x8813
call binaryones


mov ax,0x4C00
int 0x21