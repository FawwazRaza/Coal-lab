
; Six high school students’ participants in 900 m race, You are appointed for designing the display of the scoreboard. The score board layout is as follow:
; Rank	Name	Average Speed
; (km /h)	Time Taken
; (min)
			
			
			
			
			

; The participates average speed are recorded as follows:
; 1.	Aaron Ship --------   11 km /hr
; 2.	Tee Morgan ---------- 12 km/hr
; 3.	Chris Green ------------ 10 km/hr
; 4.	Eyshal Lee -----------   14 km/hr
; 5.	Xavier Wan ----------   16 km/hr 
; a)	Store the names and the average speed under the labels Names and Speeds.				s
; b)	Calculate the time taken by each player and do the needed conversions using subroutines 		
; c)	Sort the list in ascending order, 1st position to 5th based on time taken in mins.  		                       	 
; d)	The Scoreboard will display in the manner described in part c only when user press ‘F’ key on keyboard.	

; Note: All the conversions and calculations must be done under the subroutines. Comment your code well.





[org 0x0100]
	jmp start
	

clrscr:		push es 
			push ax 
			push di 
			mov ax, 0xb800
			mov es, ax 
			mov di, 0 


nextloc:	mov word [es:di], 0x0720 ; clear next char on screen 
			add di, 2 ; move to next screen location 
			cmp di, 4000 ; has the whole screen cleared 
			jne nextloc ; if no clear next position 

			pop di 
			pop ax 
			pop es 
			
			ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
kbisr:		
		
			
			push ax
			push es
            push bx
			push dx
			mov ax, 0xb800
			mov es, ax					; point es to video memory

			in al, 0x60									; read a char from keyboard port

			cmp al, 0x1f						
			jne Exit
				
			call printprogram

Exit:
			
			mov al, 0x20
			out 0x20, al
			pop dx
			pop bx
			pop es
			pop ax
			jmp far [cs:oldisr] ; call the original ISR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
printprogram:
call print_grid
	call print_labels	
	call calculate_time
	call get_positions
	call print_data
	
.input:	
	mov ah, 0
	int 0x16
	cmp al, 0x66
	je .cont
	jmp .input

.cont:
	
	mov ax, position
	push ax
	mov ax, 5
	push ax
	call bubblesort
	call clrscr
	call print_grid
	call print_labels
	call print_data

printnum: push bp 
	 mov bp, sp 
	 push es 
	 push ax 
	 push bx 
	 push cx 
	 push dx 
	 push di 
	 push si
	 mov si, 0
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 mov ax, [bp+4] ; load number in ax 
	 cmp ax, 0
	 je _pexit
	 
	 mov cx, 0 ; initialize count of digits 
nextdigit:
	 mov bx, 10
	 mov dx, 0 ; zero upper half of dividend 
	 div bx ; divide by 10 
	 add dl, 0x30 ; convert digit into ascii value 
	 push dx ; save ascii value on stack 
	 inc cx ; increment count of values 
	 cmp ax, 0 ; is the quotient zero 
	 jnz nextdigit ; if no divide it again 
	 mov di,  [bp+6]; 
nextpos:
	 pop dx ; remove a digit from the stack 
	 mov dh, 0x04 ; use normal attribute 
	 mov [es:di], dx ; print char on screen 
	 add di, 2 ; move to next screen location 
	 ;inc si
	 loop nextpos ; repeat for all digits on stack
_pexit:
	 pop si
	 pop di 
	 pop dx 
	 pop cx 
	 pop bx 
	 pop ax 
	 pop es 
	 pop bp 
	 ret 4
	  

print_grid:
	push ax
	push bx
	mov ax, 0xb800
	mov es, ax
	mov bx, 174
	mov di, bx
	mov ah, 0x0b
	mov al, '_'
	add bx, 128
	
horizontal:
	mov [es:di], ax
	add di, 2
	cmp di, bx
	jl horizontal
	add di, 352
	add bx, 480
	cmp bx, 3300
	jl horizontal
	
	mov bx, 334
	mov di, bx	
	mov al, '.'
vertical:
v1:
	mov [es:di], ax
	add di, 160
	cmp di, 3200 
	jl v1
	add bx, 32
	mov di, bx
	cmp di, 640
	jl vertical
	
	
	pop bx
	pop ax
	ret
	
	
print_labels:
	
	push 504 ;screen offset 
	push label1
	call printstr
	
	push 530 ;screen offset 
	push label2
	call printstr
	
	push 566;screen offset 
	push label3
	call printstr
	
	push 600 ;screen offset 
	push label4
	call printstr
	
	
	ret


printstr:
	push bp
	mov bp, sp
	pusha
	
	push ds
	pop es
	mov di,[bp+4]
	mov cx, 0xffff
	xor al,al
	repne scasb
	mov ax, 0xffff
	sub ax, cx
	dec ax
	jz d
	
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+6]
	mov si, [bp+4]
	mov ah, 0x07
	cld
	nextchar:
		lodsb
		stosw
		loop nextchar
d:
		popa
		pop bp
		ret 4
	
	
print_data:
	pusha
	
	; print names
	mov di, 980
	
	push di;screen offset 
	push name1
	call printstr
	
	add di, 480
	push di ;screen offset 
	push name2
	call printstr
	
	add di, 480
	push di ;screen offset 
	push name3
	call printstr
	
	add di, 480
	push di ;screen offset 
	push name4
	call printstr
	
	add di, 480
	push di ;screen offset 
	push name5
	call printstr


	; print speed
	mov di, 1020
	mov bx, 0
	mov cx, 5
.l1:
	push di
	mov ax, [speed+bx]
	push ax
	call printnum
	add bx, 2
	add di, 480
	loop .l1
	
	
	; print time
	mov di, 1052
	mov bx, 0
	mov cx, 5
.l2:
	push di
	mov ax, [time+bx]
	push ax
	call printnum
	add bx, 2
	add di, 480
	loop .l2
	
	; print positions
	mov di, 1084
	mov bx, 0
	mov cx, 5
.l3:
	push di
	mov ax, [position+bx]
	push ax
	call printnum
	add bx, 2
	add di, 480
	loop .l3
	


	popa
	ret
	
	

get_positions:
	pusha
	
	mov cx, 5
	mov bx, 0
.l0:
	mov ax, [speed+bx]
	mov [speed_cpy+bx], ax
	add bx, 2
	loop .l0
	
	mov dx, 1
.L1:	
	
	mov ax, [speed_cpy]
	mov cx, 5
	mov bx, 0
	mov si, bx
.l1	
	cmp ax, [speed_cpy+bx]
	jg .next
	mov ax, [speed_cpy+bx]
	mov si, bx
	
.next:
	add bx, 2
	loop .l1
	mov [position+si], dx
	mov word [speed_cpy+si], 0	;visited
.N:
	inc dx
	cmp dx, 5
	jle .L1
	
	popa
	ret 
	

calculate_time:
	pusha
	
	mov si, 0
	mov cx, 5
.l1
	mov ax, [speed+si]
	shl ax, 4
	mov bx, ax
	mov dx, 0
	mov ax, [distance]
	div bx	; time = distance/speed
	mov [time+si], ax
	add si, 2
	loop .l1
	
	popa
	ret
	


swap_strings:
	push bp
	mov bp, sp
	pusha
	
	mov si, 0
	mov cx, 11
	mov dx, [bp+4]
	mov bx, [bp+6]
	mov bp, dx
.l1:
	mov dl, [bp+si]
	mov dh, [bx+si]
	mov [bp+si], dh
	mov [bx+si], dl
	inc si
	loop .l1
	
	popa
	pop bp
	ret 4


bubblesort: 
	push bp ; save old value of bp 
	mov bp, sp ; make bp our reference point 
	sub sp, 2 ; make two byte space on stack 
	push ax ; save old value of ax 
	push bx ; save old value of bx 
	push cx ; save old value of cx 
	push si ; save old value of si 
	mov bx, [bp+6] ; load start of array in bx 
	mov cx, [bp+4] ; load count of elements in cx 
	dec cx ; last element not compared 
	shl cx, 1 ; turn into byte count 
	mainloop: mov si, 0 ; initialize array index to zero 
	mov word [bp-2], 0 ; reset swap flag to no swaps 
	innerloop: mov ax, [bx+si] ; load number in ax 
	cmp ax, [bx+si+2] ; compare with next number 
	jbe  near noswap ; no swap if already in order 
	xchg ax, [bx+si+2] ; exchange ax with second number 
	mov [bx+si], ax ; store second number in first 
	
	mov ax, [speed+si]
	mov dx, [speed+si+2]
	mov [speed+si+2], ax
	mov [speed+si], dx
	
	mov ax, [time+si]
	mov dx, [time+si+2]
	mov [time+si+2], ax
	mov [time+si], dx
	
	;swap Name
		cmp si, 0
		je .one
		cmp si, 2
		je .two
		cmp si, 4
		je .three
		cmp si, 6
		je .four
	
		jmp .next
	
.one:
	push name1
	push name2
	call swap_strings 
	jmp  .next
.two:
	push name2
	push name3
	call swap_strings 
	jmp  .next
.three:
	push name3
	push name4
	call swap_strings 
	jmp  .next
.four:
	push name4
	push name5
	call swap_strings
	jmp  .next
	
.next:

	mov word [bp-2], 1 ; flag that a swap has been done 
	noswap: add si, 2 ; advance si to next index 
	cmp si, cx ; are we at last index 
	jne innerloop ; if not compare next two 

	cmp word [bp-2], 1 ; check if a swap has been done 
	je mainloop ; if yes make another pass 
	pop si ; restore old value of si 
	pop cx ; restore old value of cx 
	pop bx ; restore old value of bx 
	pop ax ; restore old value of ax 
	mov sp, bp ; remove space created on stack 
	pop bp ; restore old value of bp 
	ret 4 ; go back and remove two params


start:
	call clrscr	
    push mess
	call printstr
xor ax, ax 
 mov es, ax ; point es to IVT base 
 mov ax, [es:9*4] 
 mov [oldisr], ax ; save offset of old routine 
 mov ax, [es:9*4+2] 
 mov [oldisr+2], ax ; save segment of old routine 
 cli ; disable interrupts 
 mov word [es:9*4], kbisr ; store offset at n*4 
 mov [es:9*4+2], cs ; store segment at n*4+2 
 sti ; enable interrupts 
.l1: mov ah, 0 ; service 0 – get keystroke 
 int 0x16 ; call BIOS keyboard service 
 cmp al, 27 ; is the Esc key pressed 
 jne .l1 ; if no, check for next key 
 mov ax, [oldisr] ; read old offset in ax 
 mov bx, [oldisr+2] ; read old segment in bx 
 cli ; disable interrupts 
 mov [es:9*4], ax ; restore old offset from ax 
 mov [es:9*4+2], bx ; restore old segment from bx 
 sti ; enable interrupts 
 mov ax, 0x4c00 ; terminate program 
 int 0x21 
	
label1: db 'Name', 0
label2: db 'Speed (km/h)', 0
label3: db 'Time (min)', 0
label4: db 'Position', 0

name1: db 'Aaron      ', 0
name2: db 'Tee Morgan ', 0
name3: db 'Chris Green', 0
name4: db 'Rock Lee   ', 0
name5: db 'Brick Win  ', 0
mess:db 'Enter "s" to start',0
speed: dw 12, 15, 10, 14, 16
speed_cpy: dw 0, 0, 0, 0, 0
time: dw 0, 0, 0, 0, 0
position: dw 8, 8, 8, 8, 8
distance: dw 900
oldisr: dd 0