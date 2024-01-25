[org 0x0100]

jmp start

delay: push cx
mov cx,0xffff
l1: loop l1
pop cx
ret

start: mov cx, 5
loop1:         mov al, 0b6h
out 43h, al

;load the counter 2 value for d3
mov ax, 1fb4h
out 42h, al
mov al, ah
out 42h, al

;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

call delay

;load the counter 2 value for a3
mov ax, 152fh
out 42h, al
mov al, ah
out 42h, al

;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

call delay
	
;load the counter 2 value for a4
mov ax, 0A97h
out 42h, al
mov al, ah
out 42h, al
	
;turn the speaker on
in al, 61h
mov ah,al
or al, 3h
out 61h, al
call delay
mov al, ah
out 61h, al

call delay
 
 loop loop1
mov ax, 0x4c00 ; terminate program
int 0x21