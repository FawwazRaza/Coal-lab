 ; Initialize AX with last 4 digits of your roll number (for example, if your roll number is 16L1105 then AXshould be initialized with 1105). Store AX in BX. Make a memory variable f, initialize it with 
; 0 and compute
; F = (A||B) && (A⊙0x1BCD)
; || is bitwise OR operation, && is bitwise AND operation whereas ⊙ is bitwise XOR operation.

[org 0x100]
jmp start
    File:dw 0
    roll: dw 0x7548

start:
    mov ax, [roll]  
    mov bx, ax      
    or bx, ax            
    xor ax, 1BCDh     
    and ax, bx        
    mov [File],ax  
mov ax,0x4c00
int 0x21
