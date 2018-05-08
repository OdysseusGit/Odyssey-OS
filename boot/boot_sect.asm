;
; A simple boot sector that loads our kernel into memory.
;

[org 0x7c00]
KERNEL_OFFSET equ 0x1000			;the memory offset to which our kernel will be loaded

main:
	mov [BOOT_DRIVE], dl			;get the bootdrive location from dl

	mov bp, 0x9000				;set the stack sufficiently far from 0x7c00
	mov sp, bp

	mov bx, MSG_REAL_MODE			;announce that we are in 16-bit real mode
	call print_string_16

	call load_kernel			;load the kernel before we enter 32-bit protected mode
	call protected_mode			;switch to 32-bit protected mode

	jmp $					;in case something goes wrong -- hang

;various assembler routines
%include "boot/print_string_16.asm"
%include "boot/disk_load.asm"
%include "boot/protected_mode.asm"
%include "boot/global_descriptor_table.asm"
%include "boot/print_string_32.asm"

[bits 16]
load_kernel:
	mov bx, KERNEL_OFFSET			;load at our predefined offset
	mov dh, 15				;load 15 sectors (the kernel)
	mov dl, [BOOT_DRIVE]			;load from the disk
	call disk_load

	mov bx, MSG_LOAD_KERNEL			;announce that we have loaded the kernel
	call print_string_16

	ret

[bits 32]
BEGIN_PROTECTED_MODE:
	mov ebx, MSG_PROTECTED_MODE		;announce that we are in 32-bit protected mode
	call print_string_32

	call KERNEL_OFFSET			;jump to the address of the previously loaded kernel

	jmp $					;hang

;BOOT_DRIVE location initialiser
BOOT_DRIVE			db 0

;loading messages
MSG_REAL_MODE		db "Loaded 16-bit Real Mode.", 0
MSG_LOAD_KERNEL		db "Loaded the kernel into memory.", 0
MSG_PROTECTED_MODE	db "Loaded 32-bit Protected Mode.", 0

;fill the rest of the bootsector with 0s and the magic identifier number 0xaa55
times 510 - ($-$$) db 0
dw 0xaa55
