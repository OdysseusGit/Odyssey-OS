;
; A routine that switches from 16-bit Real Mode to 32-bit Protected Mode.
;

[bits 16]
protected_mode:
	cli										;temporarily switch off cpu interrupts as the BIOS' 16-bit routines will no longer work

	lgdt [gdt_descriptor]					;load the global descriptor table using the gdt_descriptor meta-information

	mov eax, cr0
	or eax, 0x1								;set the first bit of cr0 -- a control register
	mov cr0, eax							;update the control register

	jmp CODE_SEGMENT:init_protected_mode	;jump into a new segment (flushing the CPU cache) to our 32-bit initialisation process

[bits 32]
init_protected_mode:						;initialise the registers and the stack
	mov ax, DATA_SEGMENT					;now in protected mode, point our segement registers to the data selector defined in the gdt
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000						;move the stack position to the top of the free space
	mov esp, ebp

	call BEGIN_PROTECTED_MODE				;return to boot_sect in protected mode