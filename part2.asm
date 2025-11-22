; gdelgado@pdx.edu
; George Delgado
; part 2

extern printf			; the C function, to be called
global main				; the standard gcc entry point
    
    %define ARRAY_SIZE 23 ; macro for array size
    %define LAST_INDEX ARRAY_SIZE - 1  ; macro for index minus one size
    %define ELEMENT_SIZE 4 ; size of element
    %define NULL 0
    %define NL 10
    %define TAB 9
    %define EXIT_SUCCESS 0

section .bss			; BSS, uninitialized identifiers
    
    array: resd ARRAY_SIZE ; uninitialized array of 23 4-byte values

section .data			; Data section, initialized identifiers

section .rodata         ; Read-only section, immutable identifiers

    fmt: db "Index: %2d   Value: %3d", NL, NULL ; calling printf is the C language printf

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
    ; int array[35]; // 4-bytes per index
    ; for(int i = 0, value = -200; i < 23; i++, value -= 3) {
    ;       array[i] = value;
    ; }

mov ebx, array          ; move the address of array into ebx register
mov edi, 0              ; set edi (destination index) to zero ; will be used to increment the array index
mov eax, -200           ; set eax to the intital value - which is '-200'
mov ecx, ARRAY_SIZE     ; set the counter register, ecx, to the array size (23) ; using the reserved word 'loop' will decrement ecx

assign_array:
   mov dword [ ebx + edi * ELEMENT_SIZE ], eax  ; equivalent to example in arrays  ; '*' binds tighter than '+'
   sub eax, 3                                   ; decrement eax by 4
   inc edi                                      ; increment edi ; this is moving through the array indices
   loop assign_array                            ; jumps back to the the 'assign_array' label unti ecx is zero - this is our looping command

mov edi, LAST_INDEX                             ; set edi to LAST_INDEX (22) ; iterates through array indices and print backwards ; from 22 -> 0
mov eax, [ ebx + edi * ELEMENT_SIZE ]           ; 
mov ecx, ARRAY_SIZE                             ; reset ecx to ARRAY_SIZE (23); used to print index numeric labels ; printing index sting labels backwards
print_array:
    push ecx                                ; printf uses ecx so we need to push ecx onto stack to store the value of ecx
                                            ; if using another register instead ecx, I think push/pop ecx can be avoided
    push eax                                ; pushing for value string
    push edi                                ; pushing for index string
    push dword fmt                          ; pushing string format
    call printf
    add esp, 12                             ; cleaning up stack from the 3 push calls 
    pop ecx                                 ; IMPORTANT: need to pop ecx because printf used ecx
    dec edi                                 ; decrmenting edi ; this is our index value
    mov eax, [ ebx + edi * ELEMENT_SIZE ]   ; placing the value referenced at index array address into eax
    loop print_array                        ; jumps back to the 'print_array' label until ecx is zero 

	; Don't change or remove the lines of code in here  |
	mov	esp, ebp		    ; takedown stack frame		|
	pop	ebp				    ;							|
						    ;							|
	mov	eax, EXIT_SUCCESS   ; no error return value		|
	ret					    ; return					|
	; Don't change or remove the lines of code in here  |
