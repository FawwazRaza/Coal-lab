[org 0x0100] 
 jmp start 
msg1: db 'ggggdddddddyyyyakxxxuww', 0 
length1:dw 24
msg2: db '00000000000000000000000',0
lenght2:db 8
printstr: push bp 
 mov bp, sp 
 push es 
 push ax 
 push cx 
 push si 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov al, 80 ; load al with columns per row 
 mul byte [bp+10] ; multiply with y position 
 add ax, [bp+12] ; add x position 
 shl ax, 1 ; turn into byte offset 
 mov di,ax ; point di to required location 
 mov si, [bp+6] ; point si to string 
 mov cx, [bp+4] ; load length of string in cx 
 mov ah, [bp+8] ; att
 cld ; auto increment mode 
nextchar: lodsb ; load next char in al 
 stosw ; print char/attribute pair 
 loop nextchar ; repeat for the whole string 
 pop di 
 pop si 
 pop cx 
 pop ax 
 pop es 
 pop bp 
 ret 10 
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
strlen: push bp 
 mov bp,sp 
 push es 
 push cx 
 push di 
 les di, [bp+4] ; point es:di to string 
 mov cx, 0xffff ; load maximum number in cx 
 xor al, al ; load a zero in al 
 repne scasb ; find zero in the string 
 mov ax, 0xffff ; load maximum number in ax 
 sub ax, cx ; find change in cx 
 dec ax ; exclude null from length 
 pop di 
 pop cx 
 pop es 
 pop bp 
 ret 4 


copy:
mov di,0
l1:
mov al,[msg2+di]
mov [msg1+di],al
add di,1
cmp byte[msg2+di],0x00
jne l1
mov byte[msg1+di+1],0x00
ret 

endl:ret
mov di,0
mov si,0
xor ax,ax
xor dx,dx
repetitions_occur:
	add di,1
	mov bl,[msg1+di]
	cmp al,bl
	je repetitions_occur
	mov [msg2+si],al
	add si,1
 cmp di,[length1]
 je endl
 repetitions:
 mov al,[msg1+di]
 mov bl,[msg1+di+1]
 cmp bl,0
 je endl
 cmp al,bl
 je repetitions_occur
 mov [msg2+si],al
 add si,1
 add di,1
 cmp di,[length1]
 je endl
 jne repetitions
start: 
;call clrscr
call repetitions
call copy
 mov ax, 0x4c00 ; terminate program 
 int 0x21