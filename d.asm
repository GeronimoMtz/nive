.model small
.data
    mensaje_captura db 'Ingrese la duracion de la llamada en minutos (2 d?gitos): $'
    mensaje_adicional db 10, 13, 'El costo total de la llamada es de: $'
    mensaje_fijo db 10, 13, 'El costo total de la llamada es de: $' 
    duracion db 0, 0  ; Cambiamos el valor inicial a 00 para 2 d?gitos
    costo dw 0     ; Usamos una palabra (word) para almacenar el costo
    resultado db 0, 0, '$'  ; Dos d?gitos para el resultado y el signo de d?lar
.code
main proc
    mov ax, @data
    mov ds, ax

inicio:
    call limpiar

    ; imprimir mensaje para ingresar la duraci?n de la llamada
    lea dx, mensaje_captura
    mov ah, 9
    int 21h

    ; capturar duraci?n de la llamada
    lea dx, duracion
    mov ah, 0Ah  ; Leemos una cadena de hasta 2 d?gitos
    int 21h

    ; Convertir la duraci?n a un valor num?rico
    mov al, duracion[1]  ; El primer d?gito
    sub al, 30h   ; Restar '0' para obtener el valor num?rico
    mov bl, al    ; Copiar el valor a BL

    mov al, duracion[2]  ; El segundo d?gito
    sub al, 30h   ; Restar '0' para obtener el valor num?rico
    add bl, al    ; Sumar el valor al d?gito anterior en BL

    ; condici?n
    add ax, costo   ; Sumar el valor de BL a AX
    mov costo, ax   ; Guardar el costo total en la variable costo

    ; cuando la duraci?n es mayor o igual a 3 minutos
    cmp al, 3
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

    ; Multiplicar costo por duraci?n (uso de bucle para imitar la multiplicaci?n)
    mov ax, costo
    xor dx, dx
    mov cx, bx

multiplicar:
    add dx, ax
    loop multiplicar

    mov ax, dx
    mov costo, ax ; Guardar el resultado en la variable costo

mostrar_resultado:
    ; Convertir el resultado a dos d?gitos y mostrarlo
    mov ah, 0
    mov al, costo
    div bx
    add ah, 30h
    add al, 30h
    mov resultado[1], ah
    mov resultado[2], al

    ; Mostrar el resultado
    lea dx, resultado
    mov ah, 9
    int 21h

    ; Imprimir un salto de l?nea y finalizar
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