;q1: opcode : B8
;q2: yes used everywhere
;q3: B80500: B8 is opcode ,  0500 is the data
;q4: opcode is same of movax,someconstant
;q5: 0100
;q6: because there is difference of 3 bytes so the difference is of three bytes
;q7: 18 bytes
;q8: versified
;6
;a: ip value is 0100 because it is pointing the first offset
;b: initial value of data registers is ax:0000 , bx=0000 , cx= 0012 , dx=0000
;c: watched


; this is a comment. Comment starts with semicolon
; this program adds three numbers in registers
[org 0x0100] ;we will see org directive later
mov ax, 10 ; AX = 10
mov bx, 20 ; BX = 20
mov cx, 30 ; cx= 30
mov dx, 0 ; dx= 0

mov dx, cx ; dx= 30
mov cx, bx ; cx= 20
mov bx, ax ; bx= 10
mov ax, dx ; ax= 30

mov dx, cx ; dx= 20
mov cx, bx ; cx= 10
mov bx, ax ; bx= 30
mov ax, dx ; ax= 20

mov ax, 0x4c00 ;terminate the program
int 0x21