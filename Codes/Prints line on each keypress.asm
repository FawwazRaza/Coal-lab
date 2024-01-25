; print string and keyboard wait using BIOS services

; Write a program that prints and prints the following messages: one message per keypress.  
; 'msg1: Hi! I am YourName.'  
; 'msg2: I am YourMode(Happy, Sad, etc).'  
; 'msg3: I Study at FAST.'  
; 'msg4: My Roll No is YourRoll#.'  
; Expected output after 4 key presses  

[org 0x100]
 jmp start
msg1: db 'Hi! I am Hashir', 0
msg2: db 'I am HAPPY', 0
msg3: db 'I am from FAST', 0
msg4: db 'My Roll# is 22l-7553', 0

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
;-------------------
strlen: 
 push bp
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
;-------------
printstr:
       push bp
 mov bp, sp
 push es
 push ax
 push cx
 push si
 push di
 push ds ; push segment of string
 mov ax, [bp+4]
 push ax ; push offset of string
 call strlen ; calculate string length 
cmp ax, 0 ; is the string empty
 jz exit ; no printing if string is empty
 mov cx, ax ; save length in cx
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov al, 80 ; load al with columns per row
 mul byte [bp+8] ; multiply with y position
 add ax, [bp+10] ; add x position
 shl ax, 1 ; turn into byte offset
 mov di,ax ; point di to required location
 mov si, [bp+4] ; point si to string
 mov ah, [bp+6] ; load attribute in ah
 cld ; auto increment mode

nextchar:
 lodsb ; load next char in al
 stosw ; print char/attribute pair
 loop nextchar ; repeat for the whole string

exit: 
 pop di
 pop si
 pop cx
 pop ax
 pop es
 pop bp
 ret 8




;--------------------------

start: 

 call clrscr ; clear the screen

 mov ah, 0 ; service 0 get keystroke
 int 0x16 ; call BIOS keyboard service
 mov ax, 0
 push ax ; push x position
 mov ax, 1
 push ax ; push y position
 mov ax, 07 
 push ax ; push attribute
 mov ax, msg1
 push ax ; push offset of string
 call printstr ; print the string

 mov ah, 0 ; service 0  get keystroke
 int 0x16 ; call BIOS keyboard service
 mov ax, 0
 push ax ; push x position
 mov ax, 2
 push ax ; push y position
 mov ax, 0x07 
 push ax ; push attribute
 mov ax, msg2
 push ax ; push offset of string

 call printstr ; print the string

 mov ah, 0 ; service 0  get keystroke
 int 0x16 ; call BIOS keyboard service
 mov ax,0
 push ax ; push x position
 mov ax, 3
 push ax ; push y position
 mov ax, 0x07 
 push ax ; push attribute
 mov ax, msg3
 push ax ; push offset of string

 call printstr ; print the string

mov ah, 0 ; service 0  get keystroke
 int 0x16 ; call BIOS keyboard service
 mov ax, 0
 push ax ; push x position
 mov ax, 4
 push ax ; push y position
 mov ax, 0x07 
 push ax ; push attribute
 mov ax, msg4
 push ax ; push offset of string
 
 call printstr ; print the string

 mov ah, 0 ; service 0 get keystroke
 int 0x16 ; call BIOS keyboard service
 mov ax, 0x4c00 ; terminate program
 int 0x21