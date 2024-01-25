
; Write a TSR to make an asterisks travel the border of the screen, from upper left to upper right to lower right to lower left and back to upper left indefinitely, making each movement after one tick. Note: Do not use any loop.
[org 0x0100] 
 jmp start 
tickcount: dw 0 
flag:dw 0

print: 
    pusha
    mov ax,0xb800
    mov es,ax
    mov di,[cs:tickcount]
    mov ah,0x07
    mov al,'*'
    mov word[es:di],ax

    cmp di,158
    jne cmpn1
    mov word[cs:flag],1
    jmp exx

    cmpn1:
    cmp di,3998
    jne cmpn2
    mov word[cs:flag],2
    jmp exx

    cmpn2:
    cmp di,3840
    jne cmpn3
    mov word[cs:flag],3
    jmp exx

    cmpn3:
    cmp di,0
    jne exx
    mov word[cs:flag],0
    jmp exx

    exx:
    popa
ret 

clrscr: 
    push es 
    push ax 
    push cx 
    push di 
    mov ax, 0xb800 
    mov es, ax 
    xor di, di 
    mov ax, 0x0720 
    mov cx, 2000 
    cld 
    rep stosw 
    pop di 
    pop cx 
    pop ax 
    pop es 
ret 


delay:
    pusha
    mov cx,0xffff
    d:
    loop d
    mov cx,0xffff
    d2:
    loop d2
    mov cx,0xffff
    d3:
    loop d3
   
    popa
ret


timer: 
    push ax

    mov ax,[cs:flag]
    cmp ax,0
    jne nextcmp
    mov ax,[cs:tickcount]
    add ax,2
    mov word [cs:tickcount],ax 
    jmp go

    nextcmp:
    cmp ax,1
    jne nextcmp2
    add word[cs:tickcount],160
    jmp go
    nextcmp2:
    cmp ax,2
    jne nextcmp3
    sub word[cs:tickcount],2
    jmp go
    nextcmp3:
    cmp ax,3
    jne go
    sub word[cs:tickcount],160
    go:
    call clrscr
    call print 
    mov al, 0x20 
    out 0x20, al 
    pop ax 
iret 


start: 
    xor ax, ax 
    mov es, ax 
    cli 
    mov word [es:8*4], timer 
    mov [es:8*4+2], cs  
    sti  
        
    mov dx, start 
    add dx, 15  
    mov cl, 4 
    shr dx, cl  
mov ax, 0x3100  
int 0x21