;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;clock	

	clock:
	push dx
	push di
	push ax
	push es
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 mov al, 80 ; load al with columns per row 
	 mov bl,1
	 mul  bl ; multiply with y position 
	 add ax, 68 ; add x position 
	 shl ax, 1 ; turn into byte offset 
	 mov di,ax ; point di to required location
	 mov si,timestr ; point si to string 
 mov cx, [timestr_length] ; load length of string in cx 
 mov ah, 0x07 
 cld 
nextchartimestr: lodsb 
 stosw 
 loop nextchartimestr 
 cmp word[flagfortimer],1
 jne exitclock
	cmp byte[nanoseconds],1
	je changesec
	add byte[nanoseconds],1
	jmp exitclock
	changesec:
	mov byte[nanoseconds],0
	cmp byte[second],60
	je changemin
	add byte[second],1
	cmp byte[timestr+5],0x39
	jae change_sec_L
	add byte[timestr+5],0x01
	jmp exitclock
	
	change_sec_L:
	mov byte[timestr+5],0x30
	add byte[timestr+4],0x01
	jmp exitclock
	changemin:
	mov byte[second],0
	mov byte[timestr+5],0x30
	mov byte[timestr+4],0x30
	add byte[minutes],1
	cmp byte[minutes],5
	je stopgame
	add byte[minutes],0x30
	mov ax,[minutes]
	mov [timestr],ax
	sub byte[minutes],0x30
	jmp exitclock
	stopgame: 
	add byte[minutes],1
	add byte[minutes],0x30
	mov al,[minutes]
	mov byte[timestr],al
	sub byte[minutes],0x30
	mov byte[timestr+5],0x30
	mov byte[timestr+4],0x30
	 call gameover_print
	
	   call delay_movement
	   call delay_movement
	   call delay_movement
	   call last_print_blocks_loop
	   call end_game
	  call endl
	exitclock:
	pop es
	pop ax
	pop di
	pop dx
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;key strokes for movement
keystrokeformovement: 
	push bx
			push ax 
		 push es 
		 mov ax, 0xb800 
		 mov es, ax ; point es to video memory 
		 in al, 0x60 ; read a char from keyboard port 
		 cmp al, 0x4B ; is the key left arrow 
		 jne nextcmpR ; no, try next comparison 
		 
	nextcmpR: cmp al, 0x4D ; is the key right arrow 
		 jne nextcmpU ; no, leave interrupt routine 
		
nextcmpU: cmp al,0x48
jne nomatch

nomatchch:		
mov al,0x20
 out 0x20, al 
		 pop es 
		 pop ax 
		 pop bx
		 iret
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;delay 
delay_timer:
 mov cx, 8  ; You can adjust this value to control the delay length
loopcxt:
    mov dx, 0xFFFF
loop_agt:
    sub dx, 1
    jnz loop_agt
    loop loopcxt
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;random number generation

	      
RANDSTART:

   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 4    
   div  cx       ; here dx contains the remainder of the division - from 0 to 3

   add  dl, '1'  ; to adjust the range from 1 to 4
sub dx,0x30
		 mov word[shape_num],dx
	 call clrscr_right
	 push ax
	 mov word[ypos_mov],20
	  mov word[xpos_mov],58
	  pop ax
	 
	  call print_Block
 MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight
   mov  ax, dx
   xor  dx, dx
   mov  cx, 23   
   div  cx       
   add  dx, 6    
		mov word[xpos_mov], dx
	 mov word[ypos_mov], 3 
	call block_movment
   jmp RANDSTART
RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;triangle print
[org 0x0100]

jmp start
xpos: dw 10
ypos: dw 10


start:
call clrscr
call printTriangle


printTriangle:
pusha

mov ax, 0xb800
mov es, ax

mov ax, 0
mov al, 80
mul byte [ypos]
add ax, [xpos]
shl ax, 1
mov di, ax
mov ax, 0x072A ; asterisk
mov cx, 10

l1:
sub cx, 1
push cx
push di

rep stosw
pop di
sub di, 158
pop cx
loop l1

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;snake game asterick xenia
[org 0x0100]	
jmp start1

location: dw 2000
oldisr: dd 0
oldisr2:dd 0
counter:dw 0
horizontal:dw 80
vertical:dw 12
right:db 0
left:db 0
up:db 0
down:db 0
start:db 0

clrscr:		push es
			push ax
			push di

			mov ax, 0xb800
			mov es, ax					; point es to video base
			mov di, 0					; point di to top left column

nextloc:	mov word [es:di],0x0720	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 4000				; has the whole screen cleared
			jne nextloc					; if no clear next position

			pop di
			pop ax
			pop es
			ret

delayx:     push cx
			mov cx, 0xFFFF
loopee1:		loop loopee1
			mov cx, 0xFFFf
loopee2:		loop loopee2
			pop cx
			ret	
			
start_screen:
			call clrscr
			mov ax,0xb800
			mov es,ax
			mov ax,[location]
			mov di,ax
			mov ah,0x07
			mov al,'*'
			mov [es:di],ax
			ret
			
printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 140 ; point di to 70th column
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax 
pop es
pop bp
ret 2			

termination:

			mov al,0x20
			out 0x20,al
			pop es			
			popa
			
			
mov ax,[oldisr]
mov bx,[oldisr+2]
cli
mov [es:8*4],ax
mov [es:8*4+2],bx
sti

mov ax,[oldisr2]
mov bx,[oldisr2+2]
cli
mov [es:9*4],ax
mov [es:9*4+2],bx
sti


			
			call clrscr 
			push word[cs:counter]
			call printnum
			
		mov ax, 0x3100 ; terminate and stay resident
		int 0x21 
			
			
			
timer:
			pusha
			push es

			mov ax,0xb800
			mov es,ax
			
			inc word[cs:counter]
			push word [cs:counter]
			call printnum ; print tick count
				
			cmp byte[cs:start],1
			jne end1
			
			cmp byte[cs:up],1
			jne next1

			mov di,[cs:location]
			mov word[es:di],0x0720
			sub di,160
			mov ah,0x07
			mov al,'*'
			mov [es:di],ax
			mov [cs:location],di
			dec word[cs:vertical]
			cmp byte[cs:vertical],0
			jl termination
			cmp byte[cs:vertical],24
			jg termination
			
			jmp end1
			next1:
			cmp byte[cs:down],1
			jne next2
			mov di,[cs:location]
			mov word[es:di],0x0720
			add di,160
			mov ah,0x07
			mov al,'*'
			mov [es:di],ax
			mov [cs:location],di
			inc byte[cs:vertical]
			cmp word[cs:vertical],0
			jl termination
			cmp word[cs:vertical],24
			ja termination
	
			jmp end1
			
next2:      cmp byte[cs:left],1
			jne next3
			mov di,[cs:location]
			mov word[es:di],0x0720
			sub di,2
			mov ah,0x07
			mov al,'*'
			mov [es:di],ax
			mov [cs:location],di
			sub word[cs:horizontal],2
			cmp byte[cs:horizontal],0
			jb termination
			cmp byte[cs:horizontal],158
			ja termination	
						
			jmp end1
next3:		cmp byte[cs:right],1
			jne end1
			mov di,[cs:location]
			mov word[es:di],0x0720
			add di,2
			mov ah,0x07
			mov al,'*'
			mov [es:di],ax
			mov [cs:location],di
			add byte[cs:horizontal],2
			cmp byte[cs:horizontal],0
			jb termination
			cmp byte[cs:horizontal],158
			ja termination	
			
			end1:
			mov al,0x20
			out 0x20,al
			
			pop es
			popa
			iret
			

kbisr:		pusha
			push es

			mov ax, 0xb800
			mov es, ax ; point es to video memory

			in al, 0x60 ; read a char from keyboard port
			cmp al, 0x48     ;up arrow
			jne nextcmp1
			mov byte[cs:start],1
			mov byte[cs:up],1
			mov byte[cs:down],0
			mov byte[cs:right],0
			mov byte[cs:left],0

			jmp exit
			

nextcmp1:	cmp al, 0x50     ;down arrow
			jne nextcmp2
			mov byte[cs:start],1
			mov byte[cs:up],0
			mov byte[cs:down],1
			mov byte[cs:right],0
			mov byte[cs:left],0	
			jmp exit


nextcmp2:	cmp al, 0x4b     ;left arrow
			jne nextcmp3
			mov byte[cs:start],1
			mov byte[cs:up],0
			mov byte[cs:down],0
			mov byte[cs:right],0
			mov byte[cs:left],1			

			jmp exit

nextcmp3:	cmp al, 0x4d     ;right arrow
			jne nomatch			
			mov byte[cs:start],1
			mov byte[cs:up],0
			mov byte[cs:down],0
			mov byte[cs:right],1
			mov byte[cs:left],0		
			jmp exit			
			
		
nomatch:	pop es
			popa
			jmp far [cs:oldisr] ; call the original ISR

exit:	
            mov al, 0x20
			out 0x20, al ; send EOI to PIC
			pop es
			popa
			iret ; return from interrupt	
			
start1:			
		call start_screen

		xor ax, ax
		mov es, ax ; point es to IVT base
		mov ax, [es:8*4]
		mov [oldisr], ax ; save offset of old routine
		mov ax, [es:8*4+2]
		mov [oldisr+2], ax ; save segment of old routine

		mov ax, [es:9*4]
		mov [oldisr2], ax ; save offset of old routine
		mov ax, [es:9*4+2]
		mov [oldisr2+2], ax ; save segment of old routine		
		
		mov ah,0
		int 0x16

		cli ; disable interrupts
		mov word [es:9*4], kbisr ; store offset at n*4
		mov [es:9*4+2], cs ; store segment at n*4+2
		mov word [es:8*4], timer; store offset at n*4  ;--
		mov [es:8*4+2], cs ; store segment at n*4+2    ;--
		sti
		
		
		mov dx, start ; end of resident portion
		add dx, 15 ; round up to next para
		mov cl, 4
		shr dx, cl ; number of paras..../2^4
		
		
s1:jmp s1


mov ax,0x3100
int 0x21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scroll left[org 0x0100]
jmp start
scrollleft:
mov ax,0xb800
mov es,ax
mov ds,ax
mov cx,40
l0:
push cx
mov di,0
mov si,2
mov cx,25
l1:
push cx
mov cx,80
cld
rep movsw

pop cx
loop l1

push di
mov di,158
mov cx,25
mov ax,0x0720
l2:
mov [es:di],ax
add di,160

loop l2
pop di
pop cx
loop l0
ret
start:
call scrollleft
mov ah,0x1
int 0x21
mov ax,0x4c00
int 0x21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;fast national university
[org 0x0100]

jmp start

ticks_counter: dw 0

print_string: db 'NATIONAL UNIVERSITY OF COMPUTER & EMERGING SCIENCES'
s1_length: dw 51
name_string: db 'YOUR NAME'
s2_length: dw 9

timer_isr:

push ax
push bx
push cx
push dx
push si
push di
push ds
push es

mov ax,[ticks_counter]
inc ax

cmp ax,182
JNE timer_end
mov ax,0

push ds

push ds
pop es
push 0xb800
pop ds
mov di,screen_save
mov si,0
mov cx,2000
rep movsw

pop ds

push 0xb800
pop es
mov di,0
mov cx,2000
mov ax,0x0720
rep stosw

mov cx,[s1_length]
mov ax, ds
mov es, ax
mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x07
mov dh, 11
mov dl, 10
mov bp, print_string
int 10h

mov cx,[s2_length]
mov ax, ds
mov es, ax
mov ah, 0x13
mov al, 0
mov bh, 0
mov bl, 0x70
mov dh, 5
mov dl, 30
mov bp, name_string
int 10h


timer_end:
mov [ticks_counter],ax
mov al,0x20
out 0x20,al

pop es
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax
iret

og_time: dw 0
og_time_seg: dw 0

hook_isr:
push bp
mov bp,sp
push ax
push bx
push dx
push di
push si
push es

xor ax,ax
push ax
pop es
mov ax,[bp + 4] ;isr number
mov di,[bp + 6] ;isr save points
mov bx,[bp + 8] ;custom isr

mov dx,4
mul dx
mov si,ax

;saving
mov ax,[es:si]
mov [di],ax
mov ax,[es:si+2]
mov [di+2],ax

CLI
mov word[es:si],bx
mov word[es:si+2],cs
STI

pop es
pop si
pop di
pop dx
pop bx
pop ax
pop bp
ret 6

unhook_isr:
push bp
mov bp,sp
push ax
push di
push si
push es

xor ax,ax
push ax
pop es
mov ax,[bp + 4] ;isr number
mov di,[bp + 6] ;isr save points

mov dx,4
mul dx
mov si,ax

CLI
mov ax,[di]
mov word[es:si],ax
mov ax,[di+2]
mov word[es:si+2],ax
STI

pop es
pop si
pop di
pop ax
pop bp
ret 4

start:

push timer_isr
push og_time
push 8
call hook_isr

L1:
inc cx
loop L1

push og_time
push 8
call unhook_isr

mov ax,4c00h
int 21h

screen_save: dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;rectangle
[org 0x0100]

jmp start
xpos: dw 0
ypos: dw 4

start:

call clrscr
call printRect

jmp exit

exit:
mov ax, 0x4c00
int 0x21




printRect:
pusha
mov ax, 0xb800
mov es, ax

mov ax, 0
mov al, 80
mul word[ypos]
add ax, [xpos]

mov di, ax
push di
mov ax, 0x092A ;asterisk


mov cx, 20
rep stosw

pop di
mov cx, 5
l1:
stosw
add di, 158
loop l1

mov cx, 20
rep stosw


mov cx, 5
l2:
stosw
sub di, 162
loop l2


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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;digit separator
[org 0x0100]

d1: db 0
d2: db 0
d3: db 0
d4: db 0
r: dw 0
l: dw 0

jmp start


start:

mov ax, 0x1234
push ax
call digitSeparator


exit:
mov ax, 0x4c00
int 0x21



digitSeparator:
push bp
mov bp, sp
push ax
push bx


mov ax, [bp+4]
mov bh, ah
shr bh, 4
mov bl, 0
mov [d1], bh

mov bh, ah
shl bh,4 
shr bh, 4

mov [d2], bh


mov bh, al
shr bh, 4
mov [d3], bh

mov bh, al
shl bh,4 
shr bh,4 
mov [d4], bh

pop bx
pop ax

pop bp
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;flip top opposite screen
[org 0x0100] 
 jmp start 
oldisr: dd 0 
buffer:dw 0
kbisr: push ax 
 push es 
 mov ax, 0xb800 
 mov es, ax ; point es to video memory 
 in al, 0x60 ; read a char from keyboard port 
 cmp al, 0x2a ; has the left shift pressed 
 jne nextcmp ; no, try next comparison 
push ax 
 push cx 
 push si 
 push di 
 push es 
 push ds 
 mov ax, 80 ; load chars per row in ax 
 mov bl,24
 mul bl ; calculate source position 
 mov si, ax ; load source position in si 
 ;push si ; save position for later use 
 shl si, 1 ; convert to byte offset 
 mov cx, 2000 ; number of screen locations 
 sub cx, ax ; count of words to move 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ds, ax ; point ds to video base 
 xor di, di ; point di to top left column 
 mov cx,2100
 l1:
 push word[es:di]
 add di,2
 loop l1
 mov cx,2100
 xor di,di
 l2:
 pop ax
 mov [buffer+di],ax
add di,2 
 loop l2
 ; cld ; set auto increment mode 
 ; rep movsw ; scroll up 
 ; mov ax, 0x0720 ; space in normal attribute 
 ; pop cx ; count of positions to clear 
 ; rep stosw ; clear the scrolled space 
 pop ds 
 pop es 
 pop di 
 pop si 
 pop cx 
 pop ax 
 jmp exit ; leave interrupt routine 
 
nextcmp: cmp al, 0x36 ; has the right shift pressed 
 jne nomatch ; no, try next comparison 
push ax 
 push cx 
 push si 
 push di 
 push es 
 push ds 
 mov ax, 80 ; load chars per row in ax 
mov bl,3
mul bl
 ;push ax ; save position for later use 
 shl ax, 1 ; convert to byte offset 
 mov si, 3998 ; last location on the screen 
 sub si, ax ; load source position in si 
 mov cx, 2000 ; number of screen locations 
 sub cx, ax ; count of words to move 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ds, ax ; point ds to video base 
 mov di, 3998 ; point di to lower right column 
 xor di,di
mov cx,2100 
 l3:
 mov ax,[buffer+di]
 mov word[es:di],ax
 add di,2
 loop l3
 ; std ; set auto decrement mode 
 ; rep movsw ; scroll up 
 ; mov ax, 0x0720 ; space in normal attribute 
 ; pop cx ; count of positions to clear 
 ; rep stosw ; clear the scrolled space 
 pop ds 
 pop es 
 pop di 
 pop si 
 pop cx 
 pop ax 

jmp exit ; leave interrupt routine 
nomatch: pop es 
 pop ax 
 jmp far [cs:oldisr] ; call the original ISR 
exit: mov al, 0x20 
 out 0x20, al ; send EOI to PIC 
 pop es 
 pop ax 
 iret ; return from interrupt 
 
start: xor ax, ax 
 mov es, ax ; point es to IVT base 
 mov ax, [es:9*4] 
 mov [oldisr], ax ; save offset of old routine 
 mov ax, [es:9*4+2] 
 mov [oldisr+2], ax ; save segment of old routine 
 cli ; disable interrupts 
 mov word [es:9*4], kbisr ; store offset at n*4 
 mov [es:9*4+2], cs ; store segment at n*4+2 
 sti ; enable interrupts 
 mov dx, start ; end of resident portion 
 add dx, 15 ; round up to next para 
 mov cl, 4 
 shr dx, cl ; number of paras 
 mov ax, 0x3100 ; terminate and stay resident 
 int 0x21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;snake asterick xenia game talha


; display a tick count on the top right of screen
[org 0x0100]
jmp start
oldisr: dd 0

string db "Your Score: $" 

len: dw 12
tickcount: dw 0
seconds: dw 0
lasttick: dw 0
lasttick2: dw 0
xpos: dw 35
ypos: dw 12
oldx: dw 0
oldy: dw 0
lflag: dw 0 ;left
rflag: dw 0 ;right
uflag: dw 0 ; up
dflag: dw 0 ; down


; subroutine to print a number at top left of screen
; takes the number to be printed as its parameter
printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 140 ; point di to 70th column
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 2


;keyboard interrupt

kbisr:
push ax
push es
mov ax, 0xb800

mov es, ax ; point es to video memory

in al, 0x60 ; read a char from keyboard port

cmp al, 0x48 ; is the key up btn
jne downcmp ; no, try next comparison
mov word[cs:uflag], 1
mov word[cs:dflag], 0
mov word[cs:rflag], 0
mov word[cs:lflag], 0
;sub word[cs:ypos], 1

jmp nomatch ; leave interrupt routine

downcmp: cmp al, 0x50 ; is the key down btn
jne leftcmp
mov word[cs:dflag], 1
mov word[cs:uflag], 0
mov word[cs:lflag], 0
mov word[cs:rflag], 0
;add word[cs:ypos], 1
jmp nomatch ; no, leave interrupt routine

leftcmp:
cmp al, 0x4B
jne rightcmp
mov word[cs:lflag], 1
mov word[cs:rflag], 0
mov word[cs:dflag], 0
mov word[cs:uflag], 0
;sub word[cs:xpos], 1
jmp nomatch

rightcmp:
cmp al, 0x4D
jne nomatch
mov word[cs:rflag], 1
mov word[cs:lflag], 0
mov word[cs:uflag], 0
mov word[cs:dflag], 0
;add word[cs:xpos], 1
jmp nomatch


nomatch: mov al, 0x20
out 0x20, al ; send EOI to PIC
pop es
pop ax
iret











;timer interrupt


timer:
 push ax
 push bx
inc word [cs:tickcount]; increment tick count
mov ax, [cs:tickcount]
mov bx, [cs:lasttick]
sub ax, bx
cmp ax, 13
jb continue

;second passed:
mov ax, [cs:tickcount]
mov [cs:lasttick], ax

inc word [cs:seconds]

;passing parameter and calling printnum
push word [cs:seconds]
call printnum ; print tick count

continue:

mov ax, [cs:tickcount]
mov bx, [cs:lasttick2]
sub ax, bx
cmp ax, 2
jb continue2
mov ax, [cs:tickcount]
mov [cs:lasttick2], ax

call updatelocation


continue2:



mov al, 0x20
out 0x20, al ; end of interrupt
pop bx
pop ax
iret ; return from interrupt


;function to print asterisk
printasterisk:

push bp
mov bp, sp
push ax
push di

mov ax, 0xb800
mov es, ax ; point es to video base

mov al, 80 ; load al with columns per row
mul byte[oldy] ; multiply with y position

add ax, [oldx] ; add x position
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location
mov word[ es:di], 0x00DB ; clear asterisk from old position


mov ax, [xpos]
mov word[oldx], ax
mov ax, [ypos]
mov word[oldy], ax

mov al, 80 ; load al with columns per row
mul byte[ypos] ; multiply with y position

add ax, [xpos] ; add x position

;add ax, 10
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location

mov word [es:di], 0x072A  ; print asterisk
;mov word [es:10], 0x072A


pop di
pop ax
pop bp

ret


updatelocation:

cmp word[lflag], 1
jne cmprflag
sub word[xpos], 1
jmp exitlocation

cmprflag:
cmp word[rflag], 1
jne cmpuflag
add word[xpos], 1
jmp exitlocation

cmpuflag:
cmp word[uflag], 1
jne cmpdflag
sub word[ypos], 1
jmp exitlocation


cmpdflag:
cmp word[dflag], 1
jne exitlocation
add word[ypos], 1

exitlocation:


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

STRLEN:
	push bp
	mov bp, sp

	push es
	push di
	push ax
	push cx

	push cs
	pop  es
	mov  di, [bp+4]
	mov  cx, 0xffff
	xor  al, al
	repne scasb
	mov  ax, 0xffff
	sub  ax, cx
	dec  ax

	mov [bp+6], ax

	pop cx
	pop ax
	pop di
	pop es

	pop bp
ret 2

printStr:
	push bp
	mov bp, sp

	pusha

	xor bh, bh
	mov si, [bp+4]

	push 0
	push si
	call STRLEN
	pop cx

	mov dl, [bp+10]
	mov dh, [bp+8]
nextPrint:
	push cx

	;setting cursor
	mov ah, 0x2
	int 0x10

	mov al, [si]
	mov bl, [bp+6]
	mov cx, 1
	mov ah, 0x9
	int 0x10

	inc dl
	inc si
	pop cx
	loop nextPrint

	popa

	pop bp
	
	ret 8

printscore:

mov ah,02h
mov bh, 0
mov dh, 0
mov dl, 55
int 10h

mov ah,9
mov dx, string
int 21h 



jmp exit



start: 
call clrscr



xor ax, ax
mov es, ax ; point es to IVT base
mov ax, [es:8*4]
mov [oldisr], ax ; save offset of old routine
mov ax, [es:8*4+2]
mov [oldisr+2], ax
cli ; disable interrupts

mov word [es:8*4], timer; store offset at n*4
mov [es:8*4+2], cs ; store segment at n*4+2
mov word[ es:9*4], kbisr
mov [es:9*4+2], cs
sti ; enable interrupts
mov dx, start ; end of resident portion
add dx, 15 ; round up to next para
mov cl, 4
shr dx, cl ; number of paras

infloop:
;call clrscr
cmp word[xpos], 80
je printscore
cmp word[xpos], 0
je printscore
cmp word[ypos], 25
je printscore
cmp word[ypos], 0
je printscore


call printasterisk


;call updatelocation
jmp infloop

jmp infloop

exit:
xor ax, ax
mov es, ax
mov ax, [oldisr] ; read old offset in ax
mov bx, [oldisr+2] ; read old segment in bx
cli ; disable interrupts
mov [es:8*4], ax ; restore old offset from ax
mov [es:8*4+2], bx ; restore old segment from bx
sti ; enable interrupts
mov ax, 0x4c00 ; terminate program
int 0x21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;store data in bufferstore_buffer:
push    bp
mov     bp, sp
push    ax
push    cx
push    si
push    di
push    es
push    ds

mov     ax, 0xb800  ; points to video memory
mov     ds, ax
mov     si, 0
mov     ax, cs
mov     es, ax
mov     di, buffer
mov     cx, 2000

cld
rep     movsw    ; move data from video memory to buffer

pop     ds
pop     es
pop     di
pop     si
pop     cx
pop     ax
pop     bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; load buffer
load_buffer:
push    bp
mov     bp, sp
push    ax
push    cx
push    si
push    di
push    es
push    ds

mov     ax, 0xb800      ; points to video memory
mov     es, ax
mov     di, 0
; points to buffer
mov     ax, cs
mov     ds, ax
mov     si, buffer
mov     cx, 2000

cld
rep     movsw       ; load buffer in video memory

pop     ds
pop     es
pop     di
pop     si
pop     cx
pop     ax
pop     bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Write a subroutine “strcpy” that takes the address of two parameters via stack, 
;the one pushed first is source and the second is the destination. 
;The function should copy the source on the destination 
;including the null character assuming that sufficient space is reserved starting at destination.



[org 0x0100]



start: 		push src
			push dest

			call strcpy

end:		mov ax, 0x4c00
			int 21h



;-----------------------------------------------------------------------------------------------------------

strLen:			push bp
				mov bp, sp
				pusha

				push es

				push ds
				pop es

				mov di, [bp+4]		;Point di to string 
				mov cx, 0xFFFF		;Load Maximum No. in cx
				mov al, 0 			;Load a zero in al
				repne scasb			;find zero in the string

				mov ax, 0xFFFF 		;Load Maximum No. in ax
				sub ax, cx          ;Find change in cx
				dec ax				;Exclude null from length

				mov [bp+6], ax


				pop es

				popa
				pop bp
				ret 2

;-----------------------------------------------------------------------------------------------------------





strcpy:			push bp
				mov bp, sp
				pusha

				push es


				;bp + 6  = src address
				;bp + 4  = dest address


				mov si, [bp + 6]				;Setting si to source str


				push ds
				pop  es                         ;Setting es


				mov di, [bp + 4]				;Setting di to destination str


				sub sp, 2 
				push word [bp + 6]
				call strLen						;Calculating the length of source string
												;because ultimately the source and the destination will be of the same size

				pop cx

				inc cx							;Incrementing cx by one so that null character gets included in the string length

				rep movsb


				pop es

return:			popa
				pop bp
				ret 4

;-----------------------------------------------------------------------------------------------------------


src: 	db 'My name is NULL',0
dest:	db 000000000000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Write a subroutine to copy a given area on the screen at the center of the screen without using a temporary array.
;The routine will be passed top, left, bottom, and right in that order through the stack. 
;The parameters passed will always be within range the height will be odd and the width will be even so that it can be exactly centered.


[org 0x0100]

	jmp start


top:	dw 17
bottom: dw 20
left:	dw 15
right: 	dw 30


start:		push word [top]
			push word [left]
			push word [bottom]
			push word [right]

			call copyAtCenter

end:		mov ax, 0x4c00
			int 21h




;---------------------------------------------------------------------------------------------------


copyAtCenter:	push bp
				mov bp, sp 
				pusha

				push es
				push ds

				;bp+4 = right 
				;bp+6 = bottom
				;bp+8 = left
				;bp+10 = top

				mov ax, 0xB800
				mov es, ax

				;Center of screen

				;Row = 12
				;Col = 39,40

				mov bx, 39 				;Mid Col
				mov dx, 12				;Mid Row


				;Calculating Width 
				mov ax, [bp + 4]
				sub ax, [bp + 8]

				push ax 				;Saving width for later use 

				sub ax, 2
				shr ax, 1

				;Getting to the required starting column
				sub bx, ax


				;Calculating height
				mov ax, [bp + 6]
				sub ax, [bp + 10]

				push ax 				;Saving height for later use

				sub ax, 1
				shr ax, 1 


				;Getting to the required starting row
				sub dx, ax


				;Staring position of source
				mov al , 80
				dec byte [bp + 10]
				mul byte [bp + 10]    ;Top
				dec byte [bp + 8]
				add ax, [bp + 8] 	  ;Left
				shl ax, 1

				mov si, ax


				;Starting position of destination
				mov al, 80 					;Load al with columns per row 
				mul dl						;Multiply with y position
				add ax, bx 					;add x position
				shl ax, 1

				mov di, ax 				


				pop ax 			;Height
				pop cx 			;Width


				push es
				pop  ds 


				mov bx, 0

				;Now moving the area to the center

l1:				push si
				push di 
				
				push cx
				rep movsw
				pop cx

				pop di
				pop si

				add si, 160
				add di, 160

				inc bx
				cmp bx, ax
				jnz l1 



				pop ds
				pop es

return:			popa
				pop bp
				ret 8			
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scroll right
[org 0x0100]
jmp start
scrollright:
mov ax,0xb800
mov es,ax
mov ds,ax
mov cx,40


l0:
push cx


mov si,3996
mov di,3998
mov cx,25
l1:
push cx


mov cx,80
std
rep movsw

pop cx
loop l1


push di
mov di,0
mov cx,25
mov ax,0x0720
l2:
mov [es:di],ax
add di,160

loop l2
pop di


pop cx
loop l0
ret
start:
call scrollright
mov ah,0x1  ; 1 = print string
int 0x21
mov ax,0x4c00
int 0x21		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;snake game full
[org 0x0100]
        jmp start

        msg: db 'Score: '
        startMsg: db 'Press Any Key to Continue: '
        randNum: db 0
        oldisr: dd 0
        snek: TIMES 300 dw 0
        len: dw 2

startMenu:
        push es
        push ax
        push cx
        push di
        push si

        mov ax, 0xb800
        mov es, ax
        mov di, 1966
        mov cx, 27
        
        mov si, 0
        mov ax, 0xb800

        nextCharStMen:
        mov al, [startMsg + si]
        mov [es:di], ax
        add di, 2
        inc si
        loop nextCharStMen

        mov ah, 0
	int 0x16

        pop si
        pop di
        pop cx
        pop ax
        pop es

        ret

clrscr:
        push cx
        push es
        push di

        mov cx, 0xb800
        mov es, cx
        mov di, 0
        mov cx, 2000

 c1:
        mov word[es:di], 0x0720
        add di, 2
        loop c1

        pop di
        pop es
        pop cx
        ret

                                        ;;              ;;              ;;              ;;      

randGen:
        push bp
        mov bp, sp
        push cx
        push dx
        push ax
        rdtsc                   ;getting a random number in ax dx
        xor dx,dx               ;making dx 0
        mov cx, [bp + 4]
        div cx                  ;dividing by 'Paramter' to get numbers from 0 - Parameter
        mov [randNum], dl      ;moving the random number in variable
        pop ax
        pop dx
        pop cx
        pop bp

        ret 2

                                        ;;              ;;              ;;              ;;      

growSnek:                       ;Pushes entire 'Snek' array one index down, and places new head at start of the array
        push bp
        mov bp, sp
        push ax
        push bx
        push si
        push di

        mov bx, snek
        mov ax, [len]
        mov si, 2
        mul si
        mov si, ax
        sub si, 2
        mov di, si
        sub di, 2

        grSn1:
        mov ax, [bx + di]
        mov [bx + si], ax
        sub di, 2
        sub si, 2
        cmp si, 0
        jne grSn1

        mov si, [bp + 4]                        ;Index of new head i.e. where snake is being grown
        mov word[snek], si

        pop di
        pop si
        pop bx
        pop ax
        pop bp

        ret 2

                                        ;;              ;;              ;;              ;;      

printSnek:                                      ;Prints blue box on every location stored in 'Snek' array
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        push es

        mov ax, 0xb800
        mov es, ax

        mov bx, snek
        mov ax, [len]
        mov si, 2
        mul si
        xor di, di
        prtSn1:
        mov si, [bx + di]
        mov word[es:si], 0x1020
        add di, 2
        cmp di, ax
        jne prtSn1      

        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax

        ret

                                        ;;              ;;              ;;              ;;      

changeSnek:                                     ;Moves entire 'Snek' array one index down and updates head based on snake's current direction and 
        push bp                                 ;       ('shr' entire array)
        mov bp, sp
        push ax
        push bx
        push si
        push di
        push es

        mov ax, 0xb800
        mov es, ax

        mov bx, snek
        mov ax, [len]
        mov si, 2
        mul si
        mov si, ax
        sub si, 2

        mov di, [bx + si]
        mov word[es:di], 0x2020                ;Print green block on old tail of the snake

        mov di, si
        sub di, 2

        ch1:
                mov ax, [bx + di]
                mov [bx + si], ax
                sub di, 2
                sub si, 2
                cmp si, 0
                jne ch1

                mov ax, [bp + 4]
                
                cmp ax, 1
                je addRight

                cmp ax, 2
                je addLeft

                cmp ax, 3
                je addDown

                cmp ax, 4
                je addUp

        endCh:
                pop es
                pop di
                pop si
                pop bx
                pop ax
                pop bp

                ret 2

        addRight:
                add word[snek], 2
                jmp endCh

        addLeft:
                sub word[snek], 2
                jmp endCh

        addDown:
                add word[snek], 160
                jmp endCh

        addUp:
        sub word[snek], 160
        jmp endCh

                                        ;;              ;;              ;;              ;;      

genApple:                                       ;Randomize and place apple on board
        push ax
        push bx
        push cx
        push dx
        push es
        push si
        push di

        dontEnd:
                mov ax, 19
                push ax
                call randGen
                xor bx, bx
                mov bl, [randNum]
                add bl, 3
                mov ax, 65
                push ax
                call randGen
                xor cx, cx
                mov cl, [randNum]
                add cl, 5

                mov ax, 80
                mul bx
                add ax, cx
                mov di, 2

                mul di

                mov si, ax
                mov ax, 0xb800
                mov es, ax

                mov ax, si
        
                div di
                cmp dx, 1
                je addOne

        drawApple:
                cmp word[es:si], 0x1020                         ;If apple spawns on snake
                je dontEnd                                      ;Repeat the randomization process
                mov word[es:si], 0x4020                         ;Else place the apple

                pop di
                pop si
                pop es
                pop dx
                pop cx
                pop bx
                pop ax

                ret

        addOne:
        add si, 1
        jmp drawApple
        
                                        ;;              ;;              ;;              ;;      

printScore:                     ;Print string "Score: " in middle of second row
        push es
        push ax
        push cx
        push di
        push si

        mov ax, 0xb800
        mov es, ax
        mov di, 230 
        mov cx, 7
        
        mov si, 0
        mov ah, 0x0D

        nextChar:
        mov al, [msg + si]
        mov [es:di], ax
        add di, 2
        inc si
        loop nextChar

        pop si
        pop di
        pop cx
        pop ax
        pop es

        ret

                                        ;;              ;;              ;;              ;;      
                                        
updateScore:                            ;Print current score in middle of sencond row (in front of string)
        push bp
        mov bp, sp
        push es
        push ax
        push bx
        push cx
        push dx
        push di

        mov ax, 0xb800
        mov es, ax
        
        mov ax, [bp + 4]
        mov bx, 10
        mov cx, 0
        nextDig:
                mov dx, 0
                div bx
                add dl, 0x30
                push dx
                inc cx
                cmp ax, 0
                jnz nextDig

                mov di, 244
        nextPos:
        pop dx
        mov dh, 0x0D
        mov [es:di], dx
        add di, 2
        loop nextPos
        
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop bp

        ret 2
        
                                        ;;              ;;              ;;              ;;      
                                        
delay:                                  ;To show a delay effect whenever snake moves
        push cx
        push ax
        mov cx, 0xffff
        mov ax, 0
        d1:
                add ax, 1
                loop d1

                mov cx, 0xffff
                mov ax, 0
        d2:
                add ax, 1
                loop d2

                mov cx, 0xffff
                mov ax, 0
        d3:
        add ax, 1
        loop d3

        pop ax
        pop cx
        ret

                                        ;;              ;;              ;;              ;;      

printBoard:                             ;Called once to print the game board and snake in its initial position
        push ax
        push bx
        push cx
        push dx
        push es
        push si
        push di

        mov ax, 0xb800
        mov es, ax

        ;                   To Print Border Rectangle

        mov si, 2               ; currRow (y-pos)
        mov bx, 4              ; currCol (x-pos)
 
        p1:
                mov cx, 0
                mov ax, 80
                mul si
                add ax, bx
                shl ax, 1
                mov di, ax
        p2:
                mov word[es:di], 0x6020
                add di, 2
                inc cx
                cmp cx, 72
                jne p2

                inc si
                cmp si, 23
                jne p1

                ;                   To FIll Rectangle w/ Green

                mov si, 3               ; currRow (y-pos)
                mov bx, 5              ; currCol (x-pos)
        
        p3:
                mov cx, 0
                mov ax, 80
                mul si
                add ax, bx
                shl ax, 1
                mov di, ax
        p4:
        mov word[es:di], 0x2020
        add di, 2
        inc cx
        cmp cx, 70
        jne p4

        inc si
        cmp si, 22
        jne p3

        ;               To Print Snake
        ;          Starting Point is (12, 17)

        mov si, 12               ; currRow (y-pos)
        mov bx, 17              ; currCol (x-pos)

        mov ax, 80
        mul si
        add ax, bx
        shl ax, 1
        mov di, ax
        mov word[es:di], 0x1020
        sub di, 2
        mov word[es:di], 0x1020

        pop di
        pop si
        pop es
        pop dx
        pop cx
        pop bx
        pop ax

        ret

                                        ;;              ;;              ;;              ;;      

controlSnek:                  ;Actual control of the entire game
        push ax
        push bx
        push cx
        push dx
        push es
        push si
        push di

        mov ax, 0xb800
        mov es, ax

        xor dx, dx
        mov si, 12             
        mov bx, 17
        mov ax, 80
        mul si
        add ax, bx
        shl ax, 1
        mov di, ax
        mov [snek], ax                  ; di holds head of snale
        mov si, di
        sub si, 2                   ; si holds tail of snake
        mov [snek + 2], si

        call printScore
        call genApple

        mov cx, 0                   ; Holds Score (Count of Apples eaten)
        mov bx, 1                   ; BX = 1 -> Right, 2 ->Left, 3 -> Down, 4 -> Up

        inputAgain:
                push cx
                call updateScore
                call delay
                mov di, [snek]

                cmp bx, 1
                je checkRight

                cmp bx, 2
                je checkLeft

                cmp bx, 3
                je checkDown

                cmp bx, 4
                je checkUp

                jmp inputAgain

                checkRight:
                        add di, 2
                        jmp check

                checkLeft:
                        sub di, 2
                        jmp check
                        
                checkDown:
                        add di, 160
                        jmp check
                        
                checkUp:
                        sub di, 160
                        jmp check
                        
                check:
                        cmp word[es:di], 0x4020
                        je newScore

                        cmp word[es:di], 0x1020
                        je death

                        cmp word[es:di], 0x6020
                        je death

                        push bx 
                        call changeSnek                 ;TODO:  clear Old Snake by pritning Green and then print new snake                          
                        call printSnek

                        jmp inputAgain

                newScore:
                        inc cx                      ; Keeping track of score
                        add word[len], 1
                        push di
                        call growSnek
                        call genApple
                        ;        push bx
                        ;        call changeSnek               
                        ;        call printSnek
                        jmp inputAgain

                death:
                call clrscr
                call printScore
                push cx
                call updateScore

        end:
        pop di
        pop si
        pop es
        pop dx
        pop cx
        pop bx
        pop ax

        ret

                                        ;;              ;;              ;;              ;;      

kbisr:
        push bx
        mov bl, 1
        in al, 0x60
        pop bx

        cmp al, 0x48
        je up
        cmp al, 0x4B
        je left
        cmp al, 0x4D
        je right
        cmp al, 0x50
        je down

        jmp far [cs:oldisr]

        up:
                cmp bx, 3
                jne changeUp
                jmp far [cs:oldisr]

        changeUp:
                mov bx, 4
                jmp far [cs:oldisr]

        down:
                cmp bx, 4
                jne changeDown
                jmp far [cs:oldisr]

        changeDown:
                mov bx, 3
                jmp far [cs:oldisr]

        right:
                cmp bx, 2
                jne changeRight
                jmp far [cs:oldisr]

        changeRight:
                mov bx, 1
                jmp far [cs:oldisr]

        left:
                cmp bx, 1
                jne changeLeft
                jmp far [cs:oldisr]

        changeLeft:
        mov bx, 2
        jmp far [cs:oldisr]

                                        ;;              ;;              ;;              ;;      

start:
        call clrscr
        call startMenu

        xor ax, ax                      ;Hooking Interrupt
	mov es, ax
	mov ax, [es:9 * 4]
        mov [oldisr], ax
	mov ax, [es:9 * 4 + 2]
	mov [oldisr + 2], ax
	
        cli
	mov word[es:9 * 4], kbisr
	mov [es:9 * 4 + 2], cs
	sti

        call clrscr
        call printBoard             
        call controlSnek

        xor ax, ax                      ;Unhooking Interrupt
	mov es, ax
        mov ax, [oldisr]
	mov bx, [oldisr + 2]

	cli
	mov [es:9 * 4], ax
	mov [es:9 * 4 + 2], bx
	sti

        mov ax, 0x4c00
        int 0x21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scenary full house trees
CODE:
; circle in graphics mode
[org 0x0100]
jmp start
; coordinates of a circle of radius 24
x24: dw 48,47,44,40,36,30,24,17,12,7,3,0,0,0,3,7,11,17,23,30,36,40,44,47,48
y24: dw 24,30,36,40,44,47,48,47,44,40,36,30,24,17,11,7,3,0,0,0,3,7,11,17,23
; coordinates of a circle of radius 45
x45: dw 90,89,88,86,83,79,75,70,64,58,52,46,40,34,28,22,17,12,8,5,2,0,0,0,0,2,5,8,12,17,22,28,34,40,46,52,58,64,70,75,79,83,86,88,89,90
y45: dw 45,51,57,63,68,73,78,82,85,87,89,89,89,88,86,83,80,76,71,66,60,54,48,41,35,29,23,18,13,9,6,3,1,0,0,0,2,4,7,11,16,21,26,32,38,44
; coordinates of a circle of radius 72
x72: dw 144,143,142,141,139,137,134,130,127,122,118,113,108,102,96,90,84,78,72,65,59,53,47,41,36,30,25,21,16,13,9,6,4,2,1,0,0,0,1,2,4,6,9,13,16,21,25,30,35,41,47,53,59,65,71,78,84,90,96,102,108,113,118,122,127,130,134,137,139,141,142,143,144
y72: dw 72,78,84,90,96,102,108,113,118,122,127,130,134,137,139,141,142,143,144,143,142,141,139,137,134,130,127,122,118,113,108,102,96,90,84,78,72,65,59,53,47,41,35,30,25,21,16,13,9,6,4,2,1,0,0,0,1,2,4,6,9,13,16,21,25,30,35,41,47,53,59,65,71
; coordinates of a circle of radius 120
x120: dw 240,239,239,238,237,235,234,232,229,226,223,220,217,213,209,204,200,195,190,185,180,174,168,163,157,151,144,138,132,126,120,113,107,101,95,88,82,76,71,65,60,54,49,44,39,35,30,26,22,19,16,13,10,7,5,4,2,1,0,0,0,0,0,1,2,4,5,7,10,13,16,19,22,26,30,35,39,44,49,54,59,65,71,76,82,88,95,101,107,113,119,126,132,138,144,151,157,163,168,174,180,185,190,195,200,204,209,213,217,220,223,226,229,232,234,235,237,238,239,239,240
y120: dw 120,126,132,138,144,151,157,163,168,174,180,185,190,195,200,204,209,213,217,220,223,226,229,232,234,235,237,238,239,239,240,239,239,238,237,235,234,232,229,226,223,220,217,213,209,204,200,195,190,185,180,174,168,163,157,151,144,138,132,126,120,113,107,101,95,88,82,76,71,65,59,54,49,44,39,35,30,26,22,19,16,13,10,7,5,4,2,1,0,0,0,0,0,1,2,4,5,7,10,13,16,19,22,26,30,35,39,44,49,54,59,65,71,76,82,88,95,101,107,113,119
; setting up the parameters
counter : db 0;
radius : dw 45; choose radius (24, 45, 72, 120)
xoffset: dw 0 ; change to move circle along x axis
yoffset: dw 0 ; change to move circle along y axis
w: dw 100 ; width offset
x: dw 50 ; starting x coordinate of line
y: dw 100 ; starting y coordinate of line
c: dw 60 ; color
drawHome:
;first we will print the hat of the house
mov word [x], 320
mov word [y], 50
call drawWideDiagnol1
mov word [x], 320
mov word [y], 50
call drawWideDiagnol2
mov word [w], 200
mov word [x], 220
mov word [y], 100
call drawVerticalLine
; now we will draw the below rectangle of the house
mov word [w], 150
mov word [x], 240
mov word [y], 105
call drawVerticalLine
mov word [w], 60
mov word [x], 390
mov word [y], 105
call drawHorizontalLine
mov word [w], 60
mov word [x], 240
mov word [y], 105
call drawHorizontalLine
mov word [w], 150
mov word [x], 240
mov word [y], 165
call drawVerticalLine
;now we will draw the tree
mov word [xoffset], 100
mov word [yoffset], 45
mov word [radius], 24
mov si, x24; change x array as radius
mov di, y24; change y array as radius
call printCircle
mov word [xoffset], 140
mov word [yoffset], 45
mov word [radius], 24
mov si, x24; change x array as radius
mov di, y24; change y array as radius
call printCircle
mov word [xoffset], 120
mov word [yoffset], 25
mov word [radius], 24
mov si, x24; change x array as radius
mov di, y24; change y array as radius
call printCircle
; now we will draw the below of the tree
mov word [w], 20
mov word [x], 130
mov word [y],90
call drawVerticalLine
mov word [w], 100
mov word [x], 150
mov word [y], 90
call drawHorizontalLine
mov word [w], 60
mov word [w], 100
mov word [x], 130
mov word [y], 90
call drawHorizontalLine
mov word [w], 20
mov word [x], 130
mov word [y], 190
call drawVerticalLine
;this prints the bush
mov word [xoffset], 55
mov word [yoffset], 251
mov word [radius], 45
mov si, x45; change x array as radius
mov di, y45; change y array as radius
call printCircle
; this prints the sun
mov word [xoffset], 500
mov word [yoffset], 10
mov word [radius], 45
mov si, x45; change x array as radius
mov di, y45; change y array as radius
call printCircle
; right tree below
mov word [w], 20
mov word [x], 530
mov word [y], 190
call drawVerticalLine
mov word [w], 100
mov word [x], 550
mov word [y], 190
call drawHorizontalLine
mov word [w], 60
mov word [w], 100
mov word [x], 530
mov word [y], 190
call drawHorizontalLine
mov word [w], 20
mov word [x], 530
mov word [y], 290
call drawVerticalLine
mov word [w], 50
mov word [x], 540
mov word [y], 120
call drawDiagonalNormal1
mov word [x], 540
mov word [y], 120
call drawDiagonalNormal2
mov word [x], 540
mov word [y], 140
call drawDiagonalNormal1
mov word [x], 540
mov word [y], 140
call drawDiagonalNormal2
mov word [w], 300
mov word [x], 380
mov word [y], 170
call drawDiagonalNormal1
mov word [x], 320
mov word [y], 170
call drawDiagonalNormal2
ret
drawDiagonalNormal1:
mov si, [x]
add si, [w]
; draw vertical
mov cx, [x]
mov dx, [y]
mov al, [c]
u6:
mov ah, 0ch ; put pixel
int 10h
inc dx
add cx,1
cmp cx,si
jbe u6
ret
drawDiagonalNormal2:
mov si, [x]
sub si, [w]
; draw vertical
mov cx, [x]
mov dx, [y]
mov al, [c]
u7:
mov ah, 0ch ; put pixel
int 10h
inc dx
sub cx,1
cmp cx,si
jge u7
ret
printCircle:
push ax
push bx
push cx
push dx
push si
push di
mov byte [counter],0
mov cx, [si] ; first x position
add cx, [xoffset] ; moving point along x axis
mov dx, [di] ; first y position
add dx, [yoffset] ; moving point along y axis
l1:
int 0x10 ; bios video services
add si, 2 ; next location address
add di, 2 ; next location address
mov cx, [si]
add cx, [xoffset]
mov dx, [di]
add dx, [yoffset]
push ax
mov al, [radius]
inc byte[counter]
cmp [counter], al ; stopping condition
pop ax
jle l1 ; jump if less
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret
drawVerticalLine:
mov si, [x]
add si, [w]
; draw vertical
mov cx, [x]
mov dx, [y]
mov al, [c]
u1:
mov ah, 0ch ; put pixel
int 10h
inc cx
cmp cx,si
jbe u1
ret
drawHorizontalLine:
mov si, [y]
add si, [w]
; draw vertical
mov cx, [x]
mov dx, [y]
mov al, [c]
u2:
mov ah, 0ch ; put pixel
int 10h
inc dx
cmp dx,si
jbe u2
ret
drawWideDiagnol1:
mov si, [x]
add si, [w]
; draw vertical
mov cx, [x]
mov dx, [y]
mov al, [c]
u3:
mov ah, 0ch ; put pixel
int 10h
inc dx
add cx,2
cmp cx,si
jbe u3
ret
drawWideDiagnol2:
mov si, [x]
sub si, [w]
; draw vertical
mov cx, [x]
mov dx, [y]
mov al, [c]
u4:
mov ah, 0ch ; put pixel
int 10h
inc dx
sub cx,2
cmp cx,si
jge u4
ret
drawTree:
ret
start:
; going into the video memory
mov ax, 0x0010 ; set 640 x 350 graphics mode
int 0x10 ; bios video services
mov ax, 0x0C07 ; put pixel in white color
xor bx, bx ; page number 0
;your code starts here zaki sir
call drawHome
mov ah, 0 ; service 0 – get keystroke
int 0x16 ; bios keyboard services
mov ax, 0x0003 ; 80x25 text mode
int 0x10 ; bios video services
mov ax, 0x4c00 ; terminate program
int 0x21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;diamond
[org 0x0100]
jmp code
w equ 50 ; width offset
x equ 50 ; starting x coordinate of line
y equ 100 ; starting y coordinate of line
c equ 60 ; color
code:
mov ah, 0
mov al, 13h
int 10h
; draw diagonal 11:
mov cx, x
mov dx, y
mov al, c
u1:
inc dx
mov ah, 0ch ; put pixel
int 10h
inc cx
cmp cx, x+w
jbe u1
;wait for keypress
;mov ah,00
;int 16h
u2:
dec dx
mov ah, 0ch ; put pixel
int 10h
inc cx
cmp cx, x+y
jbe u2
;wait for keypress
;mov ah,00
;int 16h
mov cx, 50
mov dx, 100
mov al, c
u3:
dec dx
mov ah, 0ch ; put pixel
int 10h
inc cx
cmp cx, x+w
jbe u3
;wait for keypress
;mov ah,00
;int 16h
u4:
inc dx
mov ah, 0ch ; put pixel
int 10h
inc cx
cmp cx, x+y
jbe u4
;wait for keypress
mov ah,00
int 16h
mov ax, 0x4c00
int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
