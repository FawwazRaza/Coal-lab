

; display a tick count on the top right of screen
[org 0x0100]
jmp start

tickcount: dw 0
seconds: dw 0
lasttick: dw 0
xpos: dw 10
ypos: dw 10
oldx: dw 0
oldy: dw 0

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
sub word[cs:ypos], 1

jmp nomatch ; leave interrupt routine

downcmp: cmp al, 0x50 ; is the key down btn
jne leftcmp
add word[cs:ypos], 1
jmp nomatch ; no, leave interrupt routine

leftcmp:
cmp al, 0x4B
jne rightcmp
sub word[cs:xpos], 1
jmp nomatch

rightcmp:
cmp al, 0x4D
jne nomatch
add word[cs:xpos], 1
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


; mov al, 80 ; load al with columns per row
; mul word [oldy] ; multiply with y position

; add ax, [oldx] ; add x position
; shl ax, 1 ; turn into byte offset
; mov di, ax ; point di to required location
; mov word[ es:di], 0x720 ; clear asterisk from old position

mov ax, [xpos]
mov [oldx], ax
mov ax, [ypos]
mov [oldy], ax

mov al, 80 ; load al with columns per row
mul word [ypos] ; multiply with y position

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



start: 
call clrscr
xor ax, ax
mov es, ax ; point es to IVT base
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
call printasterisk

jmp infloop
mov ax, 0x3100 ; terminate and stay resident
int 0x21