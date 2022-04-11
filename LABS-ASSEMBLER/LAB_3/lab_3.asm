.model small
stack 100h
.data
    greeting db "Input a number ",'$'
    double_dot db ": ",'$'
    array db "Your array is:",0dh,0ah,'$'
    space db " ","$"
    end_ouput db "The number which repeats the most times is: ",'$'
    error_output db "Sorry this number is too big to enter. Please enter a new one: ","$"
    error_output_number db "Sorry,there are no equal numbers in the massive",0dh,0ah,'$'

    massive dw 30 dup(0)
    minus_flag db 0         ; '0' for positive number and   '1' for negative one

    new_line db 0dh,0ah,'$'

    counter_temp dw ?
    counter_max dw ?

    number dw ?
    special_number dw 32767

.code

number_output proc near 
    push cx
    push dx


start:
    test ax, ax   ;to check whether it is negative
    jns oi1
    
    ;if it IS negative - I print '-' and take module of the number

    mov minus_flag,1
    mov cx, ax
    mov ah, 02h
    mov dl, '-'
    int 21h
    mov ax, cx
    neg ax

oi1:  
    xor cx, cx
    mov bx, 10 
oi2:
    xor dx,dx
    div bx
    push dx
    inc cx  ;amount of 'letters' in the number saving to cx

    test ax, ax
    jnz  oi2

    mov  ah, 02h
oi3:
    pop dx
    add dl, '0'
    int 21h
loop oi3

    cmp minus_flag,1
    jne go_along
    neg ax

go_along:
    mov minus_flag,0

    pop dx
    pop cx
    ret
number_output endp




new_line_output proc near

    mov ah,9
    mov dx,offset new_line
    int 21h

    ret
new_line_output endp



error_overflow proc near

    push dx

    call new_line_output

    mov ah,9
    mov dx,offset error_output
    int 21h

    pop dx

    ret
error_overflow endp





main:
    .386        ;;
    
    mov ax,@data
    mov ds,ax


    lea di,massive
    mov dx,1
    mov cx,15                        ;; 30 actually

    jmp input



overflow_special:
    

    cmp bx,1111111111111111b
    jg cool_not_minus

    jmp cool_minus

;--------------------------------------INPUT-----------------------------------------;
input:

    push dx

    mov ah,9
    mov dx,offset greeting
    int 21h

    pop dx
    mov ax,dx

    call number_output

    push dx

    mov ah,9
    mov dx,offset double_dot
    int 21h

    pop dx
    push cx
    xor bx,bx

    jmp number_to_enter

overflow:           ;in case overflow occured

    cmp minus_flag,1
    jne cool_not_minus

    jmp overflow_special
cool_minus:

    jmp number_to_enter


cool_not_minus:

    call error_overflow

    xor bx,bx

number_to_enter:

    xor al,al
    mov ah,1
    int 21h

    cmp al,'-'
    jne continue
    mov minus_flag,1
    jmp number_to_enter

continue:    
    cmp al,0dh  
    je continue_

    IMUL bx,10
    jc overflow


    sub al,'0'

    add bl,al
    jc overflow
  
    inc cx   ;just to let this cycle work

loopne number_to_enter

    jmp continue_

continue_:
    mov ax,bx

    cmp minus_flag,1
    jne continue__

    neg ax

continue__:

    mov [di],ax

    push dx
    call new_line_output

    xor ax,ax
    xor bx,bx
    mov minus_flag,0

    pop dx
    inc dx
    add di,2
    pop cx

loop input


    mov ah,9
    mov dx,offset array
    int 21h


    mov cx,15                         ;;  I can say 30 
    xor si,si

    lea si,massive

output_:

    mov ax,[si]
    call number_output

    mov ah,9
    mov dx,offset space
    int 21h

    add si,2

loop output_

    call new_line_output


    mov cx,225                        ;;;;; 900 I guess ??

    xor di,di

    xor ax,ax
    xor bx,bx
    xor dx,dx

    lea si,massive
    lea di,massive

    mov ax,[si]
    mov bx,[di]


    mov number,ax         ;;for max to start with sth 
    mov counter_temp,0
    mov counter_max,0

  
;----------------------SEARCH FOR THE NUMBER THAT REPEATS THE MOST-----------------------;

search_all:

    push cx
    mov cx,15                       ;;;;;;  CX

    mov ax,[si]
search_inside:

    mov bx,[di]
    cmp ax,bx
    je equal

    jmp continue_1

equal:
    inc counter_temp

continue_1:

    add di,2


loop search_inside

    mov bx,counter_max
    cmp counter_temp,bx
    ja found_more_often

    jmp continue_2
found_more_often:

    mov bx,counter_temp
    mov counter_max,bx
    mov ax,[si]
    mov number,ax

continue_2:


    lea di,massive
    add si,2

    mov counter_temp,0

    pop cx
    sub cx,15                            ;;;;;;  CX
    inc cx
loop search_all

;--------------------------------------FILAL OTPUT-----------------------------------------;

    cmp counter_max,1               ;I check whether every number is unique in the massive
    je one_time_for_all

    jmp ok
one_time_for_all:
    mov ah,9
    mov dx,offset error_output_number
    int 21h

    jmp end_

ok:
    mov ah,9
    mov dx,offset end_ouput
    int 21h

    mov ax,number
    call number_output

end_:
    mov ax,4C00h
    int 21h
end main
