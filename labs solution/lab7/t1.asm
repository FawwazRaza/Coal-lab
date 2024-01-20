[org 0x0100] 
 jmp start 
clrscr1: push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 xor di, di ; point di to top left column 
 mov ax, 0x0020 ; space char in normal attribute 
 mov cx, 2000 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 
 pop di 

pop cx 
 pop ax 
 pop es 
 ret 
delay:
mov cx,3
l3:
mov dx,0xFFFF
l2:
sub dx,1
cmp dx,1
jne l2
loop l3
ret
clrscr: push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 xor di, di ; point di to top left column 
 mov ax, 0x7420 ; space char in normal attribute 
 mov cx, 800 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 
 pop di 

pop cx 
 pop ax 
 pop es 
 ret 
scrolldown: push bp 
 mov bp,sp 
 push ax 
 push cx 
 push si 
 push di 
 push es 
 push ds 
 mov ax, 80 ; load chars per row in ax 
 mul byte [bp+4] ; calculate source position 
 push ax ; save position for later use 
 shl ax, 1 ; convert to byte offset 
 mov si, 3998 ; last location on the screen 
 sub si, ax ; load source position in si 
 mov cx, 2000 ; number of screen locations 
 shr ax,1
 sub cx, ax ; count of words to move 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ds, ax ; point ds to video base 
 mov di, 3998 ; point di to lower right column 
 std ; set auto decrement mode 
 rep movsw ; scroll up
 mov ax, 0x0020 ; space in normal attribute 
 pop cx ; count of positions to clear 
 rep stosw ; clear the scrolled space 
 pop ds 
 pop es 
 pop di 
 pop si 
 pop cx 
 pop ax 
 pop bp 
 ret 2 
start: 
; call clrscr1
; call clrscr

; call delay
; call clrscr1
mov ax,12
 push ax ; push number of lines to scroll 
 call scrolldown ; call scroll down subroutine 
 mov ax, 0x4c00 ; terminate program 
 int 0x21