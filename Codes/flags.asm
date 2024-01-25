;5.1 - Flags.asm
; Flag Register with unsigned subtraction

[org 0x0100]

;--------------------------------------
;DEST = SRC
;--------------------------------------

;check it yourself
;MOV AL, -126
;SUB AL, 0x40

;2-2
MOV AL, 0X02
SUB AL, 0X02

;-3--3
MOV AL, -3 ;0XFD
SUB AL, -3 ;0XFD

;--------------------------------------
;UDEST < USRC
;--------------------------------------

;2-4
MOV AL, 2;0X02
SUB AL, 4;0X04

;2-80
MOV AL, 0X02
SUB AL, 0X80

;--------------------------------------
;UDEST > USRC
;--------------------------------------

;82-40
MOV AL, 0X82
SUB AL, 0X40

;--------------------------------------
;SDEST < SSRC
;--------------------------------------

;-4--3
MOV AL, -4;0XFC
SUB AL, -3;0XFD

;-3-+4
MOV AL, -3;0XFD
SUB AL, +4;0X04

;+3-+4
MOV AL, +3;0X03
SUB AL, +4;0X04
;--------------------------------------
;SDEST > SSRC
;--------------------------------------

;-3--4
MOV AL, -3;0XFD
SUB AL, -4;0XFC

;+3--4
MOV AL, +3;0X03
SUB AL, -4;0XFC

;+4-+3
MOV AL, +4;0X04
SUB AL, +3;0X03
;--------------------------------------
;MISC
;--------------------------------------
;FD+1+1+1
MOV AL, 0XFD
ADD AL, 0X01
ADD AL, 0X01
ADD AL, 0X01


mov ax, 0x4c00		;terminate the program
int 0x21
