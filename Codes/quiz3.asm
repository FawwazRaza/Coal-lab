

jmp start
count : dw 0
row: dw 4


start:
MOV AX,0013H
INT 10H 
 
l1:


mov AH,0Ch
mov bh,  0
mov al, 4 ; color
mov cx, 10 ; col
mov dx, [row]
int 0x10

inc word [row]
mov cx, [count]
dec word[count]
dec cx
jz l2
jmp l1



l2:

