 ; [Bit Manipulation] Calculate the number of one bits in BX and complement an 
; equal number of least significant bits in AX using MASK. HINT: Use the XOR instruction.
; Sample Run:
; Initial value of BX Total No of 1
; Bits in BX
; Initial value of AX AX after Complementing 7
; least significant bits
; 1011 0001 1000 1001 7 1010 1011 1010 0101 1010 1011 1101 1010

[org 0x0100]

mov bx, 0xB189
mov ax, 0xABA5
mov cx, 16
mov dx, 0

checking:
ror bx, 1
jc counting

decrement:
dec cx
jnz checking
jmp done

counting:
rcl dx, 1
jmp decrement

done:
xor ax, dx


mov ax, 0x4c00
int 0x21