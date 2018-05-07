;
; A global descriptor table (gdt) and gdt descriptor.
; N.B., for now we only pretend to understand this file.
;

gdt_start:

gdt_null:						;null descriptor - the gdt starts with a null 8 bytes
	dd 0x0
	dd 0x0

gdt_code:						;code descriptor
	dw 0xffff					;segment length (bits 0-15)
	dw 0x0						;segment base (bits 0-15)
	db 0x0						;segment base (bits 16-23)
	db 10011010b				;first flags; type flags (present:1 privilege:00 descriptor_type:1; code:1 conforming:0 readable:1 accessed:0)
	db 11001111b				;second flags (granularity:1 32-bit_default:1 64-bit_segment:0 AVL:0)
	db 0x0						;segment base (bits 24-31)

gdt_data:						;data descriptor
	dw 0xffff					;segment length (bits 0-15)
	dw 0x0						;segment base (bits 0-15)
	db 0x0						;segment base (bits 16-23)
	db 10010010b				;first flags; type flags (present:1 privilege:00 descriptor_type:1; code:0 expand_down:0 writable:1 accessed:0)
	db 11001111b				;second flags (granularity:1 32-bit_default:1 64-bit_segment:0 AVL:0)
	db 0x0						;segment base (bits 24-31)

gdt_end:						;end of the gdt

;gdt descriptor meta-information
gdt_descriptor:
	dw gdt_end - gdt_start - 1	;size (one less than its true size)
	dd gdt_start				;start address

;definitions to help us initialise 32-bit protected mode
CODE_SEGMENT equ gdt_code - gdt_start
DATA_SEGMENT equ gdt_data - gdt_start