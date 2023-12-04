.model small
.data
    mensaje_captura db 'Ingrese la duracion de la llamada en minutos (2 d?gitos): $'
    mensaje_adicional db 10, 13, 'El costo total de la llamada es de: $'
    mensaje_fijo db 10, 13, 'El costo total de la llamada es de: $' 
    duracion db 0, 0, '$'  ; Cambiamos el valor inicial a 00 para 2 d?gitos
    costo dw 0     ; Usamos una palabra (word) para almacenar el costo
    resultado db 0, 0, '$'  ; Dos d?gitos para el resultado y el signo de d?lar
.code
main proc
    mov ax, @data
    mov ds, ax

inicio:
    call limpiar
    
    ; imprimir mensaje para ingresar la duraci?n de la llamada
   mov dx, offset mensaje_captura
   mov ah, 9h
   int 21h
  mov ah, 01h       ; Funci?n 1 de la interrupci?n 21h para leer un car?cter sin esperar Enter
int 21h
mov duracion, al  ; Guardar el car?cter le?do en duracion

; Leer el segundo d?gito
int 21h
mov duracion+1, al
    ; Convertir la duraci?n a un valor num?rico
mov al, duracion[0]
sub al, 30h
mov bl, al

mov al, duracion[1]
sub al, 30h
add bl, al

; Limpiar DX antes de la divisi?n
xor dx, dx

; Condici?n
mov al, byte ptr costo
add al, bl
mov byte ptr costo, al


    ; cuando la duraci?n es mayor o igual a 3 minutos
cmp bl, 3
jae mayor

menor:
lea dx, mensaje_fijo
mov ah, 9
int 21h
jmp mostrar_resultado

mayor:
lea dx, mensaje_adicional
mov ah, 9
int 21h
mostrar_resultado:
; Convertir el costo a dos d?gitos antes de mostrar
mov ax, costo
mov bx, 1000     ; divisor para obtener el primer d?gito
div bx
add dl, '0'      ; convierte el primer d?gito a car?cter
mov ah, 2        ; funci?n 2 de la interrupci?n 21h (imprimir car?cter)
int 21h

mov ax, costo    ; cargar el valor original de costo
mov bx, 100      ; divisor para obtener el segundo d?gito
div bx
add dl, '0'      ; convierte el segundo d?gito a car?cter
mov ah, 2        ; funci?n 2 de la interrupci?n 21h (imprimir car?cter)
int 21h

; Imprimir un salto de l?nea
mov ah, 2
mov dl, 13
int 21h
mov dl, 10
int 21h



    ; Finalizar el programa
    mov ah, 4Ch
    int 21h

main endp

limpiar proc near
    xor ax, ax
    xor bx, bx
    ret
limpiar endp

end main
