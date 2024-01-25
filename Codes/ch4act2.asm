
[org 0x0100]


mov ax, 0x1234
mov bx, ax
shr al, 4 
shl bl, 4 
or al, bl 
shr ah, 4 
shl bh, 4 
or ah, bh


mov ax, 0x4c00
int 0x21
