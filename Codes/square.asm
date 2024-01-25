[org 0x0100]

mov ax, 0

mov cx, [num1]
mov bx, [num1]

l1: add ax, bx
	sub cx,1
	jnz l1
	
	
mov [square], ax

num1: dw 9
square: dw 0


mov ax, 0x4c00 ; terminate program
int 0x21
