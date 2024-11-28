; TALLER 11 - 111

section .data
    num1 db 5 ; define a 5 con 1 byte     
    num2 db 11 ; define a 11 con 1 byte           
    result db 0 ; variable para guardar el Resultado         
    message db "Resultado: ", 0 ; mensaje a imprimir 

section .bss
    buffer resb 4 ; reserva 4 espacios de memoria de los numeros para buffer        

section .text
    global _start ; comienza el programa

%macro PRINT_STRING 1 ; utilizacion de macro para imprimir cadenas
    mov eax, 4  ; syscall: write         
    mov ebx, 1  ; descriptor de archivo        
    mov ecx, %1 ; direccion con la cadena a imprimir         
    mov edx, 13  ; 13 caracteres de espacio para la cadena        
    int 0x80 ; llama al sistema
%endmacro

%macro PRINT_NUMBER 1 ; utiliza macro para imprimir un numero en caracter
    mov eax, %1  ; carga el numero a eax        
    add eax, '0' ; hace la conversion a ASCII        
    mov [buffer], eax ; guarda el caracter en el buffer   
    mov eax, 4  ; syscall: write         
    mov ebx, 1 ; descriptor de archivo           
    mov ecx, buffer  ; direccion de buffer a imprimir    
    mov edx, 1 ; 1 caracter a imprimir          
    int 0x80
%endmacro

_start: 
    ; hace la suma 
    mov al, [num1]  ; carga el valor de num1 a al     
    add al, [num2]  ; suma num2 al almacenado en al     
    mov [result], al  ; guarda el resultado en result    

    PRINT_STRING message  ; imprime cadena "Resultado: "
    PRINT_NUMBER [result] ; imprime el resultado 

    ; Salir del programa
    mov eax, 1           
    mov ebx, 0           
    int 0x80