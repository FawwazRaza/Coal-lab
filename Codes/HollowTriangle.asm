
; Write a Subroutine ‘HollowTriangle’, that takes 3 parameters on stack
; 1. Memory address of the character to be printed to form a triangle
; 2. Starting row of the triangle
; 3. Ending row of the triangle
; The subroutine then prints the outline of a triangle, using the character specified in memory. It will start in the 
; middle of the screen from the row mentioned as starting row and goes down to the ending row. Starting row will 
; have only one character in it, in the middle of the screen - Column 40. All the rows between the starting and 
; ending row will have two characters in them, with a certain number of spaces between the two characters, 
; number of spaces will depend on row number. For example, the second row (of the triangle) will have one space; 
; the third row will have three and so on. The ending row will be a row of the character.
; Example:
; Character: db ‘%’
; StartingRow: db 5
; EndingRow: db 11
; 5               %
; 6            %     %
; 7          %         %
; 8        %             %
; 9      %                %
; 10   %                    %
; 11 % % % % % % % % % % % % %

[org 0x0100]
jmp Main
Char
db '%'
StartingRow
dw 10
EndingRow
dw 20

clrscr: 
push es
push ax
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column
nextloc: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 4000 ; has the whole screen cleared
jne nextloc ; if no clear next position
pop di
pop ax
pop es
ret

HollowTriangle:
mov dx,0
mov ax,0xb800
mov es,ax
mov ax,160
mul word [StartingRow]
mov di,ax
add di,80
mov cl,[Char]
mov ch,0x07
mov word[es:di],cx
mov bx,2
mov ax,[StartingRow]
inc ax

LoopForRight:
add di,160
add di,bx
mov word[es:di],cx
dec ax
jnz LoopForRight
mov ax,1

LoopForBaseLine:
sub di,2
mov word[es:di],cx
inc ax
cmp ax,[EndingRow]
jne LoopForBaseLine

mov ax,160
mul word [StartingRow]
mov di,ax
add di,80
mov bx,2
mov ax,[StartingRow]
inc ax

LoopForLeft:
add di,160
sub di,bx

mov word[es:di],cx
dec ax
jnz LoopForLeft

ret

Main:
call clrscr
mov al,[Char]
mov ax,0x07
push ax
push word [EndingRow]
mov ax,[StartingRow]
dec ax
mov [StartingRow],ax
push word [StartingRow]
call HollowTriangle


exit:
mov ax,0x4c00
int 0x21
