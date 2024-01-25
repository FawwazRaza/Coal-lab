; Given an array with label my_array and its len in label array_len. Write a code that will 
; add index of element in each element of my_array using loop. Do not hard code array_len, read it 
; from memory instead. For example if data is as follow
; my_array: dw 10,34,6,67,24,656,75,59,34
; array_len: dw 9
; At the end of your code my_Array should be
; my_array: dw 10,35,8,70,28,661,81,66,42

[org 0x0100] 

jmp start  

my_array: dw 10,34,6,67,24,656,75,59,34
array_len: dw 9

start:
mov ax,0
mov bx,0

l1:
add [my_array+bx],ax
add ax,1
add bx,2
cmp ax,[array_len]
jne l1
mov ax, 0x4c00 
int 0x21