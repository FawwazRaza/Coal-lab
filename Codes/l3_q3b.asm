; Temperature Classification:
; int temperature = 78;int
; classification;
; if
; (temperature < 0) { classification =1; //
; Freezing
; } else if (temperature >= 0 && temperature < 25) {classification = 2; //
; Cold
; } else if (temperature >= 25 && temperature < 70) {classification = 3;
; // Moderate
; }
; else 
; { classification = 4; // Hot
; }
[org 0x0100] 

jmp start  
tmp:db 78
clf:db 0

start:
cmp byte [tmp],0
jl c1

cmp byte [tmp],25
jl c2

cmp byte [tmp],70
jl c3

mov byte [clf],4
jmp end

c1:
   mov byte [clf],1
   ret

c2:
   mov byte [clf],2
   ret
c3:
   mov byte [clf],3
   ret
end:
mov ax, 0x4c00 
int 0x21