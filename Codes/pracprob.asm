[org 0x0100]

mov al, [num1]	;load num 1 in ax 
mov [num1+6], ax	;write data from ax in number 4
mov ax, [num1+1]	;load num 2 in ax
add [num1+5], al	;add 2 numbers
mov ax, [num1+4]	;load num 3 in ax
add [num1+6], ah	;add 2 numbers

mov ax, 0x4c00	;terminate the program
int 0x21

num1:	dw 0xabcd, 0x1234, 0x279A, 0