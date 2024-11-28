section .data
; estructura de la fecha (dd/mm/aaaa)
fecha dd 0 ; dia
      dd 0 ; mes
      dd 0 ; anio

; estructura del correo
correo db "usuario@dominio.com", 0

; estructura de la direccion
dire_calle db "Calle... ", 0
dire_numero db "2175", 0
dire_colonia db "Colonia... ", 0

; cadena para la curp con 18 caracteres y el NULL
curp db "ABCD051105HNENNXZ9", 0

section .text
	global _start

_start:
  ; acceso y manioulacion de la fecha
  mov eax, [fecha] ; carga el dia
  add eax, 1 ; incrementa el dia
  mov [fecha], eax ; dia actualizado

  mov eax, [fecha + 4] ; carga mes
  mov [fecha + 4], 11 ; mes de enero

  mov, eax [fecha + 8] ; cargar el anio
  mov [fecha + 8], 2024 ; cambia a 2024

  ; modificacion de direccion
  mov esi, dire_calle 
  mov edi, nueva_calle
  call cambiar 
  
  ; finalizar el programa
  mov eax, 60
  xor edi, edi
  syscall
  
cambiar:
  ; cambia una copia de cadena en alguna direccion
  cld ; incrementa
  rep movsb ; hace el copiado byte a byte
  ret

