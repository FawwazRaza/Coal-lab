;string printing using interrupt

[org 0x0100]

jmp start

msg: db 'score: ',0
score: dw 0


start:
MOV AX,0013H
INT 10H 


push 32
push 15
push 0x40 ; color 
push msg
call printStr

push 37
push 15
push 0x40
mov ax, [score]
add ax, '0'
push AX
call printStr


infloop:

jmp infloop
	
	
	
	
	printStr:
	push bp
	mov bp, sp

	pusha

	xor bh, bh
	mov si, [bp+4]

	push 0
	push si
	call STRLEN
	pop cx

	mov dl, [bp+10]
	mov dh, [bp+8]
nextPrint:
	push cx

	;setting cursor
	mov ah, 0x2
	int 0x10

	mov al, [si]
	mov bl, [bp+6]
	mov cx, 1
	mov ah, 0x9
	int 0x10

	inc dl
	inc si
	pop cx
loop nextPrint

	popa

	pop bp
ret 8









STRLEN:
	push bp
	mov bp, sp

	push es
	push di
	push ax
	push cx

	push cs
	pop  es
	mov  di, [bp+4]
	mov  cx, 0xffff
	xor  al, al
	repne scasb
	mov  ax, 0xffff
	sub  ax, cx
	dec  ax

	mov [bp+6], ax

	pop cx
	pop ax
	pop di
	pop es

	pop bp
ret 2

