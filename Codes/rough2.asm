[org 0x0100]
jmp start

platform1index: dw 0
platform2index: dw 100
platform3index: dw 400

start:

infloop:

call removeBricks

jmp infloop




removeBricks:;-------start of removebricks

mov ax,0xb800
mov es,ax

mov ax, 0x0720


mov di, [platform1index]
mov cx, 15
rep stosw

mov di, [platform2index]


mov cx, 15
rep stosw

mov di, [platform3index]
mov cx, 15
rep stosw


ret;------------end of removebricks