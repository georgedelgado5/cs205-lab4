; gdelgado@pdx.edu
; George Delgado
; part 1

extern printf			; the C function, to be called
global main				; the standard gcc entry point
    
    %define ARRAY_SIZE 35 ; macro for array size
    %define ELEMENT_SIZE 2 ; size of element
    %define NULL 0
    %define NL 10
    %define TAB 9
    %define EXIT_SUCCESS 0

section .bss			; BSS, uninitialized identifiers
    
    array: resw ARRAY_SIZE ; uninitialized array of 35 2-byte values

section .data			; Data section, initialized identifiers

section .rodata         ; Read-only section, immutable identifiers

    fmt: db "Index: %2d   Value: %3hd", NL, NULL ; calling printf is the C language printf

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
    ; short array[35]; // 2-bytes per index
    ; for(int i = 0, value = 3; i < 35; i++, value += 4) {
    ;       array[i] = value;
    ; }

mov ebx, array          ; move the address of array into ebx register
mov edi, 0              ; set edi (destination index) to zero ; will be used to increment the array index
mov ax, 3               ; set a 2-byte register (sub register of eax - ax - to the value of 3)
mov ecx, ARRAY_SIZE     ; set the counter register, ecx, to the array size (35) ; using the reserved word 'loop' will decrement ecx

assign_array:
   mov word [ ebx + edi * ELEMENT_SIZE ], ax    ; equivalent to example in arrays  ; '*' binds tighter than '+'
   add ax, 4                                    ; increment ax by 4
   inc edi                                      ; increment edi ; this is moving through the array indices
   loop assign_array                            ; jumps back to the the 'assign_array' label unti ecx is zero - this is our looping command

mov edi, 0              ; reset edi to zero ; iterates through array indices and print
mov eax, [ ebx ]
mov ecx, ARRAY_SIZE     ; reset ecx to zero ; used to print index numeric labels
print_array:
    push ecx                                ; printf uses ecx so we need to push ecx onto stack to store the value of ecx
                                            ; if using another register instead ecx, I think push/pop ecx can be avoided
    push eax                                ; pushing for value string
    push edi                                ; pushing for index string
    push dword fmt                          ; pushing string format
    call printf
    add esp, 12                             ; clean stack from the last 3 push calls 
    pop ecx                                 ; IMPORTANT: need to pop ecx because printf used ecx
    inc edi                                 ; incrementing edi ; this is our index value
    mov eax, [ ebx + edi * ELEMENT_SIZE ]   ; placing the value referenced at index array address into eax
    loop print_array                        ; jumps back to the 'print_array' label until ecx is zero 

	; Don't change or remove the lines of code in here  |
	mov	esp, ebp		    ; takedown stack frame		|
	pop	ebp				    ;							|
						    ;							|
	mov	eax, EXIT_SUCCESS   ; no error return value		|
	ret					    ; return					|
	; Don't change or remove the lines of code in here  |
