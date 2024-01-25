[org 0x0100]




;two nested loops, outer loop points to i and inner points to i+1 at start and goes till the end while i remains the same.
;sum is calculated and stored in dx alongwith the index of i , compared with previous sum. sum var is updated if necessary
;at the end sum has the index of starting element of max size sub array, that index is used to fill up arr2


;si points to first arr1 first index bx gives the index while incrementing 2
;di points to the next element after si at the beginning
;outer loop increases si by 2 
; inner loop si is same and di is increased by 2, summing all the consecutive elemtns
;affter inner loop is compl sum is checked with prev sum and if greater sum is updated
;when bx has reached last element program is finished and sum contains the sum of largest sub array and index of the starting element of that subarray in arr1
;using the data it is then copied to arr2



jmp start

arr1: dw -2,-3,4,-1,2 ,1, 5 ,-3
;arr1: dw 0,1,2,3,4,5,6,7
arr2: dw 0,0,0,0,0,0,0,0
siz: dw 8
sum: dw 0, 0 ; stores the max and the index of starting element

start:

mov si, arr1
mov bx, 0
mov di, arr1
add di, 2 ; pointing to si+1 index
mov ax, [arr1]
mov [sum], ax ; sum stores the first element of arr1 initially

mov cx, [siz]

outerloop:
push cx
dec cx
jz movetoarr2


innerloop:
mov ax, [si+bx]
add ax, [di]
add dx, ax
add di, 2


loop innerloop
cmp dx, [sum]
jg greater
back:
add bx, 2
mov di, bx
add di, arr1
mov dx, 0

pop cx
loop outerloop

movetoarr2:
mov ax, [sum+2]
mov si, arr1
add si, ax
shr ax,1
mov cx, [siz]
sub cx, ax
dec cx
mov di, arr2



arr2loop:
mov ax, [si]
mov [di], ax

add si, 2
add di, 2

loop arr2loop
jmp exit


greater:
mov [sum], dx
mov [sum+2], bx
jmp back


exit:
mov ax, 0x4c00
int 0x21


