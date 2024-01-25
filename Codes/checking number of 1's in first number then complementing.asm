;bit manipulations act 1
;checking number of 1's in first number then complementing same amount of lsbs of 2nd number.



[org 0x0100] 

jmp start
num1: dw 16
num2: dw 0
num3: dw 0xFFFF

start :
mov cx, 16
mov bx, 1234
mov ax, 0000
mov dx, 4231


loop:
shr bx, 1
jc add
sub cx, 1
jnz loop
mov cx, ax
mov [num2], ax
mov ax, 0000
jmp copy

add:
add ax, 1
sub cx ,1
jmp loop

copy:
rcr dx, 1
rcr ax, 1
sub cx, 1
jnz copy
xor ax, [num3]
mov cx, [num2]
jmp loop2


loop2:
rcl ax, 1
rcl dx, 1
sub cx, 1
jnz loop2
jmp exit

exit:

mov ax, 0x4c00
int 0x21








