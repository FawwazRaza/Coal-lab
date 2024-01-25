 ; Move a number (6 for this question) from a memory location in AX, move 4 into 
; BX then find num * 4 using ADD instruction and then divide that answer by 3 using SUB 
; instruction. Store the results of multiplication and division (quotient) at different memory 
; locations labeled as “mresult” and “dresult”.

[org 0x0100]

mov ax,[num1]
mov bx,[num2]
l1:
add ax,[num1]
sub bx,1
cmp bx,0
jnz l1

mov [mresult],ax
mov cx,0
l2:
sub ax,3
add cx,1
cmp ax,0
jge l2

mov [dresult],ax

mov ax, 0x4c00
int 0x21

num1 dw 6
num2 dw 4
mresult dw 0
dresult dw 0