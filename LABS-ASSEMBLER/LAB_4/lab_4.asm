.model small
.586
stack 100h

.data
 graph0  db 0Dh,0Ah,'$'
 graph1  db "1111111111111111111111111",0Dh,0Ah,'$'
 graph2  db "11         111       T 11",0Dh,0Ah,'$'
 graph3  db "11    11   B    11     11",0Dh,0Ah,'$'
 graph4  db "11       111111    11  11",0Dh,0Ah,'$'
 graph5  db "11                     11",0Dh,0Ah,'$'
 graph6  db "11  111       1111     11",0Dh,0Ah,'$'
 graph7  db "11      1111         1111",0Dh,0Ah,'$'
 graph8  db "11                     11",0Dh,0Ah,'$'
 graph9  db "1111      111111       11",0Dh,0Ah,'$'
 graph10 db "11                  11111",0Dh,0Ah,'$'
 graph11 db "11                     11",0Dh,0Ah,'$'
 graph22 db "11           P         11",0Dh,0Ah,'$'
             ;<<>d3Od0>�><ddOM-���1
 message_ db "Not 4",0dh,0ah,'$'  
 message_hit db "Hit!!",0dh,0ah,'$'
 win_or_not db 0
 winner db "Gongratulations!",0dh,0ah,'$'
 enemies_amount db 3

 pdirx db 0 
 pdiry db 1

 direction db 1
 bulletdirx db 0
 bulletdiry db 1
 bulletposx db 0
 bulletposy db 0

 gdir1x db 0
 gdir1y db 0
    
 mainposx   db 13
 mainposy   db 21

 ghost1posx db 4
 ghost1posy db 21

 ghost2posx db 6
 ghost2posy db 6

 ghost3posx db 7
 ghost3posy db 18

 ghost4posx db 7
 ghost4posy db 8

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
  ; mov ch,[mainposy]
   ;mov cl,[mainposx]

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
   cmp al,'1'
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
   cmp al,'1'  
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
   cmp al,'1'  
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
   cmp al,'1'   
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

   ;mov dh, ghost1posy
   ;mov dl, ghost1posx

   mov dh,[ghost1posx]
   mov dl,[ghost1posy]

   mov ah,2
   int 10h 
   mov ah,9
   mov al,' '
   int 10h
   call Ghost1cmp
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'T'
   int 10h

   ;mov ghost1posy,dh
   ;mov ghost1posx,dl

   mov [ghost1posx],dh
   mov [ghost1posy],dl

   ret
Ghost1mov endp
Ghost2mov proc
   mov cx,1

   ;mov dh, ghost2posy
   ;mov dl, ghost2posx

   mov dh,[ghost2posx]
   mov dl,[ghost2posy]

   mov ah,2
   int 10h 
   mov ah,9
   mov al,' '
   int 10h
   call Ghost1cmp
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'T'
   int 10h

   ;mov ghost2posy,dh
   ;mov ghost2posx,dl

   mov [ghost2posx],dh
   mov [ghost2posy],dl
   ret
Ghost2mov endp

Ghost3mov proc
   mov cx,1

   ;mov dh, ghost2posy
   ;mov dl, ghost2posx

   mov dh,[ghost3posx]
   mov dl,[ghost3posy]

   mov ah,2
   int 10h 
   mov ah,9
   mov al,' '
   int 10h
   call Ghost1cmp
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'T'
   int 10h

   ;mov ghost2posy,dh
   ;mov ghost2posx,dl

   mov [ghost3posx],dh
   mov [ghost3posy],dl
   ret
Ghost3mov endp

Ghost4mov proc
   mov cx,1

   ;mov dh, ghost2posy
   ;mov dl, ghost2posx

   mov dh,[ghost4posx]
   mov dl,[ghost4posy]

   mov ah,2
   int 10h 
   mov ah,9
   mov al,' '
   int 10h
   call Ghost1cmp
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'T'
   int 10h

   ;mov ghost2posy,dh
   ;mov ghost2posx,dl

   mov [ghost4posx],dh
   mov [ghost4posy],dl
   ret
Ghost4mov endp

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
   cmp al,'1'
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
   cmp al,'B'
   jne skip1
   mov win_or_not,1
   call endgame
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
    mov ah,00
    mov al,03h
    int 10h

    cmp win_or_not,1
    jne final

    mov ah,9
    mov dx,offset winner
    int 21h
final:

    mov ax, 4c00h 
    int 21h
    ret 
endgame endp
ReadInput proc
    mov cx,0
    mov dx,50000
    mov ah,86h

                    ;;;;;TEMP
   ; mov al,' '                
    ;jmp shoot;;;;               
    
     
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
    mov direction, 1    ;; for shooting
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
    mov direction, 3    ;; for shooting
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
    mov direction, 4    ;; for shooting
    jmp notpressed
arrowleft:
    cmp al,'a'
    jne shoot
    lea si,pdirx
    mov al,-1
    mov [si],al
    lea si,pdiry
    mov al,0
    mov [si],al   
    mov direction, 2    ;; for shooting
    jmp notpressed

shoot:
    cmp al,' '
    jne notpressed
    push ax
    call shooting
    pop ax

    notpressed:
    call clear
    ret
ReadInput endp  




shooting proc
    push cx
    mov cx,1

    mov al,mainposx
    mov bulletposx,al
    mov al,mainposy
    mov bulletposy,al

    cmp direction,1
    ja next
    lea si,bulletdirx
    mov al,0
    mov [si],al
    lea si,bulletdiry
    mov al,-1
    mov [si],al
    jmp real_bullet_shooting

next:

    cmp direction,2
    ja next_1
    lea si,bulletdirx
    mov al,-1
    mov [si],al
    lea si,bulletdiry
    mov al,0
    mov [si],al
    jmp real_bullet_shooting

next_1:

    cmp direction,3
    ja next_2
    lea si,bulletdirx
    mov al,0
    mov [si],al
    lea si,bulletdiry
    mov al,1
    mov [si],al
    jmp real_bullet_shooting

next_2:
    cmp direction,4
    jne temp
    lea si,bulletdirx
    mov al,1
    mov [si],al
    lea si,bulletdiry
    mov al,0
    mov [si],al
    jmp real_bullet_shooting

temp:
jmp end_


real_bullet_shooting:  

   mov dh,[bulletposy]
   mov dl,[bulletposx]
   mov ah,2
   int 10h 
   mov ah,9
   mov al,20h
   int 10h
   add dh,bulletdiry
   add dl,bulletdirx

   cmp dl,20
   jae cant_

   mov ah,2
   int 10h
   mov ah,8
   int 10h
   cmp al,'1'
   jne can_ 
cant_:
   sub dh,bulletdiry
   sub dl,bulletdirx
   mov dh,[bulletposy]
   mov dl,[bulletposx]
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'P'
   int 10h
   mov cx,0
   ;jmp loop_end

can_:
   mov [bulletposy],dh
   mov [bulletposx],dl
   inc cx
   ;cmp al,'�'
   ;jne skip1
   ;call scorep
skip1_:
   cmp al,'T'
   jne skip2_


   jmp go_next

go_up:
    jmp real_bullet_shooting

go_next:

   mov ah,2
   mov dx,0
   int 10h

   mov ah,9
    mov dx,offset message_hit
    int 21h

    dec enemies_amount
   ;sub dh,bulletdiry
   ;sub dl,bulletdirx

   mov dh,[bulletposy]
   mov dl,[bulletposx]
   mov ah,2
   int 10h
   mov cx,1
   mov ah,9
   mov al,'P'
   int 10h

   mov ah,9
   mov al,' '
   int 10h 

skip2_:  
   mov ah,9
   mov al,'.'
   int 10h 

   ;dec dx
   ;mov ah,2
   ;int 10h
   ;mov al,' '
   ;mov ah,9
   ;int 10h
loop go_up

;;
    pop cx
    ret
end_:

    mov ah,2
    mov dx,0
    int 10h

    mov ah,9
    mov dx,offset message_
    int 21h
    pop cx
    ret
shooting endp





main:
    mov ax,@data
    mov ds,ax
    mov es, ax
    sub sp,2
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

    ;mov cx,0
    ;mov dx,50000
    ;mov ah,86h
    ;int 15h 

    call Pmov

    cmp enemies_amount,0
    jne go_further
    mov win_or_not,1
    jmp endgame
go_further:

    mov cx,0
    mov dx,50000
    mov ah,86h
    int 15h

    cmp enemies_amount,1
    jb phase2
    call Ghost1mov

    mov cx,0
    mov dx,50000
    mov ah,86h
    int 15h

    cmp enemies_amount,2
    jb phase2
    call Ghost4mov

    mov cx,0
    mov dx,50000
    mov ah,86h
    int 15h

    cmp enemies_amount,3
    jb phase2
    call Ghost3mov
    ;call respawn
    
    
    jmp phase2
end:
    mov ax,4C00h
    int 21h
end main
