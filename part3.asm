; gdelgado@pdx.edu
; George Delgado
; part 3

extern printf			; the C function, to be called
extern scanf            ; the C function, to be called
extern srand            ; the C function, to be called ; lab requires user input therefore we can use srand instead
extern rand             ; the C function, to be called
extern malloc           ; the C function, to be called
global main				; the standard gcc entry point
    
    %define ARRAY_SIZE 9 ; macro for array size ; only use if input read is less than or equal to zero
    %define SEED_DEFAULT 17 ; macro for seed ; only use if input read is less than or equal to zero
    %define MOD_DEFAULT 93 ; macro for modulo value ; only use if input read is less than or equal to zero
    %define LAST_INDEX ARRAY_SIZE - 1  ; macro for index minus one size
    %define ELEMENT_SIZE 4 ; size of element
    %define NULL 0
    %define NL 10
    %define TAB 9
    %define EXIT_SUCCESS 0

section .bss			; BSS, uninitialized identifiers
    
    array_size: resd 1 ; reserve 4-bytes for array_size
    seed_value: resd 1 ; reserve 4-bytes for seed_value
    mod_value:  resd 1 ; reserve 4-bytes for mod_value
    array: resd ARRAY_SIZE ; uninitialized array of 9 4-byte values

section .data			; Data section, initialized identifiers

section .rodata         ; Read-only section, immutable identifiers
    
    array_prompt_fmt: db "Enter the number of elements in the array ", NULL ; calling printf to read in array size from user
    seed_prompt_fmt: db "Enter the seed to use for rand() ", NULL ; calling printf to read in in seed size from user
    mod_prompt_fmt: db "Enter the modulo to apply to the random numbers ", NULL ; calling printf to read in modulo value from user
    output_fmt1: db "array1:", TAB, NULL ; calling printf is the C language printf
    output_fmt2: db "%3d", TAB, NULL ;  
    NL_fmt: db "", NL, NULL
    test_fmt: db "array_size: %2d       seed_value: %2d     modulo: %2d", NL, NULL ; test format call
    read_int_fmt: db "%d", NULL

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
    ; int *array; // 4-bytes per index
    ; array = malloc(array_size * <bytes_per_element>);
    ; for(int i = 0; i < array_size; i++) {
    ;       array[i] = rand() % mode_value;
    ; }

read_data:
    .array_size: 
        push dword array_prompt_fmt             ; push prompt message onto stack 
        call printf                             ; calls printf and prompts the user with message
        add esp, 4                              ; clean stack from previous call
        push array_size                         ; push array_size variable onto stack
        push dword read_int_fmt                 ; push scanf format onto stack ; format must be in C language
        call scanf                              ; calls scanf and reads in value
        add esp, 8                              ; clean stack from previous 2 calls
        push NL_fmt                             ; push newline format onto stack
        call printf                             ; calls printf and prints newline
        add esp, 4                              ; clean stack from previous call

        mov eax, [ array_size ]                 ; move the value of 'array_size' into eax
        cmp eax, NULL                           ; compare eax and NULL (zero) 
        jg .seed_value                          ; if eax (array_size) greater than NULL (zero) jump to next section (.seed_value)
        mov dword [ array_size ], ARRAY_SIZE    ; else set the value of 'array_size' to the macro ARRAY_SIZE
                                        
                 ; follow the same process for seed and modulo value
    .seed_value:
        push dword seed_prompt_fmt
        call printf
        add esp, 4
        push seed_value
        push dword read_int_fmt
        call scanf
        add esp, 8
        push NL_fmt
        call printf
        add esp, 4
        
        mov eax, [ seed_value ]
        cmp eax, NULL
        jg .mod_value
        mov dword [ seed_value ], SEED_DEFAULT

   .mod_value:
        push dword mod_prompt_fmt
        call printf
        add esp, 4
        push mod_value
        push dword read_int_fmt
        call scanf
        add esp, 8
        push NL_fmt
        call printf
        add esp, 4

        mov eax, [ mod_value ]
        cmp eax, NULL
        jg .done
        mov dword [ mod_value ], MOD_DEFAULT

        .done:

;; use code below for testing purposes
mov eax, [ array_size ]
mov ebx, [ seed_value ]
mov edx, [ mod_value ]
    .print_test:
        push edx
        push ebx
        push eax
        push dword test_fmt
        call printf
        add esp, 16
;; use code above for testing purposes

;mov ebx, array          ; move the address of array into ebx register
;mov edi, 0              ; set edi (destination index) to zero ; will be used to increment the array index
;mov eax, -200           ; set eax to the intital value - which is '-200'
;mov ecx, ARRAY_SIZE     ; set the counter register, ecx, to the array size (23) ; using the reserved word 'loop' will decrement ecx
;
;assign_array:
;   mov dword [ ebx + edi * ELEMENT_SIZE ], eax  ; equivalent to example in arrays  ; '*' binds tighter than '+'
;   sub eax, 3                                   ; decrement eax by 4
;   inc edi                                      ; increment edi ; this is moving through the array indices
;   loop assign_array                            ; jumps back to the the 'assign_array' label unti ecx is zero - this is our looping command
;
;mov edi, LAST_INDEX                             ; set edi to LAST_INDEX (22) ; iterates through array indices and print backwards ; from 22 -> 0
;mov eax, [ ebx + edi * ELEMENT_SIZE ]           ; 
;mov ecx, ARRAY_SIZE                             ; reset ecx to ARRAY_SIZE (23); used to print index numeric labels ; printing index sting labels backwards
;print_array:
;    push ecx                                ; printf uses ecx so we need to push ecx onto stack to store the value of ecx
;                                            ; if using another register instead ecx, I think push/pop ecx can be avoided
;    push eax                                ; pushing for value string
;    push edi                                ; pushing for index string
;    push dword array_fmt                          ; pushing string format
;    call printf
;    add esp, 12                             ; cleaning up stack from the 3 push calls 
;    pop ecx                                 ; IMPORTANT: need to pop ecx because printf used ecx
;    dec edi                                 ; decrmenting edi ; this is our index value
;    mov eax, [ ebx + edi * ELEMENT_SIZE ]   ; placing the value referenced at index array address into eax
;    loop print_array                        ; jumps back to the 'print_array' label until ecx is zero 

	; Don't change or remove the lines of code in here  |
	mov	esp, ebp		    ; takedown stack frame		|
	pop	ebp				    ;							|
						    ;							|
	mov	eax, EXIT_SUCCESS   ; no error return value		|
	ret					    ; return					|
	; Don't change or remove the lines of code in here  |
