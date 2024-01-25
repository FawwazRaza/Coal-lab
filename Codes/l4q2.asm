; : [Extended Multiplication] Write a program to multiply two 32-bit numbers and store the
; answer in a 64-bit location.
; Sample Run:
; a: dq 0xABCDD4E1 ; dq allocates 64-bit memory space. a is 32-bit number but
; it has space allocation of 64 bits
; b: dd 0xAB5C32
; result: dq 0x0
; ; 32-bit space for multiplier
; ; result should be 0x73005CB8FF6FF2 verify on calculator
; programmer’s view

[org 0x0100] 
jmp start
 
multiplicand:dd 0xABCDD4E1,0
multiplier: dd 0xAB5C32,0 
result: dq 0.0
start:
     mov cx, 32 
     mov dx, [multiplier]   
	 
checkbit:
     shr dx, 1
     jnc skip 
	 
     mov ax, [multiplicand] 
     add [result], ax 
     mov ax, [multiplicand + 2] 
     adc [result + 2], ax 
	 
	 mov ax, [multiplicand + 4] 
     adc [result + 4], ax 
     mov ax, [multiplicand + 6] 
     adc [result + 6], ax 
	 
skip:
      shl word [multiplicand], 1 
      rcl word [multiplicand+2], 1 
	  rcl word [multiplicand+4], 1
	  rcl word [multiplicand+6], 1
   
	  ;shl bx,1
	  dec cx
	  jnz checkbit
 mov ax, 0x4c00 
 int 0x21