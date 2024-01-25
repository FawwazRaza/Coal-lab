[org 0x0100]
jmp start
max:
push bp
mov bp,sp
sub sp,2
push ax
push cx
pop cx
pop ax
mov sp, bp
pop bp
ret 6

start:
sub sp,2
push 8
push 5
push 6
call max
pop dx
mov ax, 0x4c00
int 21h