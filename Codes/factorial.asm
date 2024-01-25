;activity 1 nested loop
; factorial

[org 0x0100]


jmp start

num1: dw 5
res : dw 0



start:
mov ax, 0
mov cx, [num1]
sub cx, 1
mov bx, [num1]

jmp innerl


outerl:
mov bx, ax
mov ax, 0
mov dx, 0
sub cx, 1

jnz innerl
mov [res] , bx
jmp exit




innerl:
add ax, bx
add dx, 1
cmp dx, cx
jz outerl
jmp innerl


exit:
mov ax, 0x4c00
int 0x21




