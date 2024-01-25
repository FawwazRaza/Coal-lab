[org 0x0100]

speed: dw 1
tick: dw 0
oldtick: dw 0
xpos: dw 20
ypos: dw 1
sec: dw 0


jmp start



tisr:
pusha

mov ax, 0xb800
mov es, ax

mov ax, [cs:sec]
push ax
call printnum


inc word [cs:tick]
mov ax, [cs:tick]
mov bx, [cs:oldtick]
sub ax, bx
cmp ax, 13
jb secnotpassed


secpassed:
inc word[cs:sec]
mov ax, [cs:tick]
mov [cs:oldtick], ax
;if one second has passed remove old asterisk and print at new location


call clrscr

 mov ax, [cs:speed]
 add [cs:xpos], ax

mov al, 80
mul word [cs:ypos]
add ax, [cs:xpos]
shl ax, 1
mov di, ax
mov word [es:di], 0x072A







secnotpassed:
popa
mov al, 0x20
out 0x20, al
iret






; keyboard interrupt service routine
kbisr: 

push ax
push es

in al, 0x60 ; read a char from keyboard port
cmp al, 0x2a ; is the key left shift
jne nextcmp ; no, try next comparison
sub word[cs:speed], 2
jmp nomatch ; leave interrupt routine
nextcmp: cmp al, 0x36 ; is the key right shift
jne nomatch ; no, leave interrupt routine
add word [cs:speed], 2
nomatch: mov al, 0x20
out 0x20, al ; send EOI to PIC
pop es
pop ax
iret

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
mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
mov word [es:8*4], tisr
mov [es:8*4+2], cs
sti ; enable interrupts
l1: jmp l1 ; infinite loop









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