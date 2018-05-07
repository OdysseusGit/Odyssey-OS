;
; A 16-bit routine that prints the null-terminating string bx using BIOS interrupts.
;

print_string_16:
	pusha						;push all registers to the stack

print_loop_16:
	mov al, [bx]				;copy the character at bx to al

	cmp al, 0					;if the character is 0, finish printing
	je print_done_16

	mov ah, 0x0e				;BIOS teletype interrupt
	int 0x10					;print the character at al

	add bx, 1					;iterate through bx
	jmp print_loop_16			;repeat the print loop

print_done_16:
	popa						;restore all registers
	ret