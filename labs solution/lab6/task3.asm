
[org 0x0100]
 jmp start
message: db '*' ; string to be printed
length1: dw 1

	clrscr: push es
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

printstr: push bp
 mov bp, sp
 push es
 push ax
 push cx
 push si
 push di
loc1: mov ax, 0xb800
 mov es, ax ; point es to video base
 mov al, 80 ; load al with columns per row
 mul byte [bp+10] ; multiply with y position
 add ax, [bp+12] ; add x position
 shl ax, 1 ; turn into byte offset
 mov di,ax ; point di to required location
 mov si, [bp+6] ; point si to string
 mov cx, [bp+4] ; load length of string in cx
 mov ah, [bp+8] ; load attribute in ah
jmp nextchar

delay:
push cx
push dx
mov cx,0xFFFF
mov bx,0
count1:
add bx,1
loop count1
pop bx
pop dx
ret
nextchar: mov al, [si] ; load next char of string
 mov [es:di], ax ; show this char on screen
 add di, 2 
add si, 1 ; move to next char in string
 loop nextchar ; repeat the operation cx times
 call delay
 call clrscr
 cmp word[bp+12],79
 je temp
 
mov bx,word[bp+12]
add bx,1
mov word[bp+12],bx
cmp bx,79

jne loc1
temp:mov bx,word[bp+10]
add bx,1
mov word[bp+10],bx
mov word[bp+12],79
cmp bx,25
jne loc1


 pop di
 pop si
 pop cx
 pop ax
 pop es
 pop bp
 ret 10
start: call clrscr ; call the clrscr subroutine
 mov ax, 1
 push ax ; push x position
 mov ax, 1
 push ax ; push y position
 mov ax, 4 ; blue on black attribute
 push ax ; push attribute
 mov ax, message
 push ax ; push address of message
 push word [length1] ; push message length
 call printstr ; call the printstr subroutine
 mov ax, 0x4c00 ; terminate program
 int 0x21 