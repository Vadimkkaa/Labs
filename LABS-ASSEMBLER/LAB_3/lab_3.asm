.model small
stack 100h
.data
    greeting db "Input a number ",'$'
    double_dot db ": ",'$'
    end_of_greeting db " numbers to enter left",0dh,0ah,'$'
    end_ouput db "The number which repeats the most times is: ",0dh,0ah,'$'

    massive dw 30 dup(0)
    minus_flag db 0         ; '0' for positive number and   '1' for negative one

    new_line db 0dh,0ah,'$'

.code

number_output proc near 
    push cx
    push dx

    cmp minus_flag,1
    je set_to_neg
    jmp start

set_to_neg:
    neg ax
  ;  mov ax,cx    I guess I don't need it 

start:
    test ax, ax   ;to check whether it is negative
    jns oi1
    
    ;if it IS negative - I print '-' and take module of the number

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

    pop dx
    pop cx
    ret
number_output endp









main:
    .386
    
    mov ax,@data
    mov ds,ax

    mov cx,8
    mov si,1



input:
    mov ah,9
    mov dx,offset greeting
    int 21h

    mov ax,si
    call number_output

    mov ah,9
    mov dx,offset double_dot
    int 21h

    push cx

    xor bx,bx

number_enter:

    xor al,al
    mov ah,1
    int 21h

    cmp al,'-'
    jne continue
    mov minus_flag,1

continue:    
    cmp al,0dh  
    je continue_
    IMUL bx,10

    sub al,'0'

    add bl,al
    inc cx   ;just to let this cycle work

loopne number_enter

continue_:
    mov ax,bx
    
    call number_output
    ;;  INPUT INTO MASSIVE + ACCRODING TO MINUS_FLAG(just use neg to the register)

    mov ah,9
    mov dx,offset new_line
    int 21h

    xor ax,ax
    xor bx,bx
    mov minus_flag,0

    pop cx
    inc si
loop input



end_:
    mov ax,4C00h
    int 21h
end main
