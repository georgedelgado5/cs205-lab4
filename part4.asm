; gdelgado@pdx.edu
; George Delgado

extern printf			; the C function, to be called
global main				; the standard gcc entry point
    %define ARRAY_SIZE 35 ; macro for array size
    %define NULL 0
    %define NL 10
    %define TAB 9
    %define EXIT_SUCCESS 0

section .bss			; BSS, uninitialized identifiers

section .data			; Data section, initialized identifiers

section .rodata         ; Read-only section, immutable identifiers

section .text			; Code section.

main:					; the program label for the entry point
	; Don't change or remove the lines of code in here  |
	push ebp			; set up stack frame			|
	mov ebp, esp		;								|
	; Don't change or remove the lines of code in here	|


	; 
	; Your NASM code will go in here
	;

    ;
    ; C code for array from lab pdf
    ;
    ; 
    ; 
    ; 
    ;


	; Don't change or remove the lines of code in here  |
	mov	esp, ebp		    ; takedown stack frame		|
	pop	ebp				    ;							|
						    ;							|
	mov	eax, EXIT_SUCCESS   ; no error return value		|
	ret					    ; return					|
	; Don't change or remove the lines of code in here  |
