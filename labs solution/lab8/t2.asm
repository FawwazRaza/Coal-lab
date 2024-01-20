; print string and keyboard wait using BIOS services 
[org 0x100] 
 jmp start 
w: dw 70 ;offset
x: dw 50 
y: dw 100
c: dw 60 ; color
temp:dw 0
clrscr: push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 xor di, di ; point di to top left column 
 mov ax, 0x0720 ; space char in normal attribute 
 mov cx, 2000 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 
 pop di
 pop cx 
 pop ax 
 pop es 
 ret 
 
draw_diagonal:
mov cx, [x]
mov dx, [y]
mov al, [c]
u1: inc dx
mov ah, 0x0c ; put pixel
 int 0x10
inc cx
mov bx,[x]
mov word[temp],bx
mov bx,[x]
add bx,[temp]
cmp cx,bx 
jbe u1

mov cx, [x]
mov dx, [y]
mov al, [c]

u2: dec dx
mov ah, 0x0c ; put pixel
 int 0x10
inc cx
mov bx,[x]
mov word[temp],bx
mov bx,[x]
add bx,[temp]
cmp cx,bx 
jbe u2

mov cx, [x]
mov dx, [y]
mov al, [c]
add cx,[x]
add dx,[x]
u3: dec dx
mov ah, 0x0c ; put pixel
 int 0x10
inc cx
mov bx,[y]
mov word[temp],bx
mov bx,[x]
add bx,[temp]
cmp cx,bx 
jbe u3

mov cx, [y]
mov dx, [x]
mov al, [c]

u4: inc dx
mov ah, 0x0c ; put pixel
 int 0x10
inc cx
mov bx,[y]
mov word[temp],bx
mov bx,[x]
add bx,[temp]
cmp cx,bx 
jbe u4


mov ah,00
int 16h
ret
start:
call clrscr
mov ah, 0
mov al, 0x13
int 0x10
call draw_diagonal
 mov ax, 0x4c00 ; terminate program 
 int 0x21 