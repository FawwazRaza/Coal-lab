;proj5
; implementing 3rd phase
;proj6 ; making the rabbit stick to the bottom brick
;proj7 moving lower brick down and out of screen
;proj8 adding new platform, reducing size of rabbit and platforms
;proj10, proj8+ random color, carrot, blue brick
;proj11 adding score
;proj12 awais menu
;proj13 adding music
;proj14 some fixes, welcome screen, text, menu etc

[org 0x0100]

MOV AX,0013H
INT 10H 
 
; ;320px wide, 200px tall, 1 byte per pixel. 
; mov ax, 79 ; color palette 
; MOV BX,0A000H ;
; MOV ES,BX ; ES set to start of VGAx
; MOV BX,32000 ; BX set to pixel offset 0
; MOV CX, 6400

 
 
  ; mov dl, 'Y'
; mov ah, 6h
; int 21h

 jmp start
 


 
 
mov dx, start ; end of resident portion
add dx, 15 ; round up to next para
mov cl, 4
shr dx, cl ; number of paras

call clrscr


mov ax, 0x3100 ; terminate and stay resident
int 0x21

 
 
 
 next_note:
pusha
 

	
	mov si, [music_index]
	mov bx, [music_delay]
	dec word [music_delay]
	dec BX
	
	jg music_exit
	
	
		; 3) the first byte is the opl2 register
		;    that is selected through port 388h
		mov dx, 388h
		mov al, [si + music_data + 0]
		out dx, al
		
		; 4) the second byte is the data need to
		;    be sent through the port 389h
		mov dx, 389h
		mov al, [si + music_data + 1]
		out dx, al
		
		; 5) the last 2 bytes form a word
		;    and indicate the number of waits (delay)
		mov bx, [si + music_data + 2]
		
		; 6) then we can move to next 4 bytes
		add si, 4
		mov [music_index], si
		
		; 7) now let's implement the delay
		
		shr bx, 3
		;sub ax, 50
		;mov bx, 5
		;mul bx
		mov [music_delay], bx
		
	; repeat_delay:	
		; mov cx, 2000 ; <- change this value according to the speed
		              ; ;    of your computer / emulator
	; delay1:
	
		
		; loop delay1
		
		; dec bx
		; jg repeat_delay
		
		; 8) let's send all content of music_data
		 cmp si, [music_length]
		 jne music_exit
		  mov ax, 0
			mov [music_index], ax
			jmp music_exit
 
 music_exit:
 
 popa
 ret
 

  
clrscr:

	push es
	push bx
	push cx

	mov bx, 0xA000
	mov es, bx
	xor bx, bx

	mov cx, 0xFA00
clr:
	mov word[es:bx], 0
	inc bx
	loop clr

	pop cx
	pop bx
	pop es
ret

print_welcome_messege:
	push ax
	push bx
	push es
	
	call welcome
	push 0x2D
	push 0xC6C0
	call delayforwelcome
	; push 0
	; push 20
	; push 0x40 ; color 
	; push press_key 
	; call printStr   ; press any key to countinue 
	
	; mov ah, 0 ; service 0 – get keystroke 
	; int 0x16

	pop es
	pop bx
	pop ax
	
  ret
 
 delayforwelcome:
	push bp
	mov bp, sp

	push ax
	push cx
	push dx

	mov cx, [bp+6]
	mov dx, [bp+4]

	mov ah, 86h
	int 15h

	pop dx
	pop cx
	pop ax

	pop bp
ret 4
welcome:
	call clrscr
	call print_menu_screen
	; first cloud 
	push 35
	push 10
	push cloud
	call makeImg
	; scnd cloud 
	push 200
	push 0
	push cloud
	call makeImg
	
	push 100
	push 20
	push cloud
	call makeImg
	
	push 120
	push 160
	push cloud
	call makeImg
	
	push 0
	push 150
	push cloud
	call makeImg
	
	
	push 250
	push 120
	push cloud
	call makeImg
	
	
	push 12 ; col
	push 6  ;row
	push 0x40 ; color 
	push welcomeStr1
	call printStr

	push 13
	push 9
	push 0x40  ; color 
	push welcomeStr2
	call printStr

	; push 18
	; push 10
	; push 0x40  ; color 
	; push welcomeStr3
	; call printStr

	push 9
	push 12
	push 0x40  ; color 
	push welcomeStr4
	call printStr
	
	push 8
	push 15
	push 0x40  ; color 
	push welcomeStr5
	call printStr
	
ret

makeImg:
	push bp
	mov bp, sp

	pusha

	mov di, [bp+8]
	mov cx, [bp+6]

	mov si, [bp+4]	;pointer to start of image data

	xor dh, dh
	xor bh, bh
rowloop:
	mov ax, di
colloop:
	cmp byte[si], -1
	je break

	mov dl,[si]		;color
	mov bl, [si+1]	;length

	add si, 2

	cmp dl, -2
	je transparent

	; cmp cx, MAX_Y
	; ja transparent
	; cmp cx, MIN_Y
	; jl transparent

	push ax
	push cx
	push 0
	push bx
	push dx
	call makeHLine

transparent:

	add ax, bx
	jmp colloop
break:

	inc si
	inc cx
	cmp byte[si], -1
	jne rowloop

	popa

	pop bp
ret 6

;void makeHLine(int x, int y, int point_type, int width, int color)	//point_type:	0:from left to right, 1:from right to left
makeHLine:
	push bp
	mov bp, sp

	pusha

	mov ax, [bp+12]	;x-coordinate
	mov bx, [bp+10]	;y-coordinate
	mov cx, [bp+6]	;width
	mov dx, [bp+4]	;color

	cmp cx, 0
	je skip4

	cmp word[bp+8], 1
	je HlineType2

HlineType1:
	push ax	;x-coordinate
	push bx	;y-coordinate
	push dx	;color
	call makeDot

	inc ax
loop HlineType1
	jmp skip4

HlineType2:
	push ax	;x-coordinate
	push bx	;y-coordinate
	push dx	;color
	call makeDot

	dec ax
loop HlineType2

skip4:
	popa

	pop bp
ret 10

;void makeDot(int x, int y, int color)
makeDot:
	push bp
	mov bp, sp

	push ax
	push cx
	push dx

	mov al, [bp+4]	;loading color
	mov cx, [bp+8]	;setting x-coordinate
	mov dx, [bp+6]	;setting y-coordinate

	mov ah, 0Ch
	int 10h

	pop dx
	pop cx
	pop ax

	pop bp
	
	ret 6
make_Sky_cloud:
	push ax
	push bx
	push cx
	push dx

	push 35
	push 0
	push cloud
	call makeImg

	push 180
	push 10
	push cloud
	call makeImg
	
	push 290
	push 4
	push cloud
	call makeImg

	pop dx
	pop cx
	pop bx
	pop ax
ret
print_menu_screen:
	push es
	push bx
	push cx

	mov bx, 0xA000
	mov es, bx
	xor bx, bx

	mov cx, 0xFA00
clr_for_menu:
	mov word[es:bx], 67
	inc bx
	loop clr_for_menu

	pop cx
	pop bx
	pop es
ret

movscrn2:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 
 
 call PRINT_THIRD
 
 
 
mov ax,[platform3index]
cmp ax, [platform3rightbound]
jae platform3left
cmp ax, [platform3leftbound]
jbe platform3right

platform3here:
mov ax, [platform3directionflag] 
cmp ax, 0
je moveplatform3left
jmp moveplatform3right

printplatform3:

mov bx, [jumpflag]
cmp bx, 0
jne MOVE_PLATFORM3
mov ax, [platform3index]
jmp DONT_MOVE_PLATFORM3

PLATFORM3_COMPLETE:

jmp DONT_MOVE_PLATFORM3


MOVE_PLATFORM3:
mov ax, [platform3index]
cmp ax, [platformoriginalindex]
je PLATFORM3_COMPLETE
add ax, 1600
mov [platform3index], AX
mov ax, [platform3rightbound]
add ax, 1600
mov [platform3rightbound], ax
mov ax, [platform3leftbound]
add ax, 1600
mov [platform3leftbound], ax
jmp DONT_MOVE_PLATFORM3

DONT_MOVE_PLATFORM3:
mov ax, [platform3color]
push ax
mov ax,[platform3index]
push AX
call DRAW_PLATFORM


 ;for lower platform --- platform1
 mov ax, [platformindex]
 mov bx, [platformrightbound]
 cmp ax, bx
jae platformleft
mov bx, [platformleftbound]
 cmp ax, bx
jbe platformright

platformhere:
mov ax, [platformdirectionflag]
cmp ax, 0
je moveplatformleft
jmp moveplatformright
printplatform:

 mov bx, [jumpflag]
 cmp bx, 0
 jne MOVE_LOWER_PLATFORM ; 1 means jump
mov ax, [platformindex]
jmp DONT_MOVE_PLATFORM


MOVE_LOWER_PLATFORM:
mov bx, [lowerflag]
cmp bx, 1
je DONT_MOVE_PLATFORM ; if lower part animation is complete, jump
mov dx, [lowerprogress]
cmp dx, 1
je LOWER_COMPLETE
mov bx, [platformindex]
add bx, 1600
mov [platformindex], bx
mov bx, [platformrightbound]
add bx, 1600
mov [platformrightbound], bx
mov bx, [platformleftbound]
add bx, 1600
mov [platformleftbound], bx
inc dx
mov [lowerprogress], dx
mov ax, [platformindex]
jmp DONT_MOVE_PLATFORM







MOVE_PLATFORM: ; for jump effect for uppper platform platform 2
 mov dx, [jumpprogress]
 cmp dx, 5
; mov ax, [platform2index]
; cmp ax, [platform3originalindex]
je JUMP_COMPLETE
mov bx, [platform2index]
add bx, 1600
mov [platform2index], bx
mov bx, [platform2rightbound]
add bx, 1600
mov [platform2rightbound], bx
mov bx, [platform2leftbound]
add bx, 1600
mov [platform2leftbound], bx
inc dx
mov [jumpprogress], dx
jmp DONT_MOVE_PLATFORM2


LOWER_COMPLETE:
mov dx, 0
mov [lowerprogress], dx
mov byte [lowerflag],0
mov bx, 61300
mov [platformrightbound], BX
mov bx, 61180
mov [platformleftbound], bx


jmp DONT_MOVE_PLATFORM




JUMP_COMPLETE:
call CHECK_LANDING
mov word[bluetime], 0
mov word[prevbluetime], 0
mov dx, 0
mov [jumpprogress], dx
mov [jumpflag], dx
mov bx,[platform3index]
add bx, 1280 
mov [platformindex], bx
mov [platform3index], bx
mov bx, 50300
mov [platform3leftbound], BX
mov bx, 50420
mov [platform3rightbound], BX
mov bx, [platform2index]
;add bx,  320
mov [platform3index], BX
mov bx, 61300
mov [platformrightbound], bx
mov bx, 61180
mov [platformleftbound], bx
;random function here for random index of new platform on top, platform2
call getrandomindex ; getrandom index puts a random index for platform2 in prn
;mov dx, 42360
mov dx, [randomindex]
mov [platform2index], dx


mov bx, 42420
mov [platform2rightbound], bx
mov bx, 42300
mov [platform2leftbound], BX

mov bx, [platform3color]
mov [platformcolor], bx
cmp bx, 11 ;blue color
jz blueplatform
jnz notblue
blueplatform:
mov word[blueplatformflag], 1 ; landed on a blue platform
notblue:
mov word [blueplatformflag], 0
mov bx, [platform2color]
mov [platform3color], bx
call getrandomcolor
mov bx, [randomcolor]
mov [platform2color], bx
mov bx, [platform3directionflag]
mov [platformdirectionflag], bx
mov [rabbitdirectionflag], bx
mov bx, [platform2directionflag]
mov [platform3directionflag], BX
add bx, 0
jz makeitone
mov bx, 0
mov [platform2directionflag], bx




jmp DONT_MOVE_PLATFORM2

makeitone:
mov bx, 1
mov [platform2directionflag], bx
jmp DONT_MOVE_PLATFORM2




DONT_MOVE_PLATFORM:
mov ax, [platformcolor]
push ax
mov ax, [platformindex]
push ax
call DRAW_PLATFORM
 
 
 

; for upper platform-- platform2

mov ax, [platform2index]
mov bx, [platform2rightbound]
cmp ax, bx
jae platform2left
mov bx, [platform2leftbound]
cmp ax, bx
jbe platform2right
platform2here:
mov ax, [platform2directionflag]
cmp ax, 0
je moveplatform2left
jmp moveplatform2right
printplatform2:

 mov bx, [jumpflag]
 cmp bx, 0
 jne MOVE_PLATFORM
 
 
 
 DONT_MOVE_PLATFORM2:
mov ax, [platform2color]
push ax
mov ax, [platform2index]
push ax
call DRAW_PLATFORM
 
 
 
 
 
 
 
 ;for rabbit
 
 
 mov ax, [jumpflag]
 cmp ax, 0
 jne printrabbit
mov ax, [platformindex]
mov bx, [platformrightbound]
cmp ax, bx
;cmp ax, 49460
je rabbitleft
;cmp ax, 49380
mov bx, [platformleftbound]
cmp ax, BX
je rabbitright
rabbithere:
mov ax, [rabbitdirectionflag]
cmp ax, 0
je moverabbitleft
jmp moverabbitright
printrabbit:

 call DRAW_RABBIT
 call DRAW_CARROT
 call CHECK_EAT
 call CHECK_BLUE_PLATFORM
 
 
 
 
 
 pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 updatescore: ; updates the variable PLAYER_SCORE
 
 PUSH AX
 
 INC BYTE [score]
 cmp byte[score], 10
 je FIRST_DIGIT
  cmp byte[score], 20
 je FIRST_DIGIT
 jmp SECOND_DIGIT
 
 FIRST_DIGIT:
 inc byte[PLAYER_SCORE1]
 mov byte[PLAYER_SCORE2], '0'
 
 SECOND_DIGIT:
 inc byte[PLAYER_SCORE2]
 
 


 POP AX
 ret
 
 
 
 
 printscore:
 push AX
 push BX
 push dx
 
 
		MOV AH,02h                       ;set cursor position
		MOV BH,00h                       ;set page number
		MOV DH, 13                      ;set row 
		MOV DL, 38						 ;set column
		INT 10h							 
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX, PLAYER_SCORE1   ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h       		;print the string
		
		MOV AH,02h                       ;set cursor position
		MOV BH,00h                       ;set page number
		MOV DH, 13                      ;set row 
		MOV DL, 39						 ;set column
		INT 10h							 
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX, PLAYER_SCORE2  ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h       		;print the string
		
		

pop dx
pop BX
pop AX


ret 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 CHECK_BLUE_PLATFORM:
 push AX
 push BX
 
 
 mov ax, [cs:bluetime]
 mov bx, [cs:prevbluetime]
 sub ax, BX
 cmp ax, 72
 jae timepassed
 jmp timenotpassed
 
 timepassed:
 mov word [game_over_flag], 1
 

 
 timenotpassed:
 
 pop BX
 pop AX
 ret
 
 
 
 
timer:

push ax

mov ax, [cs:platformcolor]
cmp ax, 11
je platformisblue
jmp platformisnotblue
platformisblue:
inc word [cs:bluetime]; increment tick count
call CHECK_BLUE_PLATFORM ; print tick count
jmp blueplatformhere

platformisnotblue:
mov word[cs:bluetime], 0
mov word [cs:prevbluetime], 0
blueplatformhere:
mov al, 0x20
out 0x20, al ; end of interrupt

pop AX
jmp far [cs:oldisr]




 
 
 CHECK_EAT:
 push AX
 push BX
 
 mov ax, [rabbitindex]
 mov bx, [carrotindex]
 cmp bx, ax
 jb notdoneeat
 add ax, 15
 cmp bx, AX
 ja notdoneeat
 
 
 
 doneeat:
 mov word[carrotflag], 0
 
 notdoneeat:
 
 pop BX
 pop AX
 
 
 
 
 DRAW_CARROT:
 ;getting a random value from 0-50 if the value is 5 then we print carrot
  push AX
 push dx
 push cx
 push di
 
 
 mov ax, [carrotflag]
 cmp ax, 1
 je printcarrot
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 100
div     cx        ; here dx contains the remainder - from 0 to 9
 
 cmp dx, 3
 jne dontprintcarrot
 mov word[carrotflag], 1
  call getrandomcarrot

 
 
 
 printcarrot:

 mov di, [carrotindex]
 mov al, 4
 mov cx, 5
rep stosb
add di, 316
mov cx, 3
rep stosb
add di, 318
mov cx, 1
rep stosb 

 
 
 
 ;call    CalcNew 
 
 dontprintcarrot:

pop di
pop cx
pop dx
pop AX

ret



 getrandomcarrot:
 push AX
 push dx
 push cx
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 70
div     cx        ; here dx contains the remainder - from 0 to 9
add dx, 53440+140
;add     dl, '0'   ; to ascii from '0' to '9'
; mov     ah, 02h   ; call interrupt to display a value in DL
; int     21h    
mov [carrotindex], dx
call    CalcNew   ; -> AX is another random number

pop cx
pop dx
pop AX

ret
 
 
 
 
 
getrandomindex:
push AX
push dx
push cx
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 120
div     cx        ; here dx contains the remainder - from 0 to 9
add dx, 42300
;add     dl, '0'   ; to ascii from '0' to '9'
; mov     ah, 02h   ; call interrupt to display a value in DL
; int     21h    
mov [randomindex], dx
call    CalcNew   ; -> AX is another random number

pop cx
pop dx
pop AX

ret

; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number
CalcNew:
    mov     ax, 25173          ; LCG Multiplier
    mul     word  [PRN]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [PRN], ax          ; Update seed = return value
    ret
	
	
	
	 getrandomcolor:
 push AX
 push dx
 push cx
 
 MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew1   ; -> AX is a random number
xor     dx, dx
mov     cx, 4
div     cx        ; here dx contains the remainder - from 0 to 9
  
cmp dx, 0
je color1
cmp dx, 1
je color2
cmp dx, 2
je color3
cmp dx, 3
je color4

randomclrback:
call    CalcNew1   ; -> AX is another random number

pop cx
pop dx
pop AX

ret
color1:
mov ax, 14
mov [randomcolor], ax
jmp randomclrback
color2:
mov ax, 12
mov [randomcolor], ax
jmp randomclrback
color3:
mov ax, 13
mov [randomcolor], ax
jmp randomclrback
color4:
mov ax, 11
mov [randomcolor], ax
jmp randomclrback


; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number
CalcNew1:

    mov     ax, 25173          ; LCG Multiplier
    mul     word  [PRN]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [PRN], ax          ; Update seed = return value
    ret
	
	
	
	
	
	
 
 CHECK_LANDING:
 
push bp
mov bp, sp
push AX
push BX
push DI

mov ax, 0A000H
mov es, ax
cld

mov bx, [rabbitindex]
add bx, 6400 ;  takes to foot of rabbit






mov ax, [platform3index]
sub ax, 10
cmp bx, ax
jb game_over_menu
mov ax, [platform3index]
add ax, [platformlength]
cmp bx, ax
ja game_over_menu


mov ax, [platformspeed]
inc AX
mov [platformspeed], ax
jmp CHECK_LANDING_return




CHECK_LANDING_return:

CALL updatescore


pop DI
pop BX
pop AX
pop bp
ret

print_text_box:

push bp
mov bp, sp
push AX
push ES
push di
push CX


mov ax, 0A000h
mov es, ax



mov di, 16705

mov ax, 43

mov cx, 80
box_loop:
push cx
mov cx, 180
rep stosb
add di, 320
sub di, 180

pop cx
loop box_loop

mov di, 18955
mov ax, 14

mov cx, 65
boundary_loop1:
push cx
mov cx, 160
rep stosb
add di, 320
sub di, 160

pop cx
loop boundary_loop1


pop CX
pop di
pop ES
pop AX
pop bp

ret


print_game_end:

push 15; col
push 8 ; row
push 10 ; color 
push gameover_msg
call printStr

push 15; col
push 10 ; row
push 43 ; color 
push restart_msg
call printStr


push 16; col
push 12; row
push 44 ; color 
push quit_msg
call printStr

; restart_msg: db '[R]estart', 0
; quit_msg: db 'Quit', 0
; resume_msg: db '[R]esume', 0



ret

reset_variables:
push ax

mov ax, 61120+120
mov [platformindex], AX
mov ax, 42360
mov [platform2index], AX
mov ax, 50360
mov [platform3index], ax
mov ax, 53440+140
mov [rabbitindex], AX
mov ax, 0
mov [game_over_flag], ax
mov [jumpflag], AX
mov [rabbitdirectionflag], AX
mov [platform2directionflag], ax
mov [platformdirectionflag], AX
mov ax, 1
mov [platform3directionflag], AX
mov [platformspeed], ax

mov ax, 0

mov [randomcolor], AX
mov [jumpprogress], AX
mov [lowerflag], AX
mov [lowerprogress], ax
mov [carrotindex], AX
mov [carrotflag], AX
mov [blueplatformflag], AX
mov [prevbluetime], ax
mov [bluetime], AX
mov [PRN], AX
mov [randomindex], AX
mov [score], ah
mov ah, '0'
mov [PLAYER_SCORE1], ah
mov [PLAYER_SCORE2], ah


pop ax
ret

stop_music:
push bp
mov bp, sp

push dx
push AX
push si

in al, 61h
and al, 11111100b
out 61h, al

; mov dx, 388h
		; mov al, 0
		; out dx, al
		
		; ; 4) the second byte is the data need to
		; ;    be sent through the port 389h
		; mov dx, 389h
		; mov al, 0
		; out dx, al


pop si
pop AX
pop dx
pop bp
ret

print_escape_message:

push 14; col
push 8 ; row
push 10 ; color 
push game_paused_msg
call printStr

push 15; col
push 10 ; row
push 43 ; color 
push restart_msg
call printStr


push 16; col
push 12; row
push 44 ; color 
push resume_msg
call printStr

push 17; col
push 14; row
push 46 ; color 
push quit_msg
call printStr

ret




escape_menu:


call print_text_box
call print_escape_message

escape_loop:
mov ah, 00h
int 16h

 CMP AL, 71h ; q ascii in hex, quit game
 Je exit
 
 cmp al, 65h ; e ascii, Resume Game
 je game_start
 
 CMP Al, 72h ; restart game, ascii of r
 JE restart_game
 
 jmp escape_loop


escape_exit:

ret

restart_game:
call reset_variables
jmp game_start



game_over_menu:


call reset_variables
call print_text_box
call print_game_end

l9:


mov ah, 00h
 int 16h
 
 CMP AL, 71h ; q ascii in hex
 je exit

 

 
 
 

 CMP Al, 72h
 JE restart_game
 
 jmp l9
 

 
ret


 
 
 movscrn:
 
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 push ds
 
 
 mov ax, 0A000H
 mov es, AX
 mov ds, ax
 
 
 ;2nd part move left

 mov cx, 5
 cld
 mov si, 17921
 mov di, 17920
 
 infloop1:
 push cx
 
 mov cx, 319
 mov al, [es:di]

rep movsb

mov [es:di], Al
inc SI
inc di

pop cx

loop infloop1

 mov cx, 3
 cld
 mov si, 28481
 mov di, 28480
 
 infloop2:
 push cx
 
 mov cx, 319
 mov al, [es:di]

rep movsb

mov [es:di], Al
inc SI
inc di

pop cx

loop infloop2


 mov cx, 5
 cld
 mov si, 38721
 mov di, 38720
 
 infloop3:
 push cx
 
 mov cx, 319
 mov al, [es:di]

rep movsb

mov [es:di], Al
inc SI
inc di

pop cx

loop infloop3



;first part move screen right
mov si, 318
mov di, 319
std
mov al, 4



mov cx, 56
movouterloop:
push cx

mov al, [es:di]

mov cx, 319


rep movsb


mov [es:di], al
add si, 639
add di, 639

pop cx
loop movouterloop




 ; CALL DRAW_RABBIT
cld
 pop ds
 pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 

 ;jump function - this function checks if key is pressed and if its up key, if yes then it scrolls up 
 JUMP_BUNNY:
 
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 push ds
 
 mov ah, 01h
 int 16h
 jz EXIT_JUMP_BUNNY
 
 mov ah, 00h
 int 16h
 
 CMP al, 1Bh
 je escape_menu
 
 CMP AL, 77h
 JNE EXIT_JUMP_BUNNY
 
 
 
 W_PRESSED: ; w key is pressed
 ;jmp exit
 mov ax, 1
 mov [jumpflag], AX
 

 
 EXIT_JUMP_BUNNY:
 pop ds
 pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 
 
 

 
 
 
 
 delay:
 
 push bp
 push CX
 push AX
 
 mov cx, 1000
 
 delayloop:
  mov ax, 1
  loop delayloop
 
 pop AX
 pop CX
 pop bp
 ret
 
 
 
 
 printscrn:
 
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
MOV AX,0013H
INT 10H 
 
 
  
 
  call sky
 
 mov ax, 24;17 ;color bp+8
 push AX
 mov ax, 0 ; base offset - bp+6
 push AX
 mov ax, 40 ; size in pixel - bp+4
 push ax
 
 call mountain
 
 mov ax, 27 ;color bp+8
 push AX
 mov ax, 50; base offset - bp+6
 push AX
 mov ax, 50 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 24;color bp+8
 push AX
 mov ax, 100; base offset - bp+6
 push AX
 mov ax, 45 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 27 ;color bp+8
 push AX
 mov ax, 150; base offset - bp+6
 push AX
 mov ax, 30 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 24 ;color bp+8
 push AX
 mov ax, 200; base offset - bp+6
 push AX
 mov ax, 42 ; size in pixel - bp+4
 push ax
 call mountain
 
  mov ax, 27 ;color bp+8
 push AX
 mov ax, 250; base offset - bp+6
 push AX
 mov ax, 35 ; size in pixel - bp+4
 push ax
 call mountain
 
 
 
 call road
 
 mov ax, 40
 push AX
 mov ax, 22080
 push ax
 CALL printcar
 
 mov ax, 200
 push AX
 mov ax, 30120
 push ax
 CALL printcar
 
 ;CALL PRINT_THIRD
 
; mov ax, [rabbitindex]
; cmp ax, 49520
; je rabbitleft
; cmp ax, 49220
; je rabbitright
; mov ax, [rabbitdirectionflag]
; cmp ax, 0
; je moverabbitright
; jmp moverabbitleft
; printrabbit:

 ; call DRAW_RABBIT
 
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 rabbitleft:
 mov ax, 0
 mov [rabbitdirectionflag], AX
 jmp rabbithere
 
 rabbitright:
 mov ax, 1
 mov [rabbitdirectionflag], AX
 jmp rabbithere
 
 moverabbitleft:
 mov ax, [rabbitindex]
 mov bx, [platformspeed]
 sub ax, bx
 mov [rabbitindex], AX
 jmp printrabbit
 
  moverabbitright:
 mov ax, [rabbitindex]
  mov bx, [platformspeed]
 add ax, bx
 
 mov [rabbitindex], AX
 jmp printrabbit
 
 platformleft:
 mov ax, 0
 mov [platformdirectionflag], AX
 mov [rabbitdirectionflag], AX
 jmp platformhere
 
 platformright:
 mov ax, 1
 mov [platformdirectionflag], AX
 mov [rabbitdirectionflag], AX
 jmp platformhere
 
 moveplatformleft:
 mov ax, [platformindex]
 mov bx, [platformspeed]
 sub ax, bx
 mov [platformindex], AX
 jmp printplatform
 
  moveplatformright:
 mov ax, [platformindex]
 mov bx, [platformspeed]
 add ax, bx
 ;inc ax
 mov [platformindex], AX
 jmp printplatform
 
 
 
  platform2left:
 mov ax, 0
 mov [platform2directionflag], AX
 jmp platform2here
 
 platform2right:
 mov ax, 1
 mov [platform2directionflag], AX
 jmp platform2here
 
 moveplatform2left:
 mov ax, [platform2index]
 mov bx, [platformspeed]
 sub ax, bx
 mov [platform2index], AX
 jmp printplatform2
 
  moveplatform2right:
 mov ax, [platform2index]
 mov bx, [platformspeed]
 add ax, bx
 mov [platform2index], AX
 jmp printplatform2
 
 platform3left:
 
 mov ax, 0
 mov [platform3directionflag], AX
 jmp platform3here
 
 platform3right:
  mov ax,1
 mov [platform3directionflag], AX
 jmp platform3here
 
  moveplatform3left:
 mov ax, [platform3index]
 mov bx, [platformspeed]
 sub ax, bx
 mov [platform3index], AX
 jmp printplatform3
 
  moveplatform3right:
 mov ax, [platform3index]
 mov bx, [platformspeed]
 add ax, bx
 mov [platform3index], AX
 jmp printplatform3

 ;end of printscreen function
 
 PRINT_THIRD:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 

mov ax, 0A000H
 mov es, AX
 MOV DI, [startofthird]
MOV CX, 78
 MOV AX, 102
 
 THIRDLOOP:
 PUSH CX
 
 MOV CX, 320

 REP STOSB
 
 POP CX
 LOOP THIRDLOOP
 

 pop dx
  pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 
 
 DRAW_PLATFORM:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 



 mov di, [bp+4]
 MOV AX, [bp+6]
 MOV CX, [platformthickness]
 
 PLATFORMLOOP:
 cmp di, 21120
 jbe DONT_PRINT_PLATFORM
 PUSH CX
 MOV CX, [platformlength]



 rep stosb
 ADD DI, 320
 SUB DI, [platformlength]
 POP CX

 LOOP PLATFORMLOOP
 
DONT_PRINT_PLATFORM:
 
  pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 4

 
 
 
 DRAW_RABBIT:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 mov di, [rabbitindex]

mov al ,13



mov cx, 5
push di
rabbit1:
push cx
mov cx, 3
rep stosb
add di, 320
sub di, 3
pop cx
loop rabbit1

pop di
add di, 11

mov cx, 5
rabbit2:
push cx
mov cx, 3
rep stosb
add di, 320
sub di, 3
pop cx
loop rabbit2

;mov di, 2560
;add di, [rabbitindex]
sub di, 10
sub di, 3
mov cx, 7
mov al, 7
rabbit3:
push cx
mov cx, 18
rep stosb
add di, 320
sub di, 18
pop cx
loop rabbit3

mov al, 23
;mov di, 5120
;add di, [rabbitindex]
sub di, 3
mov cx, 13

rabbit4:
push cx
mov cx, 23
rep stosb
add di, 320
sub di, 23
pop cx
loop rabbit4

MOV AL, 28
;MOV DI, 10880
;ADD DI, [rabbitindex]
sub di, 320
add di, 4
push di

MOV CX, 2
RABBIT5:
PUSH CX
MOV CX, 5 
REP STOSB
ADD DI, 320
SUB DI, 5
POP CX
LOOP RABBIT5

pop DI
add di, 10
MOV CX, 2 
RABBIT6:
PUSH CX
MOV CX, 5
REP STOSB
ADD DI, 320
SUB DI, 5
POP CX
LOOP RABBIT6

  pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 

 
 
 
 
 mountain: ;takes 3 parametes. 1. color, 2. starting offset of mountain base, 3. height of mountain in pixels
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 mov cx, [bp+4]
 mov bx, [baseoffirst]
 add bx, [bp+6]
  mov [num1], bx
 mov dx, 0
 mov ax, CX
 shl ax, 1
 mov [num2], AX
 mov ax, [bp+8];color
 
 loop1:
 
 cmp bx, [num3]
 jae loop2
 MOV [ES:BX],AX
 inc dx
 add bx, 1

 cmp dx, [num2]
 je loop2
 jmp loop1
 
 loop2:
 sub word [num2] , 2
 mov dx, 0
 mov bx, [num1]
 sub bx, 320
 inc BX
 mov [num1], BX
 sub cx, 1
 jnz loop1
 
 
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 6
 ;end of mountain function
 
 
 
 
 
 
 sky:
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
mov ax, [skycolor] ; color palette 
MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA
MOV BX, 0 ; BX set to pixel offset 0
MOV CX, [baseoffirst]

 ClrLoop: ; Repeat
 MOV [ES:BX],AX ; Memory[ES:BX] := Color
 INC BX ; BX := BX + 1
LOOP ClrLoop ; CX := CX – 1
 ; Until CX = 0 
 
 
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 
  ret
  ;end of sky function
  
  
  
  
  
  road:
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 

MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA
MOV BX, [startofsecond] ; BX set to pixel offset 0
MOV CX, [baseoffirst]

 ;printing upper curb
 call printcurb

; printing road
 MOV CX, [roadwidth]
 mov ax, [roadcolor]
 roadloop:
MOV [ES:BX], AX
INC BX
loop roadloop
;endof roadloop

call printcurb


 mov ax, 0
 push AX
 call printstripes
  mov ax, 64
 push AX
 call printstripes
  mov ax, 128
 push AX
 call printstripes
  mov ax, 192
 push AX
 call printstripes
   mov ax, 256
 push AX
 call printstripes



pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 
  ret
  
   ; MOV CX, [roadwidth]
 ; mov ax, 2
 ; roadloop:
; MOV [ES:BX], AX
; INC BX
; loop roadloop

jmp exit
  ;end of road function
  
 
  printcurb:
  push bp
 mov bp, sp
 push AX
 push CX
 

 
 
 mov dx, [curbwidth]
 maincurbloop: ; outer loop 
  
 MOV CX, [curbcolorlength]
 mov ax, [curbcolorone]
 firstcolorcurbloop:;inner first loop for first color
 MOV [ES:BX], AX
 INC BX
 LOOP firstcolorcurbloop
  MOV CX, [curbcolorlength]
  mov ax, [curbcolortwo]
 secondcolorcurbloop: ;inner second loop for second color
 MOV [ES:BX], AX
 INC BX
 LOOP secondcolorcurbloop
 
 dec DX
 jnz maincurbloop ;end of outer loop
 


  pop CX
 pop AX
 pop bp
 
 ret
 ;end of printcurb function
 
 printstripes:
 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 
 
 ;to print road lanes
mov bx, [startofsecond]
add bx, 10560 ;;middle of road
add bx, [bp+4]
mov ax, 15 ; white color
mov cx, [stripewidth]
mov dx, [stripelength]

stripeouterloop: ;will run width of stipe times

stripeinnerloop: ; will run length of stripe times

mov [es:bx], ax
inc bx
sub dx,1
jnz stripeinnerloop

add bx, 320
sub bx, [stripelength]
mov dx, [stripelength]
loop stripeouterloop


 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 2
 ;end of printstripes function------------
 
 
 
 printcar:
  push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push ES
 push dx
 
 


MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA

mov bx, [bp+4] ; to give 22080 as a paremeter
;mov bx, 22080
;add bx, [carlocation]
mov ax, [bp+6]
add bx, ax; to give carlocation as a paremeter
mov si, bx

mov ax, [carwindowcolor]
mov bx, [carwindowwidth]
mov dx, 0
mov cx, 0

carwindowloop:


carwindowloopinner:
mov [es:si], AX
inc si
inc dx
cmp bx, dx
jne carwindowloopinner
inc cx
add bx, 2

sub si, dx
add si, 320
sub si, 1
mov dx, 0
cmp cx, [carwindowheight]
jne carwindowloop


carbody:
mov ax, [carwindowwidth]
shr ax, 1
sub si, AX


mov cx, [carbodyheight]
mov dx, [carbodywidth]
mov ax, [carbodycolor]


carbodyloop:

carbodyloopinner:
mov [es:si], AX
inc si
dec dx
jnz carbodyloopinner

mov dx, [carbodywidth]
sub si, [carbodywidth]
add si, 320
loop carbodyloop




mov ax, 7
push AX
call cartyres
mov ax, 45
push AX
call cartyres


pop dx
pop ES
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 4
 
 ;end of printcar function-------------


cartyres:

 push bp
 mov bp, sp
 push AX
 push BX
 push CX
 push SI
 push dx
 
 

mov ax, [cartyrecolor]
mov bx, [tyrewidth]
mov dx, 0
mov cx, [tyreheight]
add si, [bp+4]

tyreloop:

tyreloopinner:
mov [es:si], AX
inc SI
inc dx
cmp dx, BX
jne tyreloopinner

inc cx
sub bx,2
jz here

sub si, dx
add si, 320
inc SI
mov dx, 0
dec cx
jnz tyreloop


here:

pop dx
 pop SI
 pop CX
 pop BX
 pop AX
 pop bp
 ret 2
 
 
 
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

setPal:
	pusha

	mov si, pal
	mov bx, 16
ll1:

	mov ax,1010h
	mov dh,[si]
	mov ch,[si+1]
	mov cl,[si+2]
	int 10h

	add si, 3
	inc bx

	cmp bx, 69
	jne ll1

	popa
ret
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

 num1: dw 0
 num2: dw 0
 num3: dw 32320
 
maxlength:    dw	80                 				; maximum length of input 
;10 is called as LF or Line Feed or new line and 13 is called as CR or Carriage return. These characters are used to control the cursor position. They are control characters
greetings:    db	10, 13, 'Welcome $'  	; greetings message
buffer:       times 81 db 0           				; space for input string 
EnterName:	  db	10, 13, 'Please enter your name: $'
Instructions: db	10, 13, 'Please choose one of the Instructions for Game: $'
Instruction1: db	10, 13, 'Instruction 1: dummy1 $'
Instruction2: db	10, 13, 'Instruction 2: dummy2 $'
Instruction3: db	10, 13, 'Instruction 3: Press Enter to Continue OR Esc to Exit $'
dummy1:		  db	10, 13, 'exiting from the Game $'
dummy2:		  db	10, 13, 'exiting from the Game $'
 skycolor: dw 11 ;79, 102, 11
 Color: db 0x07
 baseoffirst: dw 17920
 startofsecond: dw 17920
 curbwidth: dw 40
 curbcolorlength : dw 20
 roadwidth: dw 19200 ; 320* 60
 roadcolor: dw 22   ;from color palette 256
 stripelength: dw 30
 stripewidth: dw 2
 roadmiddle: dw 10560 ;+ 17920
 carlocation: dw 100
 carwindowwidth: dw 17
 carwindowheight: dw 7
carframecolor: dw 5
carwindowcolor: dw 3
carbodyheight: dw 9
carbodywidth: dw 57
carbodycolor: dw 12
cartyrecolor: dw 0
tyrewidth: dw 6
tyreheight: dw 25
curbcolorone: dw 15
curbcolortwo: dw 45
startofthird: dw 40320
platformx: dw 120
platformy: dw 59200
platformoriginalindex: dw 61120+120 
platformindex: dw 61120+120 
platformrightbound: dw 61300 ; 59360
platformleftbound: dw 61180  ;59280
platform2index: dw 42360
platform2rightbound: dw 42420; 44640
platform2leftbound: dw 42300 ; 44560
platform3index: dw 50360
platform3originalindex: dw 50360
platform3leftbound: dw 50300
platform3rightbound: dw 50420
platformthickness: dw 5
platformlength: dw 70
scoremessage: db 'Your Score: '
rabbitindex: dw 53440+140
jumpflag: dw 0
rabbitdirectionflag: dw 0
platformdirectionflag: dw 0
platform2directionflag: dw 0
platform3directionflag: dw 1
platformcolor: dw 46
platform2color: dw 69
platform3color: dw 84
randomcolor: dw 0
platformspeed: dw 1
prevtime: db 0
jumpprogress: dw 0
lowerprogress: dw 0
lowerflag: db 0
carrotindex: dw 0
carrotflag: dw 0
blueplatformflag: dw 0
prevbluetime: dw 0
bluetime: dw 0
PRN: dw 0
randomindex: dw 0
oldisr: dd 0
score: dB 0 
PLAYER_SCORE1 DB '0','$'
PLAYER_SCORE2 DB '0','$'
welcomeStr1:	db	'JUMPING RABBIT',0
welcomeStr2:	db	'Developed By',0
welcomeStr3:	db	'By',0
welcomeStr4:	db	'M.Awais--------Talha.A',0
welcomeStr5: db '22l-6966--------22l-0504', 0
gameover_msg    db  'Game Over!' , 0
game_paused_msg db 'Game Paused!', 0
press_key: db 'Press any key to continue' , 0
restart_msg: db '[R]estart', 0
quit_msg: db '[Q]uit', 0
resume_msg: db 'R[E]sume', 0
music_length dw 6456
music_data incbin "hitlwltz.imf"
music_index dw 0
music_time db 0
music_delay dw 1
blue_brick_time_passed: dw 0
game_over_flag: dw 0

cloud:
db	-2,	14,	0, 4,	-2,	12,	0, 4,	-1
db	-2,	13,	0,	1,	16,	4,	0,	1,	-2,	10,	0,	1,	16,	4,	0,	1,	-1
db	-2,	11,	0,	2,	16,	6,	0,	1,	-2,	7,	0,	2,	16,	6,	0,	1,	-1
db	-2,	10,	0,	1,	16,	8,	0,	1,	-2,	1,	0,	1,	-2,	4,	0,	1,	16,	8,	0,	1,	-2,	1,	0,	1,	-1
db	-2,	10,	0,	1,	16,	9,	0,	1,	16,	1,	0,	1,	-2,	3,	0,	1,	16,	9,	0,	1,	16,	1,	0,	1,	-1
db	-2,	10,	0,	1,	16,	6,	20,	1,	16,	5,	0,	1,	-2,	2,	0,	1,	16,	6,	20,	1,	16,	5,	0,	1,	-1
db	-2,	9,	0,	1,	16,	3,	20,	2,	16,	3,	20,	1,	16,	4,	0,	1,	-2,	1,	0,	1,	16,	3,	20,	2,	16,	3,	20,	1,	16,	4,	0,	1,	-1
db	-2,	8,	0,	1,	16,	3,	20,	1,	16,	10,	0,	1,	0,	1,	16,	3,	20,	1,	16,	10,	0,	1,	-1
db	-2,	5,	0,	3,	16,	32,	0,	1,	-2,	2,	0,	1,	-1
db	-2,	4,	0,	1,	16,	35,	0,	1,	-2,	1,	0,	1,	16,	1,	0,	1,	-1
db	-2,	3,	0,	1,	16,	37,	0,	1,	16,	2,	0,	1,	-1
db	-2,	3,	16,	41,	0,	1,	-2,	1,	0,	1,	-1
db	-2,	1,	0,	2,	16,	42,	0,	1,	16,	1,	0,	1,	-1
db	0,	1,	16,	46,	0,	1,	-1
db	0,	1,	16,	46,	0,	1,	-1
db	-2,	1,	0,	1,	16,	44,	0,	1,	-1
db	-2,	2,	0,	1,	16,	2,	20,	1,	16,	11,	20,	1,	16,	15,	20,	1,	16,	11,	0,	1,	-1
db	-2,	3,	0,	1,	16,	2,	20,	1,	16,	2,	20,	1,	16,	6,	20,	1,	16,	8,	20,	1,	16,	6,	20,	1,	16,	13,	0,	1,	-1
db	-2,	4,	0,	1,	16,	2,	20,	4,	16,	3,	20,	4,	16,	4,	20,	1,	16,	1,	20,	3,	16,	3,	20,	4,	16,	4,	20,	1,	16,	8,	0,	1,	-1
db	-2,	4,	0,	1,	16,	5,	20,	6,	16,	1,	20,	5,	16,	4,	20,	6,	16,	1,	20,	5,	16,	9,	-1
db	-2,	5,	0,	3,	16,	4,	20,	2,	16,	4,	20,	3,	16,	7,	20,	2,	16,	4,	20,	3,	16,	8,	0,	2,	-1
db	-2,	8,	0,	1,	16,	6,	0,	1,	16,	8,	0,	1,	16,	6,	0,	1,	16,	8,	0,	1,	16,	2,	0,	2,	-1
db	-2,	9,	0,	2,	16,	3,	0,	1,	-2,	1,	0,	2,	16,	4,	0,	2,	-2,	1,	0,	2,	16,	3,	0,	1,	-2,	1,	0,	2,	16,	4,	0,	2,	-2,	1,	0,	2,	-1
db	-2,	11,	0,	3,	-2,	4,	0,	4,	-2,	5,	0,	3,	-2,	4,	0,	4,	-1
db	-1
;NES Color Palette RGB
pal:
db 62, 62, 62 ;16 Gray
db 47, 47, 47 ;17 Gray
db 31, 31, 31 ;18 Dark Gray
db 41, 57, 63 ;19 Dark Blue
db 15, 47, 63 ;20 Deep Blue
db 0, 30, 62 ;21 Rich Blue
db 0, 0, 63 ;22 Pure Blue
db 46, 46, 62 ;23 Dark Purple
db 26, 34, 63 ;24 Medium Blue-Violet
db 0, 22, 62 ;25 Dark Blue
db 0, 0, 47 ;26 Deep Navy Blue
db 54, 46, 62 ;27 Muted Lavender
db 38, 30, 62 ;28 Muted Blue-Purple
db 26, 17, 63 ;29 Rich Violet
db 17, 10, 47 ;30 Dark Navy Blue
db 62, 46, 62 ;31 Muted Magenta
db 62, 30, 62 ;32 Medium Magenta
db 54, 0, 51 ;33 Dark Pink
db 37, 0, 33 ;34 Very Dark Maroon
db 62, 41, 48 ;35 Muted Red-Pink
db 62, 22, 38 ;36 Muted Maroon
db 57, 0, 22 ;37 Deep Red
db 42, 0, 8 ;38 Very Dark Red
db 60, 52, 44 ;39 Brownish
db 62, 30, 22 ;40 Dark Red-Brown
db 62, 14, 0 ;41 Bright Red
db 42, 4, 0 ;42 Very Dark Red
db 63, 56, 42 ;43 Beige or Tan
db 63, 40, 17 ;44 Orange-Brown
db 57, 23, 4 ;45 Medium Brown
db 34, 5, 0 ;46 Dark Brown
db 62, 54, 30 ;47 Mustard or Yellow-Brown
db 62, 46, 0 ;48 Dark Yellow or Gold
db 43, 31, 0 ;49 Brownish Yellow
db 20, 12, 0 ;50 Very Dark Yellow
db 54, 62, 30 ;51 Bright Greenish-Yellow
db 46, 62, 6 ;52 Lime Green
db 0, 46, 0 ;53 Bright Green
db 0, 30, 0 ;54 Dark Green
db 46, 62, 46 ;55 Light Green
db 22, 54, 21 ;56 Muted Green
db 0, 42, 0 ;57 Medium Green
db 0, 26, 0 ;58 Dark Green
db 46, 62, 54 ;59 Light Teal or Turquoise
db 22, 62, 38 ;60 Bright Teal
db 0, 42, 17 ;61 Teal Green
db 0, 22, 0 ;62 Dark Green
db 0, 63, 63 ;63 Cyan or Bright Turquoise
db 0, 58, 54 ;64 Seafoam Green
db 0, 34, 34 ;65 Dark Cyan
db 0, 16, 22 ;66 Dark Cyan
db 0, 42, 63;67 sky color 
db 30, 30, 30 ;68 Medium Gray or Silver

start:

xor ax, ax
mov es, ax ; point es to IVT base
mov ax, [es:8*4]
mov [oldisr], ax ; save offset of old routine
mov ax, [es:8*4+2]
mov [oldisr+2], ax ; save segment of old routine
cli ; disable interrupts
mov word [es:8*4], timer ; store offset at n*4
mov [es:8*4+2], cs ; store segment at n*4+2
sti ; enable interrupts

 ; xor ax, ax
; mov es, ax ; point es to IVT base
; cli ; disable interrupts
; mov word [es:8*4], timer; store offset at n*4
; mov [es:8*4+2], cs ; store segment at n*4+2
; sti
call setPal
call print_welcome_messege
			mov ah, 02h
			mov bh, 0
			mov dh, 16
			mov dl, 0
			int 10h
			
 			mov  dx, EnterName; User will be asked to enter his/her name               
			mov  ah, 9              ; service 9 – write string               
			int  0x21               ; dos services
			mov  cx, [maxlength]    ; load maximum length in cx              
			mov  si, buffer         ; point si to start of buffer 
 
nextchar:  	mov  ah, 1              ; service 1 – read character               
			int  0x21               ; dos services 
			cmp  al, 13             ; is enter pressed               
			je   nextScenerio       ; yes, leave input               
			mov  [si], al           ; no, save this character               
			inc  si                 ; increment buffer pointer               
			loop nextchar           ; repeat for next input char 
 
nextScenerio: mov byte [si], '$'     ; append $ to user input 
				
			mov ah, 02h
			mov bh, 0
			mov dh, 17
			mov dl, 0
			int 10h
			
              mov dx, greetings      ; greetings message               
			  mov ah, 9              ; service 9 – write string               
			  int 0x21               ; dos services 
 
              mov dx, buffer         ; user input buffer               
			  mov ah, 9              ; service 9 – write string               
			  int 0x21               ; dos services 
			  
	push 0
	push 20
	push 0x40 ; color 
	push press_key 
	call printStr   ; press any key to countinue 
	
	mov ah, 0 ; service 0 – get keystroke 
	int 0x16
	
game_start:

call printscrn

 mov cx, 0
 inflop:

call next_note
 call movscrn
 
 mov ah, 2ch
 int 21h
  cmp dl, [prevtime]
  je inflop

 CALL JUMP_BUNNY
 call movscrn2 ; this functions handles printing of the third part, bunny, platform. this function prints bunny platform and then incremets index
 call printscore
 cmp word[game_over_flag], 1
 je game_over_menu
 
 
 mov [prevtime], dl
 jmp inflop
 

 loop inflop
 

 
 

 jmp exit
 
  exit:
 
  mov ax, 0x4c00
  int 0x21