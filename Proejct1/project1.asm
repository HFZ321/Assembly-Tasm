.model small
.stack 100h
.data
msg db '---------------------------',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '---------------------------',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '---------------------------',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '---------------------------',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '      |      |      |      ',0ah,0dh
	db '---------------------------',0ah,0dh
	db 'use up, down, left, right arrow to play',0ah,0dh
	db 'press q or Q to exit the game',0ah,0dh,'$'
Cursor_row db ?
Cursor_col db ?
count dw 2
values dw 16 dup(0)
upcol dw 4
.code

	;initial code
	
	mov ah, 00h ;set the configuration to video mode 
	mov al, 13h ;choose the video mode
	int 10h ;execute the configuration
	
	mov ax, @data
	mov ds, ax
	
	mov ah, 9
	lea dx, msg
	int 21h
	
	mov word ptr [values + 10], 1
	mov word ptr [values + 12], 1
	jmp start
	
	
print_values:
	mov word ptr [Cursor_row], 2
	mov word ptr [Cursor_col], 2
	mov ax, [values]
	call printnum
	
	mov word ptr [Cursor_row], 2
	mov word ptr [Cursor_col], 9
	mov ax, [values + 2]
	call printnum
	
	mov word ptr [Cursor_row], 2
	mov word ptr [Cursor_col], 16
	mov ax, [values + 4]
	call printnum
	
	mov word ptr [Cursor_row], 2
	mov word ptr [Cursor_col], 23
	mov ax, [values + 6]
	call printnum
	
	mov word ptr [Cursor_row], 5
	mov word ptr [Cursor_col], 2
	mov ax, [values + 8]
	call printnum
		
	mov word ptr [Cursor_row], 5
	mov word ptr [Cursor_col], 9
	mov ax, [values + 10]
	call printnum
		
	mov word ptr [Cursor_row], 5
	mov word ptr [Cursor_col], 16
	mov ax, [values + 12]
	call printnum
		
	mov word ptr [Cursor_row], 5
	mov word ptr [Cursor_col], 23
	mov ax, [values + 14]
	call printnum
	
	mov word ptr [Cursor_row], 8
	mov word ptr [Cursor_col], 2
	mov ax, [values + 16]
	call printnum
	
	mov word ptr [Cursor_row], 8
	mov word ptr [Cursor_col], 9
	mov ax, [values + 18]
	call printnum
	
	mov word ptr [Cursor_row], 8
	mov word ptr [Cursor_col], 16
	mov ax, [values + 20]
	call printnum
	
	mov word ptr [Cursor_row], 8
	mov word ptr [Cursor_col], 23
	mov ax, [values + 22]
	call printnum
	
	mov word ptr [Cursor_row], 11
	mov word ptr [Cursor_col], 2
	mov ax, [values + 24]
	call printnum
		
	mov word ptr [Cursor_row], 11
	mov word ptr [Cursor_col], 9
	mov ax, [values + 26]
	call printnum
		
	mov word ptr [Cursor_row], 11
	mov word ptr [Cursor_col], 16
	mov ax, [values + 28]
	call printnum
		
	mov word ptr [Cursor_row], 11
	mov word ptr [Cursor_col], 23
	mov ax, [values + 30]
	call printnum
	ret

set_cursor:
	mov  ah, 02h  ;SetCursorPosition
	mov  dh, [Cursor_row]   ;Row
	mov  dl, [Cursor_col]   ;Column
	mov  bh, 00h  ;Display page
	int  10h
	ret

printchar:
	mov ah,02h
    int 21h
	ret
printnum:
	sub cx,cx
	mov bx, 10
l1:
	sub dx, dx
	idiv bx
	push dx
	inc cx
	or ax, ax
	jnz l1
	call set_cursor
l2:
	pop dx
	add dx, '0'
	call printchar
	loop l2
	ret
up:
	mov bx, 8
	call up_loop
	mov bx, 10
	call up_loop
	mov bx, 12
	call up_loop
	mov bx, 14
	call up_loop
	ret
up_loop:
	mov cx, 2
up_col:
	cmp values[bx - 8], 0 ;if previous equal to zero, then switch the values
	je up_switch
	
	mov ax,values[bx]
	cmp values[bx - 8], ax ;if previous number is same, add number
	je up_add
up_update:
	cmp cx, 0
	je up_next
	sub cx, 1
	add bx, 8
	jmp up_col
up_switch:
	mov ax, values[bx - 8]
	mov dx, values[bx]
	mov values[bx - 8], dx
	mov values[bx],ax
	jmp up_update
up_add:
	mov ax, values[bx - 8]
	add ax, ax
	mov values[bx - 8], ax
	mov values[bx], 0	
	jmp up_update

up_next:
	cmp values[bx], 0
	jne up_exit
	mov values[bx], 1
up_exit:	
	call print_values
	ret
	
down:
	mov bx, 16
	call down_loop
	mov bx, 18
	call down_loop
	mov bx, 20
	call down_loop
	mov bx, 22
	call down_loop
	ret
down_loop:
	mov cx, 2
down_col:
	cmp values[bx + 8], 0 ;if previous equal to zero, then switch the values
	je down_switch
	
	mov ax,values[bx]
	cmp values[bx + 8], ax ;if previous number is same, add number
	je down_add
down_update:
	cmp cx, 0
	je down_next
	sub cx, 1
	sub bx, 8
	jmp down_col
down_switch:
	mov ax, values[bx + 8]
	mov dx, values[bx]
	mov values[bx + 8], dx
	mov values[bx],ax
	jmp down_update
down_add:
	mov ax, values[bx + 8]
	add ax, ax
	mov values[bx + 8], ax
	mov values[bx], 0	
	jmp down_update

down_next:
	cmp values[bx], 0
	jne down_exit
	mov values[bx], 1
down_exit:	
	call print_values
	ret

left:
	mov bx, 2
	call left_loop
	mov bx, 10
	call left_loop
	mov bx, 18
	call left_loop
	mov bx, 26
	call left_loop
	ret
left_loop:
	mov cx, 2
left_col:
	cmp values[bx - 2], 0 ;if previous equal to zero, then switch the values
	je left_switch
	
	mov ax,values[bx]
	cmp values[bx - 2], ax ;if previous number is same, add number
	je left_add
left_update:
	cmp cx, 0
	je left_next
	sub cx, 1
	add bx, 2
	jmp left_col
left_switch:
	mov ax, values[bx - 2]
	mov dx, values[bx]
	mov values[bx - 2], dx
	mov values[bx],ax
	jmp left_update
left_add:
	mov ax, values[bx - 2]
	add ax, ax
	mov values[bx - 2], ax
	mov values[bx], 0	
	jmp left_update

left_next:
	cmp values[bx], 0
	jne left_exit
	mov values[bx], 1
left_exit:	
	call print_values
	ret

right:
	mov bx, 4
	call right_loop
	mov bx, 12
	call right_loop
	mov bx, 20
	call right_loop
	mov bx, 28
	call right_loop
	ret
right_loop:
	mov cx, 2
right_col:
	cmp values[bx + 2], 0 ;if previous equal to zero, then switch the values
	je right_switch
	
	mov ax,values[bx]
	cmp values[bx + 2], ax ;if previous number is same, add number
	je right_add
right_update:
	cmp cx, 0
	je right_next
	sub cx, 1
	sub bx, 2
	jmp right_col
right_switch:
	mov ax, values[bx + 2]
	mov dx, values[bx]
	mov values[bx + 2], dx
	mov values[bx],ax
	jmp right_update
right_add:
	mov ax, values[bx + 2]
	add ax, ax
	mov values[bx + 2], ax
	mov values[bx], 0	
	jmp right_update

right_next:
	cmp values[bx], 0
	jne right_exit
	mov values[bx], 1
right_exit:	
	call print_values
	ret


start:
	call print_values
again:


	mov ah,01
	int 16h ; when ah = 01 zero flag is set when keyboard is pressed
	jz again ;if key is not pressed

	mov ah, 00h ; al contains the ascii character
	int 16h	; ah contains the scan key
	
	cmp al,'q'
	je exit
	cmp al,'Q'
	je exit
	
	cmp ah, 48h ; up arroy key
	je call_up
	cmp ah, 50h ;down arroy key
	je call_down
	cmp ah, 4Dh ;right arrow key
	je call_right
	cmp ah, 4Bh ;left arrow key
	je call_left
call_up:
	call up
	jmp again
call_down:
	call down
	jmp again
call_right:
	call right
	jmp again
call_left:
	call left
	jmp again
exit:	
	mov ah, 4ch
	int 21h
end
