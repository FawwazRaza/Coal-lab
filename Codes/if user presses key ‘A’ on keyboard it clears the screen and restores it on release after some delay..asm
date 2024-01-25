; TSR to show status of shift keys on top left of screen
; Update your program “tsr.com” and hook keyboard interrupt such that if user presses key ‘A’ on keyboard it clears the screen and restores it on release after some delay. Do not send key ‘A’ to original ISR (both the press and release codes), rest of the keys should be passed to original ISR. Your program should just hook the interrupt, make it TSR and leave. Do not write any loop in start.
; (If your program doesn’t work properly see help given in the end).


[org 0x0100]
 jmp start
oldisr: dd 0 ; space for saving old isr
; keyboard interrupt service routine
kbisr: push ax
 push es
 mov ax, 0xb800
 mov es, ax ; point es to video memory
 in al, 0x60 ; read a char from keyboard port
 cmp al, 0x2a ; has the left shift pressed
 jne nextcmp ; no, try next comparison

 call storeInBuffer
  call clrscr
 mov byte [es:0], 'L' ; yes, print L at first column
 jmp exit ; leave interrupt routine

nextcmp: cmp al, 0x36 ; has the right shift pressed
 jne nextcmp2 ; no, try next comparison
 call back
 mov byte [es:0], 'R' ; yes, print R at second column
 jmp exit ; leave interrupt routine

nextcmp2: cmp al, 0xaa ; has the left shift released
 jne nextcmp3 ; no, try next comparison
 mov byte [es:0], ' ' ; yes, clear the first column
 call back
 jmp exit ; leave interrupt routine
nextcmp3: cmp al, 0xb6 ; has the right shift released
 jne nomatch ; no, chain to old ISR
 mov byte [es:2], ' ' ; yes, clear the second column
 jmp exit ; leave interrupt routine
nomatch: pop es
 pop ax
 jmp far [cs:oldisr] ; call the original ISR
exit: mov al, 0x20
 out 0x20, al ; send EOI to PIC

 pop es
 pop ax
 jmp far [cs:oldisr]

 ;iret ; return from interrupt

back:
pusha
mov ax,0xb800
mov es,ax
push cs
pop ds
mov di,0
mov si,buffer
mov cx,2000
cld
loop1:
lodsw
stosw
dec cx
jnz loop1
popa
ret


storeInBuffer:
pusha
push cs
pop es
mov ax,0xb800
push ax
pop ds



mov cx,2000
mov si,0
mov di,buffer
cld
rep movsw
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


 buffer: dw 0