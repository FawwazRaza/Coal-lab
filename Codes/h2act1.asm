[org 0x0100]

mov ax, 0
mov bx, 0

mov cx, [num1]

l1: add ax, cx
	sub cx,1
	jnz l1
	
num1: dw 6

mov ax, 0x4c00 ; terminate program
int 0x21
