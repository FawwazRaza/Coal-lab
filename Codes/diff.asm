[org 0x0100]

jmp start

sizeset1: db 7
sizeset2: db 5
sizesetdif: db 7
set1: db -3,-1,2,5,6,8,9
set2: db -2,2,6,7,9
diff: db 0,0,0,0,0,0,0


start:
xor cx,cx
mov cl, [sizeset1]
mov si, set1
mov di, diff

l1:
mov al, [si]
mov [di], al
add si, 1
add di, 1
sub cx,1
jnz l1

mov cl, [sizeset1]
mov si, diff
mov di, set2
mov bl, [sizeset2]
jmp l2

l2:
mov al, [si]


l3:
cmp al, [di]
je delete
here:
add di, 1
sub bl, 1
jnz l3

mov di, set2
mov bl, [sizeset2]
add si, 1
sub cl, 1
jz exit
jmp l2


delete:
mov byte [si] , 0
jmp here


exit: mov ax, 0x4c00
int 0x21



