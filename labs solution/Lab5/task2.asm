
[org 0x100]
jmp start1


l4:
ret
commulativesum:
push dx
add ax,1
cmp [temp],ax
pop dx
je l4


nsum:
push ax
mov cx,ax
add cx,cx
sub cx,1
mov bx,0
l1: cmp ax,bx
jne plusloop


plusloop:add bx,1
add dx,bx
cmp ax,bx
je subtractloop
jne plusloop
subtractloop:sub bx,1
mov cx,bx
jz l3
add dx,bx
cmp cx,0
jne subtractloop
l3:
call commulativesum
pop ax
ret





mov bx,0
binaryones:
push ax
mov cx,8

l5:
jz l6
shl ax,1
jc l7
jnc l5

l7:add bx,1
    dec cx
jnz l5
l6:
pop ax
ret
start1: mov ax,0x8813
call binaryones

start:

mov si,5
add [temp],bx
mov ax,1

add byte [temp],1
call nsum

mov ax,0x4C00
int 0x21
temp: dw 5