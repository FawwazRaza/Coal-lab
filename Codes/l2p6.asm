 ; Complete the following table:
; Register Default associated segment Flexible (yes/no)
; BX, SI, DI
; IP
; BP
; SP
; b) If BX= FFFE then what will be the effective logical address for [bx+0003h]?
; c) If BX=0100h (some logical address in Data Segment), DS=FFF0h (base address of data 
; segment). Then what will be the physical address generate by [bx+0x0100]?
; d) How the following data will look like in the memory:
; 1. dw 5
; 2. dw 0A0Bh
; 3. dd: 0A0B0C0D






a)DS  YES
  CS  NO
  SS  YES
  SS  NO

b)0001h

c)00100

d)0500
  0B0A
  0D0C0B0A