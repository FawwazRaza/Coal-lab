
 
 ;terminate program with Esc 

[org 0x100]


;p scan code 19
jmp start
oldisr: dd 0 ; space for saving old isr
trisize: dw 6 ; triangle size


; keyboard interrupt service routine
kbisr: push ax
push es
mov ax, 0xb800
mov es, ax ; point es to video memory
in al, 0x60 ; read a char from keyboard port
cmp al, 0x19 ; is the key p
jne nomatch
mov cx, [cs:trisize]
cmp cx, 0
jz nomatch
dec word [cs:trisize]
mov bx, cx
shl bx, 1

mov ax, 0x072A ; attribute and star character
rep stosw
add di, 160
sub di, bx

jmp nomatch ; leave interrupt routine

nomatch: 

pop es
pop ax
jmp far [cs:oldisr] ; call the original ISR
; iret
; mov al, 0x20
; out 0x20, al ; send EOI to PIC
; pop es
; pop ax
; iret



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
mov ax, [es:9*4]
mov [oldisr], ax ; save offset of old routine
mov ax, [es:9*4+2]
mov [oldisr+2], ax ; save segment of old routine
cli ; disable interrupts
mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
sti ; enable interrupts
mov di, 0


l1: mov ah, 0 ; service 0 – get keystroke
int 0x16 ; call BIOS keyboard service
cmp al, 27 ; is the Esc key pressed
jne l1 ; if no, check for next key
mov ax, 0x4c00 ; terminate program
int 0x21