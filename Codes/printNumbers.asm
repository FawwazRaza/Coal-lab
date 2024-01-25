; Write a function printNumbers that take multiple numbers on stack as input and prints them on 
; screen. The function also takes total numbers to be printed as input. 
; For example, if numbers to be printed are 134, 189, 156 then call to printNumbers will be as follow
; Start: 
; Push 134; first number to be printed
; Push 189; second number to be printed
; Push 156; third number to be printed
; Push 3; total numbers to be printed 
; Call printNumbers
; The screen should look like this after this call (be careful about the order in which numbers are printed, it should 
; be same as shown on screen i.e number at end of stack is printed on first line and vice versa)
; You can use printNumber routine given in book for this question, and call it multiple times in printNumbers 
; function. 
; Your function should work with any number of inputs not just 3 inputs


[org 0x0100]

jmp start
clrscr: 
push es
push ax
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column
nextloc: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 4000 ; has the whole screen cleared
jne nextloc ; if no clear next position
pop di
pop ax
pop es
ret


printnum:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx


mov ax, 0xb800
mov es, ax
mov ax, [bp+4]
mov bx, 10
mov cx, 0

nextdigit:
mov dx, 0
div bx
add dl, 0x30
push dx
inc cx
cmp ax, 0
jnz nextdigit
mov di, [dival]

nextpos:
pop dx
mov dh, 0x07
mov [es:di], dx
add di, 2
loop nextpos
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 4

start:
call clrscr
mov bx, 0
mov cx, 4
mov si,160

l1:
mov ax, [data+bx]
add bx, 2
push ax
call printnum
mov [dival],si
add si,160
loop l1

mov ax, 0x4c00
int 0x21

data dw 138, 189, 156,100

dival:
dw 0