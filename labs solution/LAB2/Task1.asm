
	[org 0x0100] ;we will see org directive later

	mov ax,0;
	mov ax,25h;
	mov bx,0;
	mov [Swap],ax
	mov ax,bx;
	mov bx,[Swap]
	mov cx,[0x270]
	mov cx,3
	mov si,0
	
	l1:  mov ax,[num+si]
		 add si,2
		sub cx,1;
		jnz l1;

num : dw 12, 25, 10
	Swap: dw 0
	mov ax, 0x4c00 ;terminate the program
	int 0x21 

	

