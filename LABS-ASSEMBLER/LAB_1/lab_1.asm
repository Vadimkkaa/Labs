; hello_world!.asm

	.model small 
	.stack 100h 
	.code 
start:
	mov ax,DGROUP 
	mov ds,ax 
	mov dx,offset message
	mov ah,9
	int 21h
	mov dx,offset message_1
	mov ah,9
	int 21h
	mov ax,4C00h
	int 21h 
	.data 
message db "Hello World!",0Dh,0Ah,'$'
message_1 db "By guys!!",0Dh,0Ah,'$'
	end start