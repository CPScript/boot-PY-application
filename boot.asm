; Here we are in assembly!
; This program will display a simple string, which must be NULL terminated in order to properly 
; find the length of it.

; First of all, we need to define the base.
org 0x7c00 ; The base of the program
bits 16    ; 16 bits

; Now let's write our main entrypoint!
start:
	call cls ; Call the CLS function!
	mov bx, display ; Store our message in the BX register
	

; This function will print a string!
; Arguments:
;  BX: The string to print, must be NULL terminated
; Requirements:
;  cls must have been called
print:
	mov al, [bx] ; Dereference the BX string pointer, in C this would look like: al = *bx;
	cmp al, 0 ; Check if the character is a NULL terminator
	je halt ; If it is, jump to the halt function
	call print_char ; Print the current character
	inc bx ; Increase the BX string pointer, in C this would look like: bx++;
	jmp print ; Loop until null terminator found

; This function will be used to print a single characters!
; Arguments:
;  AL: The character to print
print_char:
	mov ah, 0x0e ; Write character function
	int 0x10 ; BIOS interrupt
	ret ; Return


; Returns from the print function
halt:
	ret

; This functions will be used to initialize registries, set colors, etc.
cls:
	mov ah, 0x07   ; Print function
	mov al, 0x00   ; Lines to scroll
	mov bh, 0x04   ; Black background and white color (This can be changed according to the BIOS colors), same as CMD color command!
	mov cx, 0x00   ; Initialize register
	mov dx, 0x184f ; Initialize register
	int 0x10       ; Call the BIOS interrupt!
	ret            ; Return

display db "This is...", 13, 10, "WANNA DIE", 13, 10, 0 ; The null terminator is very important!
times 510 - ($ - $$) db 0 ; Zero remaining sectors
dw 0xaa55 ; Bootable signature
