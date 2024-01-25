; Write a program “tsr.com” that saves old screen in a buffer (using MOVS instruction), clears the screen and then restores the old screen saved in buffer. Add some delay after clear screen call to clearly see the functionality. Properly make three separate functions.
; Output: Running tsr.com on DOSBOX should show empty screen for some time and the welcome screen should reappear.


[org 0x0100]
 jmp start
; subroutine to clear the screen

delay:
pusha
mov cx,0xffff
l1:
sub cx,1
cmp cx,0
jne l1
mov cx,0xffff
l2:
sub cx,1
cmp cx,0
jne l2
popa
ret



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



storeInBuffer:
pusha
push cs
pop es
mov ax,0xb800
push ax
pop ds

mov cx,2000
mov si,0
mov di,buffer
cld
rep movsw
popa
ret

back:
pusha
mov ax,0xb800
mov es,ax
push cs
pop ds
mov di,0
mov si,buffer
mov cx,2000
cld 

loop1:
lodsw
stosw
dec cx
jnz loop1

popa
ret

start:

call storeInBuffer
call clrscr
call delay
mov ah,0
int 0x16
call back

 mov ax, 0x4c00 ; terminate program
 int 0x21 

 buffer: dw 0