; Convert the following C++ codes in assembly language.
; Part A: Determine the Smallest Number:
; int p = 42;
; int q = 18;
; int r = 30;
; int smallest;
; if (p < q) {
; if (p < r) {
; smallest = p;
; } else {
; smallest = r;
; }
; } else {
; if (q < r) {
; smallest = q;
; } else {
; smallest = r;
; }
; }


[org 0x0100] 

jmp start  

p:dw 42
q:dw 18
r:dw 30
start:
mov ax,[p]
cmp ax,[q]
jl n1
jge n2

swapP:
mov ax,[p]
ret

swapQ:
mov ax,[q]
ret

swapR:
mov ax,[r]
ret

n1:
cmp ax,[r]
jl swapP
jge swapR

n2:
mov ax,[q]
cmp ax,[r]
jge swapR

mov ax, 0x4c00 
int 0x21