[org 0x0100]


MOV AX,0013H
INT 10H 


mov ax, 0A000h
mov es, ax



mov di, 16705

mov ax, 43

mov cx, 80
box_loop:
push cx
mov cx, 180
rep stosb
add di, 320
sub di, 180

pop cx
loop box_loop

mov di, 18955
mov ax, 14

mov cx, 65
boundary_loop1:
push cx
mov cx, 160
rep stosb
add di, 320
sub di, 160

pop cx
loop boundary_loop1


boundary_loop2:




mov ax, 0x4c00
int 0x21