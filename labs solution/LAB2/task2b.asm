
	[org 0x0100] ;we will see org directive later

	mov ax,[n1];
	mov bx,[n1+2];
	add ax,bx;
	mov bx,[n1+4];
	add ax,bx;
	mov bx,[n1+6];
	add ax,bx;
	mov bx,[n1+8];
	add ax,bx;
	mov [Sum],ax;

	mov ax, 0x4c00 ;terminate the program
	int 0x21 

	n1: dw 10;
	    dw 20;
		dw 30;
		dw 40;
		dw 50;
		;n1: dw 10,20,30,40,50
	Sum: dw 0;
