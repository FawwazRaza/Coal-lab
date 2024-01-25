

jmp start
count : dw 20


start:
; draw line in graphics mode
[org 0x0100]
mov ax, 0x000D ; set 320x200 graphics mode
int 0x10 ; bios video services

; mov ax, 0x0C07 ; put pixel in white color
; xor bx, bx ; page number 0
; mov cx, 000 ; x position 200
; mov dx, 00 ; y position 200

;setting cursor position
mov ah,  02h
mov bh, 0
mov dh, 3 ; row
mov dl, 10; col
push dx
INT 0x10



l1:

mov ah, 0Ah
mov al,  '*'
mov BH, 0
mov BL, 4
mov cx, 5
int 0x10

mov ah,  02h
mov bh, 0
pop dx
inc dh
mov dl, 10
INT 0x10

mov cx, [count]
dec cx
dec word [count]
jnz l1

mov word[count], 5



mov ah,  02h
mov bh, 0
mov dh, 5
mov dl, 5
push dx
INT 0x10

l2:
mov ah, 0Ah
mov al,  '*'
mov BH, 0
mov BL, 4
mov cx, 20
int 0x10
mov ah,  02h
mov bh, 0
pop dx
inc dh
mov dl, 5
INT 0x10

mov cx, [count]
dec cx
dec word [count]
jnz l2


l3:

loop l3



