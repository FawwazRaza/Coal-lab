[org 0x0100]

loop:         in     al,61h            ;  Read current port mode B (8255)
         mov    cl,al             ;  Save current mode
         or     al,3              ;  Switch on speaker and timer
         out    61h,al            ;
         
		 mov    al,0B6h           ;  set for channel  2 (8253)
         out    43h,al            ;  command register  8253
         
		 mov    dx,14h            ;
         mov    ax,4F38h          ;  divisor of frequency
         div    di                ;
         out    42h,al            ;  lower byte of frequency
         
		 mov    al,ah             ;
         out    42h,al            ;  higher byte of frequency

         in     al,61h            ;  Read mode of port B (8255)
         mov    al,cl             ;  Previous mode 
         and    al,0FCh           ;
         out    61h,al            ;  Restore mode
		 
		 jmp loop
mov ax, 0x4c00 ; terminate program
int 0x21