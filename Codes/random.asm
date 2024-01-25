[org 0x0100]



jmp start


PRN: dw 0

start:


MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
INT     1AH
mov     [PRN], dx
call    CalcNew   ; -> AX is a random number
xor     dx, dx
mov     cx, 9 
div     cx        ; here dx contains the remainder - from 0 to 9
add     dl, '0'   ; to ascii from '0' to '9'
mov     ah, 02h   ; call interrupt to display a value in DL
int     21h    
call    CalcNew   ; -> AX is another random number
jmp exit

; ----------------
; inputs: none  (modifies PRN seed variable)
; clobbers: DX.  returns: AX = next random number
CalcNew:
    mov     ax, 25173          ; LCG Multiplier
    mul     word  [PRN]     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     [PRN], ax          ; Update seed = return value
    ret
	
	
	
	
	
	exit:
	mov ax, 0x4c00
	int 0x21
	