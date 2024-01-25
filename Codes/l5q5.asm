; : Write a subroutine multiply that receive two unsigned 8-bit integers and return product of 
; them in back the 16-bit result. Don’t use mul command write you own multiply code.
; Write a subroutine series that receive two arrays and size of array (assume both arrays are same size), 
; then it compute S = ∑ 𝑎(𝑘) ∗ 𝑏(𝑘)
; 𝑛−1
; 𝑘=0
; , use your multiply subroutine to multiply. then return ‘S’ to 
; your main function. . (Assume your ‘S’ never exceed from 16 bits and is a local variable).
; Write the main program that pass two arrays and size to series subroutine then get the ‘S’ and save in 
; CX. 
; Do not use registers for passing arguments to the sub-routine. You may use a register for returning 
; value from a sub-routine.

[org 0x0100]
    push arrsize  
    push array2    
    push array1
    call serie      ; Call the subroutine
    add sp, 6        ; Clean up the stack
    
   

serie:
    push bp
    mov bp, sp       
    mov cx, 0        

    loop_start:
        mov al, [bp + 6] 
        mov bl, [bp + 2]  
        call mult     ; Call multiply subroutine
        add cx, ax        
        inc bp            
        dec byte [bp - 1] 
        jnz loop_start    

    pop bp
    ret

mult:
    xor ax, ax
    mov cx, 8
    mov bl, [bp + 2]    

mulloop:
    add al, bl         
    dec cx             
    jnz mulloop  
    ret


 mov ax, 0x4c00
    int 0x21

 array1 db 1, 2, 3, 4, 5  
    array2 db 5, 4, 3, 2, 1 
    arrsize equ 5