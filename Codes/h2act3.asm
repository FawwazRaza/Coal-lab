[org 0x0100]

mov ax,0
mov bx,0
mov cx, [siz]
sub cx, 1
mov al, 2
mov bl, cl
mul bl
mov bx, 0

mov di, arr2
add di, ax
mov si, arr1
mov cx, [siz]


l1: mov dx, [si]
mov [di] , dx
add si, 2
sub di, 2
sub cx, 1
jnz l1


mov ax, 0x4c00 
int 0x21

arr1: dw 1,2,3,4,5,6
arr2: dw 0,0,0,0,0,0
siz: dw 6


