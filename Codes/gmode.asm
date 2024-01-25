[org 0x0100]

mov ax, 0013h ;change mode to graphics mode
int 10h

MOV BX,0A000H 
MOV ES,BX

MOV CX, 100 ;writing 100 pixels
mov al, 2 ;number of color in color palette https://en.wikipedia.org/wiki/Mode_13h#/media/File:VGA_palette_with_black_borders.svg
mov di, 320*50 ;1st row 0 to 319(320) pixels in one row. 

rep stosb

