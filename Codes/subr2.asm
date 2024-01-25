[org 0x0100]

; You have to run three test cases like this:
jmp Start

num1: dw 0

Subtract:
push bp
mov bp, sp
push ax
push bx
push cx
push si

mov ax, [bp+10]
sub ax, [bp+8]

sub ax, [bp+6]

sub ax, [bp+4]


mov [num1], ax
mov [bp+12], ax

pop si
pop cx
pop bx
pop ax
pop bp

ret 8

AntoherFunction:
push bp
mov bp, sp
push ax
push bx
push cx
push si


mov ax,0xcccc
push ax
push word[bp+10]
push word[bp+8]
push word[bp+6]
push word[bp+4]
Call Subtract
pop ax
mov [bp+12], ax

mov ax,0xcccc
push ax
push word[bp+6]
push word[bp+4]
push 0
push 0
Call Subtract
pop ax
mov [bp+14], ax



pop si
pop cx
pop bx
pop ax
pop bp

ret 8



Start:
; function call Test i
mov ax, 0xcccc
push ax
push ax
push 0xA
Push 0x1
Push 0x2
Push 0x2
Call AntoherFunction
Pop AX ;verify answer here
pop bx
add ax,bx


; function call Test ii
mov ax, 0xcccc
push ax
push ax
push 0x9
Push 0x1
Push 0x5
Push 0x0
Call AntoherFunction
Pop AX ;verify answer here
pop bx
add ax,bx

; function call Test iii
mov ax, 0xcccc
push ax
push ax
push 0xF
Push 0x1
Push 0x8
Push 0x4
Call AntoherFunction
Pop AX ;verify answer here
pop bx
add ax,bx

;Termination Code here
mov ax, 0x4c00
int 0x21