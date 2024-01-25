; Update code written in activity 1 such that the star travels the screen in an infinite loop.

[org 0x0100]
jmp Main 
clrscr: 
push es
push ax
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column
nextloc: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 4000 ; has the whole screen cleared
jne nextloc ; if no clear next position
pop di
pop ax
pop es
ret

MovingStar:
push es
push ax
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column

TopRight: 
mov word[es:di],0x072A
call delayfun
call delayfun
call clrscr
add di,2
cmp di,80
jne TopRight
mov di,80

BottomRight:
mov word[es:di],0x072A
call delayfun
call delayfun
call clrscr
add di,160 
cmp di,2000
jne BottomRight
mov di, 2000

BottomLeft:
mov word[es:di],0x072A
call delayfun
call delayfun
call clrscr
sub di,2 
cmp di,1920
jne BottomLeft
mov di,1920

TopLeft:
mov word[es:di],0x072A
call delayfun
call delayfun
call clrscr
sub di,160
cmp di,0
jne TopLeft


pop di
pop ax
pop es
ret

delayfun:
mov dx, 0xFFFF	
l1:	
mov cx,0xFFFF
dec dx
l2:
dec cx
jnz l2
jnz l1
ret

Main:
 call clrscr
 call MovingStar
 jmp Main

mov ax,0x4c00
int 0x21