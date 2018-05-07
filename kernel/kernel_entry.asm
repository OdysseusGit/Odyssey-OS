;
; A small utility that ensures we enter our kernel at the correct place.
;

global _start;
[bits 32]
_start:
[extern kernel_main]				;declare that we will be referencing an external function name
call kernel_main					;invoke kernel_main() from kernel.c