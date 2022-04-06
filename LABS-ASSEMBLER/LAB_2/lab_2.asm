.model small
stack 100h

.data
    buffer db 200 dup(?), '$'

    greeting db "Input a string pls", 0Dh,0Ah,'$'   
    greeting_delete_a_word db "Hey,let's input a string to delete",0dh,0Ah,'$'
    show_string db "Your string is: ",'$'
    show_string_to_delete db "Your string to delete is: ",'$'
    found_the_word db "Your symbol is: ",'$'

    delete_word db ?

    no_words_like_that db "Sorry, you have not entered this-> word! :(",0dh,0ah,'$'
    new_line db 0Dh,0Ah,'$'

    word_size dw ?
.code
start:
    mov ax,DGROUP
    mov ds,ax
    mov dx,offset greeting
    mov ah,9
    int 21h
    mov cx,200
    xor si,si ; to make index equal 0

loop_for_enter:  
    mov ah,1
    int 21h
    mov buffer[si],al
    inc si
    cmp al,0dh  
loopne loop_for_enter

    cmp buffer[1],0
    je jump_to_end

    mov dx,offset new_line
    mov ah,9
    int 21h

    jmp before_word_to_delete
output_string:
    mov ah,2
    mov dl,buffer[si]
    int 21h
    inc si
    cmp buffer[si],0dh
loopne output_string

before_word_to_delete:
    
    mov dx,offset greeting_delete_a_word
    mov ah,9
    int 21h

    mov cx,200
    xor si,si

word_to_delete:
    mov ah,1
    int 21h
    mov delete_word[si],al
    inc si
    cmp al,0dh

loopne word_to_delete    


    dec si
    mov cx,si
    mov si,0
    jmp temp ;;;;;;;;;;;;  

    mov dx,offset new_line
    mov ah,9
    int 21h

    lea dx,show_string_to_delete
    mov ah,9
    int 21h

output_delete:
    mov ah,2
    mov dl,delete_word[si]
    int 21h
    inc si
    cmp delete_word[si],0dh
loopne output_delete

temp:

    mov word_size,cx
    mov cx,200
    xor si,si

    xor bx,bx 
    xor dx,dx
    jmp cycle_all

jump_to_end:
    jmp _end


cycle_all:
    cmp buffer[si],0dh
    je no_match_next

    mov  al,delete_word[bx]
    cmp  buffer[si],al
    je equal

    xor bx,bx
    inc si
    xor dx,dx
    xor ax,ax    
    jmp cycle_all

equal:
    inc dx
    inc bx
    inc si
    xor ax,ax    

    cmp dx,word_size
    je found

    jmp cycle_all

found:
    cmp buffer[bx],' '
    
    sub si,word_size
    mov bx,si               ;index of the start of the word to delete in the main string
    jmp string_to_rewrite

loopne cycle_all


string_to_rewrite:

    mov bx,si
    mov cx,200
    mov si,word_size

    mov al,' '
    cmp buffer[bx+si],al
    je move_one_symbol
    

    mov buffer[bx],0dh
    inc bx
    mov buffer[bx],'$'
    xor ax,ax
    jmp output_

no_match_next:
    jmp no_match


rewrite_string:

    mov al,buffer[bx+si]
    mov buffer[bx],al

    cmp buffer[bx],0dh
    je continue
    inc bx
   
loopne rewrite_string


continue:
    inc bx
    mov buffer[bx],'$'
    xor dx,dx

output_:

    mov ah,9
    mov dx,offset new_line
    int 21h

    mov ah,9
    mov dx,offset show_string
    int 21h

    mov ah,9
    mov dx,offset buffer
    int 21h

    jmp _end

move_one_symbol:
    inc si
    xor ax,ax
    jmp rewrite_string

no_match:
    mov ah,9
    mov dx,offset no_words_like_that
    int 21h

_end:
    mov ax,4C00h
    int 21h
end start  
