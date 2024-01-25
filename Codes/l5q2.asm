; Write a subroutine to take a difference of two arrays and store result in the same array.


[org 0x100]
jmp start
    array1 db 4, 2, 3, 4, 5  ; First array
    array2 db 3, 1, 2, 4, 5  ; Second array
    array_size equ 5          

start:
   
    call calculate_difference

mov ax,0x4c00
int 0x21

calculate_difference:
    xor cx, cx           ; Clear the loop counter
    mov si, cx;
    loop_start:
        mov al, [array1 + si]  ; Load element from array1
        sub al, [array2 + si]  ; Subtract corresponding element from array2
        mov [array1 + si], al  ; Store the difference back in array1
        inc si                ; Increment loop counter
        cmp si, array_size    ; Compare with array size
        jl loop_start       
    ret