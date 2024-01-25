[org 0x0100]




shl quad [num1], 1
rcl quad [num1+2], 1

mov ax, [num1]

mov ax, 0x4c00
int 0x21

num1: dq 0x9c40ffffffffffff