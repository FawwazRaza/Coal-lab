[org 0x0100]

; jmp start

; num1: dw 0A0Bh,
		; db 0Ch,
		; dw 0D0Eh,
		; dd 0102030405060708h
		


; start:

; mov ax, [num1]

; mov ah, [num1+2]

; mov ax, [num1+3]

 ; mov ah, [num1+9]
 
 
 
 ;shifting right for 32 bit
 ; jmp start
 
 ; num1: dd 0x22446688
 
 ; start:
 ; shr word [num1+2],1 
 ; rcr word[ num1], 1
 
 
 
 
 
 ;invalid addressing
 
 ; jmp start
 
 ; num1: dw 5
 ; mov bx, 1
 
 ; mov ax,  [num1+bx]
 ; mov word   [bx+bp], 10
 ; mov  [bx+si], ax
 ; mov ax,  [bx-si], ax
 ; mov ax,  [num1+bx]
 
 
 
 ;doing and with 1 actually means doin and with 0000 0001
 
; mov al, 11011101b
; and al, 1
; ror al, 1



;program that caluclates pairwise sum 
; jmp start
; arr: dw 8
; given : db 1,2,3,4,5,6,7,8
; sum: db 0,0,0,0,0,0,0,0

; start:

; mov cx, [arr]
; shr cx, 1
; jc odd
; jmp evn


; evn:
; mov si, given
; mov di, si
; add di, [arr]
; sub di, 1

; mov bx, sum

; mov cx, [arr]
; shr cx, 1


; l1:

; mov al, [si]
; add al, [di]
; mov [bx], al
; add bl, 1
; add si, 1
; sub di, 1
; sub cx, 1
; jnz l1
; jmp exit


; odd:
; mov si, given
; mov di, si
; add di, [arr]
; sub di, 1

; mov bx, sum

; mov cx, [arr]
; shr cx, 1


; l2:

; mov al, [si]
; add al, [di]
; mov [bx], al
; add bl, 1
; add si, 1
; sub di, 1
; sub cx, 1
; jnz l2
; mov al, [si]
; mov [bx], al


; jmp exit


; exit:
; mov ax, 0x4c00
; int 0x21



; jmp start

; data: dw 3,5,10,9,12,16, -1

; start:
; mov si, data

; loop1:
; cmp word[si] , -1
; jz end

; mov ax, [si]
; shr ax, 1
; jc odd

; even:
; shr word[si+2], 2
; jmp next

; odd: 
; shl word[si+2], 1

; next:
; add si, 4
; jmp loop1


; end:
; mov ax, 0x4c00
; int 0x21



;program to reverse bits of an array
;0000 0011 will turn into 1100 0000

; jmp start

; arr1: db 1,2,3,4
; arr2: db 0,0,0,0

; siz: dw 4

; start:

; mov si, arr1
; add si, [siz]
; sub si, 1 ;pointing to 4 now
; mov cx, [siz]
; mov di, arr2
; mov bx, 8

; loop1:

; loop2:

; shr byte[si], 1
; rcl  byte[di], 1
; sub bx, 1
; jnz loop2

; mov bx, 8
; sub si, 1
; add di, 1
; sub cx, 1
; jnz loop1

; mov ax, 0x4c00
; int 0x21




;swaping nibbles of ax
; mov ax, 0xE3C3

; mov bx, ax
; shl ah, 4
; shr bh, 4
; or ah, bh

; shl al, 4
; shr bl, 4
; or al, bl



;rought addition byte by byte
; jmp start
; num1: dw 0x101B
; num2: dw 0x231A
; result: dw 0x0000

; start:
; mov ax, [num1]
; add ax, [num2]

; clc
; mov bl, [num1]
; add bl, [num2]
; mov [result], bl

; mov bl, [num1+1]
; adc bl, [num2+1]
; mov [result+1], bl

; mov dx, [result]


;64 bit addition
; jmp start

; num1: dq 0x00FFFFDFFFFEFFFE
; num2: dq 0xFF00000200001001
; res:  dq 0x0000000000000000
; start:

; mov cx, 4
; mov si, num1
; mov di, num2
; mov bx, res


; loop1:
; mov ax, [si]
; add ax, [di]
; jc carry

; mov [bx], ax
; add si, 2
; add di, 2
; add bx, 2
; sub cx, 1
; jnz loop1
; jmp exit
; carry:
; mov [bx], ax
; add si, 2
; add di, 2
; add bx, 2
; sub cx, 1
; stc
; jnz loop1
; jmp exit

; exit:
; mov ax, 0x4c00
; int 0x21


; jmp start

; start:
; mov ax, 0xffff
; push ax
; call print

; mov dx, 0xffff


; print:
; mov ax, 0x0000
; mov bx, 0x0000
; ret

mov ah, 00h
mov al, 13h
int 10h


  ; mov ah, 0bh ;setting background  configuration
 ; mov bh, 00h
 ; mov bl, 00h
 ; int 10h
 




 
 
 
 
 
