; gdelgado@pdx.edu
; George Delgado
; part 4

extern printf			; the C function, to be called
extern scanf            ; use the C language format - ...scanf("%d")
extern srand            ; use the C language format to set rand - srand(usigned int value) ~ srand(seed_value)
extern rand             ; use the C language format - once srand sets seed value, can simply be used as rand()
extern malloc           ; use the C language format - malloc(size of array * bytes per elements) 
extern free             ; use the C language format - free(pointer to free) 
global main				; the standard gcc entry point
    
    %define ARRAY_SIZE 6                ; macro for array size ; only use if input read is less than or equal to zero
    %define SEED_DEFAULT 23             ; macro for seed ; only use if input read is less than or equal to zero
    %define MOD_DEFAULT 81              ; macro for modulo value ; only use if input read is less than or equal to zero
    %define ELEMENT_SIZE 4 ; size of element
    %define NULL 0
    %define NL 10
    %define TAB 9
    %define EXIT_SUCCESS 0

section .bss			; BSS, uninitialized identifiers
    
    array_size: resd 1      ; reserve 4-bytes for array_size
    seed_value: resd 1      ; reserve 4-bytes for seed_value
    mod_value:  resd 1      ; reserve 4-bytes for mod_value

section .data			; Data section, initialized identifiers
    
    array_ptr1: dd 0x0       ; allocate and initialize to NULL (0x0)
    array_ptr2: dd 0x0       ; allocate and initialize to NULL (0x0)
    array_ptr3: dd 0x0       ; allocate and initialize to NULL (0x0)

section .rodata         ; Read-only section, immutable identifiers
    
    array_prompt_fmt: db "Enter the number of elements in the array ", NULL ; calling printf to read in array size from user
    seed_prompt_fmt: db "Enter the seed to use for rand() ", NULL ; calling printf to read in in seed size from user
    mod_prompt_fmt: db "Enter the modulo to apply to the random numbers ", NULL ; calling printf to read in modulo value from user
    output_fmt1: db "array1:", TAB, NULL ; calling printf is the C language printf
    output_fmt2: db "array2:", TAB, NULL ; calling printf is the C language printf
    output_fmt3: db "array3:", TAB, NULL ; calling printf is the C language printf
    output_int_fmt: db "%d", TAB, NULL ;  
    output_end_fmt1: db "in reverse", TAB, NULL
    output_end_fmt2: db "array1 * array2 %% ", NULL
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

        mov eax, [ array_size ]                 ; move the value of 'array_size' into eax
        cmp eax, NULL                           ; compare eax and NULL (zero) 
        jg .seed_value                          ; if eax (array_size) greater than NULL (zero) jump to next section (.seed_value)
        mov dword [ array_size ], ARRAY_SIZE    ; else set the value of 'array_size' to the macro ARRAY_SIZE
                                        
    .seed_value:
        push dword seed_prompt_fmt
        call printf
        add esp, 4
        push seed_value
        push dword read_int_fmt
        call scanf
        add esp, 8
                                                ; The following sets up rand by setting a constant seed using srand 
        mov eax, [ seed_value ]
        cmp eax, NULL
        jg .mod_value                           ;; else clause 
        mov dword [ seed_value ], SEED_DEFAULT  ; set the value of seed value to the default seed value

   .mod_value:
        push dword mod_prompt_fmt
        call printf
        add esp, 4
        push mod_value
        push dword read_int_fmt
        call scanf
        add esp, 8

        mov eax, [ mod_value ]
        cmp eax, NULL
        jg malloc_array
        mov dword [ mod_value ], MOD_DEFAULT

malloc_array:
    mov eax, array_size
    imul eax, ELEMENT_SIZE
    push eax
    call malloc
    mov [ array_ptr1 ], eax
    add esp, 4

    mov eax, array_size
    imul eax, ELEMENT_SIZE
    push eax
    call malloc
    mov [ array_ptr2 ], eax
    add esp, 4

    mov eax, array_size
    imul eax, ELEMENT_SIZE
    push eax
    call malloc
    mov [ array_ptr3 ], eax
    add esp, 4

set_seed:
    mov eax, [ seed_value ]
    push eax
    call srand
    add esp, 4

mov ebx, [ array_ptr1 ]
mov edi, 0
mov ecx, [ array_size ]
assign_array1:
    push ecx
    call rand
    idiv dword [ mod_value ]
    mov dword [ ebx + edi * ELEMENT_SIZE ], edx
    pop ecx
    inc edi
    loop assign_array1


push dword output_fmt1
call printf
add esp, 4
mov edi, 0
mov eax, [ ebx ]
mov ecx, [ array_size ]
print_array1:
    push ecx
    push eax
    push dword output_int_fmt
    call printf
    add esp, 8
    pop ecx
    inc edi
    mov eax, [ ebx + edi * ELEMENT_SIZE ]
    loop print_array1

mov esi, [ array_ptr3 ]
mov ebx, [ array_ptr2 ]
mov edi, 0
mov ecx, [ array_size ]
assign_array2:
    push ecx
    call rand
    idiv dword [ mod_value ]
    mov dword [ ebx + edi * ELEMENT_SIZE ], edx
    mov dword [ esi + edi * ELEMENT_SIZE ], edx ; sets up array3 with array2 values
    pop ecx
    inc edi
    loop assign_array2

push NL_fmt
call printf
push dword output_fmt2
call printf
add esp, 8
mov edi, 0
mov eax, [ ebx ]
mov ecx, [ array_size ]
print_array2:
    push ecx
    push eax
    push dword output_int_fmt
    call printf
    add esp, 8
    pop ecx
    inc edi
    mov eax, [ ebx + edi * ELEMENT_SIZE ]
    loop print_array2

push NL_fmt
call printf
push dword output_fmt2
call printf
add esp, 8
mov edi, [ array_size ]
dec edi
mov eax, [ ebx + edi * ELEMENT_SIZE ]
mov ecx, [ array_size ]
print_array2_reverse:
    push ecx
    push eax
    push dword output_int_fmt
    call printf
    add esp, 8
    pop ecx
    dec edi
    mov eax, [ ebx + edi * ELEMENT_SIZE ]
    loop print_array2_reverse
    push dword output_end_fmt1
    call printf
    add esp, 4

mov edi, 0
mov ecx, [ array_size ]
mov ebx, [ array_ptr3 ]
mov esi, [ array_ptr1 ]
mult_array3:
    push ecx
    mov eax, [ ebx + edi * ELEMENT_SIZE ]
    mov edx, [ esi + edi * ELEMENT_SIZE ]  ; causes seg fault
    imul edx  
    mov dword [ ebx + edi * ELEMENT_SIZE ], eax
    pop ecx
    inc edi
    loop mult_array3

mov edi, 0
mov ecx, [ array_size ]
assign_array3:
    push ecx
    mov eax, [ ebx + edi * ELEMENT_SIZE ]
    mov edx, 0
    idiv dword [ mod_value ]
    mov [ ebx + edi * ELEMENT_SIZE ], edx
    pop ecx
    inc edi
    loop assign_array3

push NL_fmt
call printf
push dword output_fmt3
call printf
add esp, 8
mov edi, 0
mov eax, [ ebx ]
mov ecx, [ array_size ]
print_array3:
    push ecx
    push eax
    push dword output_int_fmt
    call printf
    add esp, 8
    pop ecx
    inc edi
    mov eax, [ ebx + edi * ELEMENT_SIZE ]
    loop print_array3
    
    push dword output_end_fmt2
    call printf
    add esp, 4
    mov eax, [ mod_value ]
    push eax
    push dword output_int_fmt
    call printf
    add esp, 8

push NL_fmt
call printf
add esp, 4
free_memory:
    push dword [ array_ptr1 ]
    call free
    push dword [ array_ptr2 ]
    call free
    push dword [ array_ptr3 ]
    call free
    add esp, 12
    

;;; use code below for testing purposes
;mov eax, [ array_size ]
;mov ebx, [ seed_value ]
;mov edx, [ mod_value ]
;    .print_test:
;        push edx
;        push ebx
;        push eax
;        push dword test_fmt
;        call printf
;        add esp, 16
;;; use code above for testing purposes

	; Don't change or remove the lines of code in here  |
	mov	esp, ebp		    ; takedown stack frame		|
	pop	ebp				    ;							|
						    ;							|
	mov	eax, EXIT_SUCCESS   ; no error return value		|
	ret					    ; return					|
	; Don't change or remove the lines of code in here  |
