;
; A 32-bit routine that print the null-terminating string ebx.
;

[bits 32]
print_string_32:
	pusha						;push all registers to the stack
	mov edx, VIDEO_MEMORY		;set edx to be the first character cell

print_loop_32:
	mov al, [ebx]				;copte the character at ebx to al
	mov ah, WHITE_ON_BLACK		;copy the character attribute to ah

	cmp al, 0					;if the character is 0, finish printing
	je print_done_32

	mov [edx], ax				;write the character, with its attributes, to the currect character cell

	add ebx, 1					;incremement ebx to get the next character in the string
	add edx, 2					;move to the next character cell
	jmp print_loop_32			;repeat the print loop

print_done_32:
	popa
	ret

;video constants
VIDEO_MEMORY equ 0xb8000		;video memory starting position
WHITE_ON_BLACK equ 0x0f			;character attribute