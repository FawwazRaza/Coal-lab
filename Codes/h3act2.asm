
[org 0x0100]

mov si, 0
mov cx, 0
mov dx,0





outerl:
cmp si, 18
jz zeroleft
mov ax, [arr1+si]  ; moving first num to ax
mov bx, si
mov cx, si
add si,2
cmp ax, 0
jz outerl
cmp si, 16
jnz innerl





innerl:
add bx, 2
add cx, 2
cmp cx, 18
jz outerl
cmp ax, [arr1+bx]
jz makezero
jmp innerl




makezero:
mov [arr1+bx], dx
jmp innerl


zeroleft:

mov si, 0
jmp l3



l3:
mov ax, [arr1+si]
add si,2
cmp si, 16
jz exit

mov bx, si
mov cx, si
cmp ax, 0
jz l4
jmp l3


l4:

cmp cx, 18
jz l3
cmp [arr1+bx], ax
jg swap
jmp l4


swap:
mov dx, [arr1+bx]
sub si,2
mov [arr1+si], dx
add si,2
mov dx, 0
mov [arr1+bx], dx
jmp l3



exit:

mov ax, 0x4x00
int 0x21







arr1: dw 1,2,1,3,1,1,3,2,3
var1: dw 0
;cx 16
