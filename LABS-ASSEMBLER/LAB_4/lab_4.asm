.model small

stack 100h

.data
 graph0  db 0Dh,0Ah,'$'
 graph1  db "+++++++++++++++++++++++++",0Dh,0Ah,'$'
 graph2  db "++         +++       T ++",0Dh,0Ah,'$'
 graph3  db "++    ++   B    ++     ++",0Dh,0Ah,'$'
 graph4  db "++  T    ++++++    ++  ++",0Dh,0Ah,'$'
 graph5  db "++                     ++",0Dh,0Ah,'$'
 graph6  db "++  +++       ++++     ++",0Dh,0Ah,'$'
 graph7  db "++      ++++     T   ++++",0Dh,0Ah,'$'
 graph8  db "++  T                  ++",0Dh,0Ah,'$'
 graph9  db "++++      ++++++       ++",0Dh,0Ah,'$'
 graph10 db "++                  +++++",0Dh,0Ah,'$'
 graph11 db "++                     ++",0Dh,0Ah,'$'
 graph22 db "++           P         ++",0Dh,0Ah,'$'

 pdirx db 0 
 pdiry db 1

 gdir1x db 0
 gdir1y db 0
    
 mainposx   db 13
 mainposy   db 21

 ghost1posx db 4
 ghost2posx db 4
    
 ghost1posy db 21
 ghost2posy db 22

.code

print_line proc    
    mov ah,13h
    mov al,0
    mov dl,0
    inc dh
    mov bl,00000111b
    mov cx,25    
    int 10h
    ret
print_line endp

Ghost1cmp proc   
   mov ch,[mainposy]
   mov cl,[mainposx]
   ox1:
   cmp ch,dh   
   ja godown1
   je oy1
   dec dh
   mov ah,2
   int 10h
   mov ah,8
   int 10h
   inc dh
   cmp al,'P'
   je endgam
   cmp al,'+'
   je oy1
   dec dh
   ret
   godown1:
   inc dh
   mov ah,2
   int 10h
   mov ah,8
   int 10h 
   dec dh
   cmp al,'P'
   je endgam
   cmp al,'+'  
   je oy1
   inc dh
   ret
   oy1:
   cmp cl,dl  
   ja goright
   dec dl
   mov ah,2
   int 10h
   mov ah,8
   int 10h
   inc dl
   cmp al,'P'
   je endgam
   cmp al,'+'  
   je skip5
   dec dl
   ret
   goright:
   inc dl
   mov ah,2
   int 10h
   mov ah,8
   int 10h 
   dec dl
   cmp al,'P'
   je endgam
   cmp al,'+'   
   je skip5
   inc dl
   ret
   endgam:
   call endgame
   skip5: 
   ret
Ghost1cmp endp
Ghost1mov proc
   mov cx,1
   mov dh,[ghost1posx]
   mov dl,[ghost1posy]
   mov ah,2
   int 10h 
   ;mov ah,9
   ;mov al,'�'
   ;int 10h
   call Ghost1cmp
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'T'
   int 10h
   mov [ghost1posx],dh
   mov [ghost1posy],dl
   ret
Ghost1mov endp
Ghost2mov proc
   mov cx,1
   mov dh,[ghost2posx]
   mov dl,[ghost2posy]
   mov ah,2
   int 10h 
   ;mov ah,9
   ;mov al,'�'
   ;int 10h
   call Ghost1cmp
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'G'
   int 10h
   mov [ghost2posx],dh
   mov [ghost2posy],dl
   ret
Ghost2mov endp

respawn proc
    lea si,ghost1posx
    mov dh,[si]
    lea si,ghost2posx
    mov dl,[si]
    cmp dh,dl
    jne skip6 
    lea si,ghost1posy
    mov dh,[si]
    lea si,ghost2posy
    mov dl,[si]
    cmp dh,dl
    jne skip6
    mov dh,11
    mov dl,12
    mov [ghost1posx],dh
    mov [ghost1posx],dl
    skip6:
    ret
respawn endp

Pmov proc
   call ReadInput
   mov cx,0
   mov dx,50000
   mov ah,86h
   int 15h
   mov cx,1
   mov dh,[mainposy]
   mov dl,[mainposx]
   mov ah,2
   int 10h 
   mov ah,9
   mov al,20h
   int 10h
   add dh,pdiry
   add dl,pdirx
   mov ah,2
   int 10h
   mov ah,8
   int 10h
   cmp al,'+'
   jne can 
   cant:
   sub dh,pdiry
   sub dl,pdirx
   mov dh,[mainposy]
   mov dl,[mainposx]
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'P'
   int 10h
   ret
   can:
   mov [mainposy],dh
   mov [mainposx],dl
   ;cmp al,'�'
   ;jne skip1
   ;call scorep
   skip1:
   cmp al,'T'
   jne skip2
   call endgame   
   skip2:  
   mov ah,9
   mov al,'P'
   int 10h 
   ret
Pmov endp

clear proc
    s1:
    mov ah,1
    int 16h
    jz s2
    mov ah,0
    int 16h    
    jmp s1
    s2:
    ret
clear endp
endgame proc
    ;xor al,al
    ;lea bp,endmsg
    ;mov dl,4
    ;mov dh,23
    ;mov ah,13h
    ;mov cx,16
    ;int 10h
    ;mov ah,2
    ;int 21h
    mov ah,00
    mov al,03h
    int 10h
    mov ax, 4c00h 
    int 21h
    ret 
endgame endp
ReadInput proc
    mov cx,0
    mov dx,50000
    mov ah,86h
    int 15h    
    mov ah,1
    int 16h
    jz notpressed
    xor ah,ah
    int 16h
    arrowup:
    cmp al,'w'
    jne arrowdown
    lea si,pdirx
    mov al,0
    mov [si],al
    lea si,pdiry
    mov al,-1
    mov [si],al
    jmp notpressed
    arrowdown:
    cmp al,'s'
    jne arrowright
    lea si,pdirx
    mov al,0
    mov [si],al
    lea si,pdiry
    mov al,1
    mov [si],al
    jmp notpressed
    arrowright:
    cmp al,'d'
    jne arrowleft
    lea si,pdirx
    mov al,1
    mov [si],al
    lea si,pdiry
    mov al,0
    mov [si],al
    jmp notpressed
    arrowleft:
    cmp al,'a'
    lea si,pdirx
    mov al,-1
    mov [si],al
    lea si,pdiry
    mov al,0
    mov [si],al   
    notpressed:
    call clear
    ret
ReadInput endp  
main:
    mov ax,@data
    mov ds,ax
    mov es, ax
    add sp,2
    mov bp,sp

    ;mov dh,0
    mov ax,03h
    int 10h

    lea bp,graph0
    call print_line      
    lea bp,graph1
    call print_line
    lea bp,graph2
    call print_line
    lea bp,graph3
    call print_line
    lea bp,graph4
    call print_line
    lea bp,graph5
    call print_line
    lea bp,graph6
    call print_line
    lea bp,graph7
    call print_line
    lea bp,graph8
    call print_line
    lea bp,graph9
    call print_line
    lea bp,graph10
    call print_line
    lea bp,graph11
    call print_line
    lea bp,graph10
    call print_line
    lea bp,graph9
    call print_line
    lea bp,graph10
    call print_line
    lea bp,graph11
    call print_line
    lea bp,graph6
    call print_line
    lea bp,graph5
    call print_line
    lea bp,graph10
    call print_line
    lea bp,graph6
    call print_line
    lea bp,graph22
    call print_line
    lea bp,graph1
    call print_line   

phase2:    
    call Pmov

    mov cx,0
    mov dx,50000
    mov ah,86h
    int 15h
    call Ghost1mov

    mov cx,0
    mov dx,50000
    mov ah,86h
    int 15h
    ;call Ghost2mov

    call respawn
    
    jmp phase2
end:
    mov ax,4C00h
    int 21h
end main