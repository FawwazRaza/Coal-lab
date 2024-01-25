[org 0x0100]

MOV AX,0013H
INT 10H 
 

; MOV Ah, 0x04 ; AL gets the color value
; mov al, 1
 ; MOV BX,0A000H ;
; MOV ES,BX ; ES set to start of VGA
; MOV BX,0 ; BX set to pixel offset 0
; MOV CX,64000 ; CX set to number of pixels
 ; ;
 ; ClrLoop: ; Repeat
 ; MOV [ES:BX],AX ; Memory[ES:BX] := Color
 ; INC BX ; BX := BX + 1
; LOOP ClrLoop ; CX := CX â€“ 1
 ; ; Until CX = 0 
 
 
 
 
;320px wide, 200px tall, 1 byte per pixel. 
mov ax, 79 ; color palette 
MOV BX,0A000H ;
MOV ES,BX ; ES set to start of VGA
MOV BX,0 ; BX set to pixel offset 0
MOV CX, 320 ; CX set to number of pixels
 ;
 ClrLoop: ; Repeat
 MOV [ES:BX],AX ; Memory[ES:BX] := Color
 INC BX ; BX := BX + 1
LOOP ClrLoop ; CX := CX â€“ 1
 ; Until CX = 0 
 
 
 ; start:
 ; mov ax, 50
 ; push AX
 ; mov ax, 0
 ; push AX
 ; call mountain
 
 ; mountain:
; push bp
; mov bp, sp
; push AX
; push BX
; push SI
; push CX

; mov cx, [bp+6]

; mov bx, [bp+4]
; add bx, 16000
; mov ax, 0
; mov dx, 2
; mov [num1], bx




; loop1:
; mov ax, 0
; dec CX
; jz exit

; loop2:

 ; MOV [ES:BX], dx ; Memory[ES:BX] := Color
; inc Ax

; cmp ax, CX
; je here

; inc BX
; jmp loop2

; exit:

; mov ax, 0x4c00
 ; int 0x21

; here:
; mov bx, [num1]
; sub bx, 320
; add bx, 1
; mov [num1], bx
; jmp loop1











 
 
 
 mov ax, 0x4c00
 int 0x21
 
 
 
 
 
 
 
 
 
 
 
 
 


; MOV AL,Color ; AL gets the color value
 ; MOV BX,0A000H ;
; MOV ES,BX ; ES set to start of VGA
; MOV CX,64000 ; CX set to number of pixels
; MOV DI,0 ; DI set to pixel offset 0
 ; REP STOSB ; While CX <> 0 Do
 ; ; Memory[ES:DI] := AL
 ; ; DI := DI + 1
 ; ; CX := CX - 1 
 
 ; MOV AL,Color ; AL gets the color value
 ; MOV AH,AL ; Duplicate the color value
 ; MOV BX,0A000H ;
; MOV ES,BX ; ES set to start of VGA
; MOV CX,32000 ; CX set to number of words
; MOV DI,0 ; DI set to pixel offset 0
 ; REP STOSW ; While CX <> 0 Do
 ; ; Memory[ES:DI] := AX
 ; ; DI := DI + 2
 ; ; CX := CX - 1 
 
 
 
; MOV AX,0A000h
; MOV ES,AX
; MOV BL,23
; MOV AL,320 ;
; MUL BL     ;
; ADD AX,117 ; 
; MOV SI,AX
; mov dx, 4
; MOV [ES:SI],dx

 
