

[org 0x0100]

jmp start

num1:  times 800 dw 0
msg: db 'hello world'
len: dw 11


start:

call printscreen

infloop:


push ds

mov ax, 0xb800
mov es, ax





;saving top 5 lines in memory
mov cx, 400
mov bx, num1
xor si, si


l1:
mov ax, [es:si] 
add si,2
mov [bx], ax
add bx, 2

loop l1



mov ax, 0xb800
mov ds, ax

;scrolling up
cld
mov cx, 1600
xor di, di
mov si, 800

;rep movsw
movswloop:

 movsw
 call delay
 loop movswloop

;clearing bottom five lines
std
mov di, 3998
mov cx, 400
mov ax, 0x0720

stoswloop:
stosw
call delay
loop stoswloop
;rep stosw

;scrolling down

std
mov si, 3198
mov di, 3998
mov cx, 1600
movswloop2:
movsw
call delay
loop movswloop2
;rep movsw

 
 ; loading from memory to screen
 
 
 pop ds
 cld
 mov cx, 400
 xor di,di
 mov bx, num1
 
 
 l2:
 call delay
 ;mov ax, [bx]
 ; mov ax, 0x0720 works and prints 5 empty lines
 ;mov ax, [bx] stores bx but then data is overwritten in es:si
 
mov ax, [bx] 
mov [es:di], ax
add di, 2
add bx, 2
loop l2
 

jmp infloop
jmp exit


printscreen:

push bp
push ax
push bx
push si
push di

mov ax, 0xb800
mov es, ax
mov cx, 2000
mov ax, 0x0720
xor di, di
rep stosw

xor si, si
mov cx, [len]
mov bx, msg
mov ah, 0x07
mov di, 3200



mov cx, 5

mloop:
push cx
mov cx, [len]

msgloop:

mov byte al, [bx]
mov [es:si], ax
mov [es:di], ax
inc bl
add si, 2
add di, 2

loop msgloop
add si, 138
add di, 138

mov bx, msg

pop cx

loop mloop


pop di
pop si
pop bx
pop ax
pop bp
ret














delay:

push bp
push cx
push ax

mov cx, 0x0fff
dloop:
mov ax, 0
loop dloop

pop ax
pop cx
pop bp
ret

exit:

mov ax, 0x4c00
int 0x21
