[org 0x0100]

jmp start

num1: dq 0x00FFFFDFFFFEFFFE
num2: dq 0xFF00000200001001
res:  dq 0x0000000000000000

start:
mov si, num1
mov di, num2

mov ax, [si+7]

