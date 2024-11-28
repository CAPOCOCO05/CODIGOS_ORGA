section .data
    ; mensajes a mostrar en pantalla
    menu db '- - Conversor de Metros - - ', 10 ; realiza un salto de linea
         db '1- Km    2- Pulg     3- Yd', 10 ; menu
         db 'Opcion: '
    len_menu equ $ - menu ; calcula la longitud del mensaje
    
    msg_metros db 'Metros: ' ; pide los metros
    len_msg_metros equ $ - msg_metros ; calcula la longitud de los metros
    
    msg_res db 'Resultado: ' ; muestra el resulatdo
    len_msg_res equ $ - msg_res ; longitud del mensaje del resultado
    
    nl db 10    ; caracter de nueva linea

section .bss
    opcion resb 2 ; reserva 2 bytes para la opcion elegida
    metros resb 5 ; reserva 5 bytes para el numero de metros
    resultado resb 10 ; reserva 10 bytes para el resultado

section .text
    global _start

_start:
    ; mostrar menu
    mov eax, 4 ; syscall para escribir
    mov ebx, 1  ; file descriptor (1 = stdout)
    mov ecx, menu ; mensaje a mostrar
    mov edx, len_menu ; longitud del mensaje
    int 80h  ; llamada al sistema

    ; leer opcion
    mov eax, 3 ; syscall para leer
    mov ebx, 0 ; file descriptor (0 = stdin)
    mov ecx, opcion ; guarda la entrada
    mov edx, 2 ; leer 2 bytes
    int 80h
    
    ; mostrar metros
    mov eax, 4 ; escribir en pantalla
    mov ebx, 1  ; file descriptor 1 = stdout (salida estandar)
    mov ecx, msg_metros ; direccion del mensaje a mostrar
    mov edx, len_msg_metros ; longitud del mensaje
    int 80h  ; ejecutar la llamada al sistema
    
    ; leer metros
    mov eax, 3 ; leer lo del teclado
    mov ebx, 0 ; file descriptor 0 = stdin (entrada estandar)
    mov ecx, metros ; direccion donde guardar lo que se lea
    mov edx, 5 ; maximo de 5 bytes a leer
    int 80h ; ejecutar la llamada al sistema

    ; convertir metros a numero
    mov eax, 0 ; limpia el registro eax
    mov esi, metros ; pone en esi la direccion de la cadena a convertir
    call str2int ; llama a la funcion de conversion
    
    ; convertir la opcion de ASCII a numero
    mov bl, [opcion] ; 
    sub bl, '0' ; resta 48 ('0' en ASCII) para obtener el numero
    
    ; eleccion del menu
    cmp bl, 1
    je to_km ; Si es 1, convertir a kilometros
    cmp bl, 2
    je to_inch ; Si es 2, convertir a pulgadas
    cmp bl, 3
    je to_yard ; Si es 3, convertir a yardas
    jmp exit

to_km:
    mov ebx, 1000 ; 1 km = 1000 metros
    mov edx, 0 ; limpia el registro edx para división
    div ebx ; divide eax por ebx
    jmp print_result

to_inch:
    mov ebx, 39 ; aproximadamente 39 pulgadas por metro
    mul ebx ; multiplica eax por ebx
    jmp print_result

to_yard:
    mov ebx, 109 ; aproximacinn: 1.09 yardas = 109/100
    mul ebx ; multiplica por 109
    mov ebx, 100      
    div ebx ; divide por 100
    
print_result:
    ; convertir resultado a string
    mov esi, resultado ; apunta esi a donde se guardara el string
    call int2str ; llama a la función que convierte numero a string
    
    ; mostrar etiqueta resultado
    mov eax, 4 ; syscall para escribir
    mov ebx, 1 ; en la salida estandar
    mov ecx, msg_res ; mensaje "Resultado: "
    mov edx, len_msg_res ; longitud del mensaje
    int 80h ; ejecuta la llamada al sistema
    
    ; mostrar numero
    mov eax, 4 ; syscall para escribir
    mov ebx, 1 ; en la salida estandar
    mov ecx, resultado ; el numero convertido a texto
    mov edx, 10 ; maximo 10 caracteres
    int 80h ; ejecuta la llamada al sistema
    
    ; nueva linea
    mov eax, 4 ; syscall para escribir
    mov ebx, 1 ; en la salida estandar
    mov ecx, nl ; caracter de nueva linea
    mov edx, 1 ; solo 1 caracter
    int 80h ; ejecuta la llamada al sistema

exit:
    mov eax, 1 ; syscall para exit
    xor ebx, ebx ; codigo de retorno 0 (exito)
    int 80h ; ejecuta la llamada al sistema

; convierte string a int
str2int:
    xor ebx, ebx ; limpia ebx (acumulador)
.next:
    movzx ecx, byte [esi] ; obtiene un caracter
    cmp ecx, '0' ; comprueba si es menor que 0
    jb .done
    cmp ecx, '9'; comprueba si es mayor que 9
    ja .done
    sub ecx, '0' ; convierte ASCII a numero
    imul ebx, 10 ; multiplica acumulador por 10
    add ebx, ecx ; añade el nuevo digito
    inc esi ; siguiente caracter
    jmp .next
.done:
    mov eax, ebx ; resultado en eax
    ret

; convierte int a string
int2str:
    add esi, 9 ; va al final del buffer
    mov byte [esi], 0 ; pone el terminador null
    mov ebx, 10 ; usara 10 para dividir
.next:
    xor edx, edx ; limpia edx para division
    div ebx ; divide eax por 10
    add dl, '0' ; convierte el residuo a ASCII
    dec esi ; retrocede una posicion
    mov [esi], dl ; guarda el digito
    test eax, eax ; verifica si hay mas digitos
    jnz .next ; si quedan, continua
    ret ; si no, termina