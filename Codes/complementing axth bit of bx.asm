[org 0x0100]

;complementing axth bit of bx

jmp start


start:

mov ax, 6
mov bx, 120
xor dx, dx
stc
rcl dx, 1
mov cx, ax
sub cx, 1
jmp loop

loop:
shl dx, 1
sub cx, 1
jnz loop
xor bx, dx



mov ax,0x4c00
int 0x21

