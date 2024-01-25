[org 0x0100]
;uses two loops
; inner loop runs i number of times where i is the count of outerloop
;after one outerloop cycle, di value is popped back, 160 is added to jump to starting lower position then inner loop is started again
;outerloop finishes when i equals the length


jmp start


start:
call cls ; clear screen


mov ax, 4 ;row parameter 1 accessed using bp+8
push ax 
mov ax,40 ; col parameter 2 accessed using bp+6 
push ax
mov ax, 10; length parameter 3 accessed using bp+4
push ax
call printtriangle



 ;mov ax, 0xb800 ; load video base in ax 
 mov word [es:di], 0x072A ; star code
 
 
 
 printtriangle:
 
 push bp
 mov bp, sp
 push ax
 push dx
 push bx
 push si
 push di
 
 mov ax, 0xb800 ; load video base in ax 
 mov es, ax
 
 ;index row col
 mov al, 80
 mul byte [bp+8]
 add ax, [bp+6]
 shl ax, 1
 mov di, ax ; pointing di to required position
 
 
  mov cx, 0; length
 
 outerloop:
add cx, 1

 
 
 push di
mov dx, 0
 innerloop:
  mov word [es:di], 0x072A ; star code
  add di, 2
  
  add dx, 1
  cmp dx, cx
  jne innerloop
  
  pop di
  add di, 160
  cmp cx, [bp+4]
  jne outerloop
  jmp exit
  
  
  
 
 
 
 
 
 
 
 
 
 pop di
 pop si
 pop bx
 pop dx
 pop ax
 pop bp
 ret 6
 
 
 
 
 exit:
 mov ax, 0x4c00
 int 0x21
 
 
 
 cls: ; clearscreen function
 
  push bp 
 mov bp, sp 
 push es 
 push ax 
 push cx 
 push si 
 push di
 
 mov ax, 0xb800 ; load video base in ax 
 mov es, ax ; point es to video base 
 mov di, 0 ; point di to top left column 
nextchar: mov word [es:di], 0x0720 ; clear next char on screen 
 add di, 2 ; move to next screen location 
 cmp di, 4000 ; has the whole screen cleared 
 jne nextchar ; if no clear next position 
 
 

  pop di 
 pop si 
 pop cx 
 pop ax 
 pop es 
 pop bp 
 ret 
 