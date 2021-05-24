.model small
.stack 100h
.data
infile db "output.txt",0
outfile db "transfer.exe",0
buffer db 4 dup (?), '$'
msg db "error", 13,10,"$"
four db 24 dup('0'), '$'
three dw 3 dup (?) , '$'
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
	mov four[bx], '1'
	sub bx, 1
	jmp numtohex
	end3:
	cmp dx, 0
	jz skip
	mov four[bx], '1'
	skip:
	ret
turn_three:
	mov ax, 1
	mov cx, 8
	sub dx,dx
	loop2:
	cmp cx, 0
	je end2

	cmp four[bx], '1'
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
	mov three[bx], dx
	ret
	
bin64:
	mov bx, 23
	sub ax, ax
	mov al, buffer[3]
	sub ax, 40
	call numtohex
	
	mov bx, 17
	sub ax, ax
	mov al, buffer[2]
	sub ax, 40
	call numtohex
	
	mov bx, 11
	sub ax, ax
	mov al, buffer[1]
	sub ax, 40
	call numtohex
	
	mov bx, 5
	sub ax, ax
	mov al, buffer[0]
	sub ax, 40
	call numtohex
	
	mov bx, 7
	call turn_three
	add index, 1
	mov bx, 15
	call turn_three
	add index, 1
	mov bx, 23
	call turn_three
	ret
clear:
	mov bx,23
	loop3:
	mov four[bx], '0'
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
	cmp ax, 3
	je pad3
	mov Inum, 3
	jmp end5
	pad1:
	mov Inum, 0
	jmp end5
	pad2:
	mov Inum, 1
	jmp end5
	pad3:
	mov Inum, 2
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
mov cx, 4
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
lea dx, three
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