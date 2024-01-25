
[org 0x0100]

; clear the screen 
jmp start

 
 coordi: dw 0
 coordj: dw 0
 numrow: dw 80
 rowcheck: dw 160
 dflag: dw 0 ; 0 equals right 1 equals down 2 equals left 3 equals up
 icheck: dw 24
 jcheck: dw 156
 zero: dw 0
 tickcount: dw 0
 prevcount: dw 0
oldisr: dd 0
prevcontent: dw 0 
previndex: dw 0
moveflag: dw 0
oldkb: dd 0





timer: 

push ax

inc word [cs:tickcount]; increment tick count
 mov bx, [cs:tickcount]
mov dx, [cs:prevcount]
sub bx, dx
cmp bx, 18
jae secpassed
jmp secnotpassed
 secpassed:
 mov bx, [cs:tickcount]
 mov [cs:prevcount], bx
call movingstar ; print tick count
secnotpassed:

mov al, 0x20
out 0x20, al ; end of interrupt

pop ax
iret ; return from interrupt
 
 cls:
 
  push bp 
 mov bp, sp 
push ax
push di
push es
 
 mov ax, 0xb800 ; load video base in ax 
 mov es, ax ; point es to video base 
 mov di, 0 ; point di to top left column 
nextchar: mov word [es:di], 0x0720 ; clear next char on screen 
 add di, 2 ; move to next screen location 
 cmp di, 4000 ; has the whole screen cleared 
 jne nextchar ; if no clear next position 
 
pop es
pop di
pop ax

 pop bp 
 ret 
 
 
 movingstar:
 
 push bp 
 mov bp, sp 
 push ax
push di
push es

mov ax, [cs:moveflag]
cmp ax, 0 ; if zero then dont move ; zero when right shift
jz here
 
 mov ax, 0xb800 ; load video base in ax 
 mov es, ax ; point es to video base 
 
 
 mov di, [cs:previndex] ;puranay index me purani value daldi
 mov ax, [cs:prevcontent]
 mov word [es:di], ax
 
 
 mov ax, [cs:coordi]
 mul word [cs:numrow]
 shl ax,1
 ; shl ax, 1
 add ax, [cs:coordj]
 mov di, ax ;point di to required location
 
 
 
 
  
 
 mov ax, [es:di]
 mov  [cs:prevcontent], ax
 mov [cs:previndex], di
 
 
 mov word [es:di], 0x072A ; print * char on screen 
 

 
 
 
 
 
 
 mov ax, [cs:dflag]
 cmp ax,0
 jz rightwards
 cmp ax, 1
 jz downwards
 cmp ax, 2
 jz leftwards
 cmp ax, 3 
 jz upwards
 
 rightwards:
 mov word [cs:dflag], 0
 mov ax, [cs:coordj]
 cmp ax, [cs:jcheck]
 jz downwards
 mov ax, [cs:coordj]
 inc ax
 mov [cs:coordj], ax
 

 here:
 
 
 
pop es
pop di
pop ax
 pop bp 
 ret
 ;end of function moving star

 downwards:
 mov ax, [cs:coordi]
 cmp ax, [cs:icheck]
 jz leftwards
 mov word [cs:dflag], 1
 mov ax, [cs:coordi]
 inc ax
 mov [cs:coordi], ax
 jmp here
 
 leftwards:
 mov word [cs:dflag], 2
 
 mov ax, [cs:coordj]
 cmp ax, [cs:zero]
 jz upwards
  mov ax, [cs:coordj]
 dec ax
 mov [cs:coordj], ax
 jmp here
 
 
 
 upwards:
 mov word [cs:dflag], 3
 mov ax, [cs:coordi]
 cmp ax, [cs:zero]
 jz rightwards
 dec ax
 mov [cs:coordi], ax
 jmp here
 
 
 
kbisr: push ax
push es
mov ax, 0xb800
mov es, ax ; point es to video memory
in al, 0x60 ; read a char from keyboard port
cmp al, 0x2a ; is the key left shift
jne nextcmp ; no, try next comparison
mov word [cs:moveflag], 1
jmp nomatch ; leave interrupt routine
nextcmp: 
cmp al, 0x36 ; is the key right shift
jne nomatch ; no, leave interrupt routine
mov word [cs:moveflag], 0
nomatch: 

pop es
pop ax
jmp far [cs:oldkb]



 
 start: 
 call cls

xor ax, ax
mov es, ax ; point es to IVT base
mov ax, [es:9*4]
mov [oldkb], ax ; save offset of old routine
mov ax, [es:9*4+2]
mov [oldkb+2], ax ; save segment of old routine
cli ; disable interrupts
mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2
mov word [es:8*4], timer ; store offset at n*4
mov [es:8*4+2], cs ; store segment at n*4+
sti ; enable interrupts
mov dx, start ; end of resident portion
add dx, 15 ; round up to next para
mov cl, 4
shr dx, cl ; number of paras
mov ax, 0x3100 ; terminate and stay resident
int 0x21
 
 
 
 