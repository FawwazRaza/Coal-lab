
[org 0x0100] ;we will see org directive later

mov ax,0;
mov cx,10;
mov bx,0;

l1:  add ax,[Array+bx];
	 add bx,2;
	 sub cx,1;
	 jnz l1;

;add ax,[Array+0]
;add ax,[Array+2]
;add ax,[Array+4]
;add ax,[Array+6]
;add ax,[Array+8]
;add ax,[Array+10]
;add ax,[Array+........]

mov [Sum],ax;

Array : dw 111,999,888,888,11,99,88,88,1,9,8,8
Sum: dw 0;

mov ax, 0x4c00 ;terminate the program
int 0x21 