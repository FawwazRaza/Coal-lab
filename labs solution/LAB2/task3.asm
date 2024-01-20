
	[org 0x0100] ;we will see org directive later
	mov ax,200h;
	mov bx,150h;
	 
	mov bx,[0x250]
	mov ax,bx;
	mov bx,50h;
	mov [0x250],bx;
	mov bx,[0x200]
	mov ax,bx;
	mov bx,25h;
	mov [0x200],bx;
	;mov bx,[Array]
	mov bx,[0x200]
	;mov cx,5

	;l1: mov ax,[bx]
	;	add bx,2
	;	sub cx,1
	;	jnz l1
	mov ax,bx;
	
	
	 mov cx,[0x250];
		
	mov ax, 0x4c00 ;terminate the program
	int 0x21 

	Array : dw 1,2,7,5,10
	Sum: dw 0;
