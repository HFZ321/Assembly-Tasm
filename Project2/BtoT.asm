.model small
.stack 100h
.data
infile db "binary.exe",0
outfile db "output.txt",0
buffer db 3 dup (?), 13,10,"$"
msg db "error", 13,10,"$"
three db 24 dup('0'),13,10, '$'
four dw 4 dup (?), '$'
in_handle dw ?
out_handle dw ?
n Dw 2
index dw 0
Inum dw ?
.code

mov ax,@data
mov ds,ax
jmp start

numtohex:	
	sub dx, dx
	idiv N
	cmp dx, 0
	jnz one
	cmp ax, 0
	jz end3
	sub bx,1
	jmp numtohex
	one:
	mov three[bx], '1'
	sub bx, 1
	jmp numtohex
	end3:
	cmp dx, 0
	jz skip
	mov three[bx], '1'
	skip:
	ret

turn_four:
	mov ax, 1
	mov cx, 6
	sub dx,dx
	loop2:
	cmp cx, 0
	je end2

	cmp three[bx], '1'
	je one1 

	sub bx, 1
	sub cx, 1
	add ax, ax
	jmp loop2
	one1:
	add dx, ax
	add ax, ax
	sub bx, 1
	sub cx, 1
	jmp loop2
	end2:
	mov bx, index
	add dx, 40
	mov four[bx], dx
	ret
bin64:
	mov bx, 23
	sub ax, ax
	mov al, buffer[2]
	call numtohex
	
	mov bx, 15
	sub ax, ax
	mov al, buffer[1]
	call numtohex
	
	mov bx, 7
	sub ax, ax
	mov al, buffer[0]
	call numtohex
	
	mov bx, 5
	call turn_four
	add index, 1
	mov bx, 11
	call turn_four
	add index, 1
	mov bx, 17
	call turn_four
	add index, 1
	mov bx, 23
	call turn_four
	ret
clear:
	mov bx,23
	loop3:
	mov three[bx], '0'
	cmp bx,0
	je end4
	sub bx, 1
	jmp loop3
end4:
	mov index, 0
	ret
	
check:
	cmp ax, 1
	je pad1
	cmp ax, 2
	je pad2
	mov Inum, 4
	jmp end5
	pad1:
	mov Inum, 2
	jmp end5
	pad2:
	mov Inum, 3
end5:
	ret
err1:
mov ah, 09
lea dx, msg
int 21h
mov ax,4cffh
int 21

start:
;open file
mov ax,3d00h 
lea dx, infile
int 21h
jc err1
mov in_handle, ax

;create output file
mov ah,3Ch 
sub cx, cx
lea dx, outfile
int 21h
JC err1
MOV out_handle,AX

again: 
;read from the input file
mov ah, 3fh 
mov bx, in_handle
mov cx, 3
lea dx, buffer
int 21h
JC err1
call check
;jump if it is end of the file
or ax,ax
JZ end1

call bin64


;write to the output file
mov ah, 40h
mov bx, out_handle

mov cx, Inum
lea dx, four
int 21h
JC err1
call clear

jmp again

end1:
mov ah,3eh
mov bx,in_handle
int 21h
jc err1
mov ah,3eh

mov bx, out_handle
int 21h
jc err1

mov ah, 4ch
int 21h
end
