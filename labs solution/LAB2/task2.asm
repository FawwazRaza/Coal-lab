
	[org 0x0100] ;we will see org directive later

	mov ax,[n1];
	mov bx,[n2];
	add ax,bx;
	mov bx,[n3];
	add ax,bx;
	mov bx,[n4];
	add ax,bx;
	mov bx,[n5];
	add ax,bx;
	mov [Sum],ax;

	mov ax, 0x4c00 ;terminate the program
	int 0x21 

	n1: dw 10;
	n2: dw 20;
	n3: dw 30;
	n4: dw 40;
	n5: dw 50;
	Sum: dw 0;
