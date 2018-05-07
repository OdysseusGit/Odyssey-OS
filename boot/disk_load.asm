;
; A routine that loads dh sectors from dl (our disk) to bx (memory).
;

disk_load:
	pusha						;push all registers to the stack
	push dx						;store dx so we can later check we have loaded the correct number of sectors

	mov ah, 0x02				;BIOS read sector interrupt
	mov al, dh					;read dh sectors

	mov ch, 0x00				;cylinder 0
	mov dh, 0x00				;head 0
	mov cl, 0x02				;start reading from the second sector (i.e., after the boot sector)

	int 0x13					;BIOS interrupt
	jc disk_error				;check for error carry flags

	pop dx						;restore dx from the stack
	cmp al, dh					;check we read the correct number of sectors
	jne disk_error

	popa						;restore all registers
	ret

disk_error:
	mov bx, DISK_ERROR_MSG		;print DISK_ERROR_MSG
	call print_string_16
	jmp $

;error messages
DISK_ERROR_MSG: db "Error reading disk.", 0