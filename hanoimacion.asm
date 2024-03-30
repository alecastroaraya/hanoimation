;--------------------------------------------Portada-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Tarea de ASM: Hanoimacion
; Curso: Arquitectura de Computadores
; Grupo: 2
; Escuela de Computacion
; Instituto Tecnologico de Costa Rica
; Fecha de entrega: 20 de noviembre del 2020
; Estudiante: Alejandro Castro Araya
; Carne: 2020034944
; Profesor: Kirstein Gatjens
;--------------------------------------------Manual de Usuario-------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Este programa despliega una animacion del algoritmo Torres of Hanoi. Recibe una entrada mediante la linea de comandos, la cual es un numero del 1-8.
; Dependiendo del numero digitado en la linea de comandos, despliega y mueve esa cantidad de anillo en la animacion del programa. Es decir, si se escribe el numero 2, se insertaran y moveran 2 anillos en la animacion.
; Luego de desplegar todos los anillos y moverlos al otro lado, se sale del programa. Las unicas entradas que recibe el programa son:
;
; Numero del 1-8: 	Despliega la cantidad escogida de anillos. Luego los va moviendo uno por uno al poste de la pura derecha de la pantalla.
;--------------------------------------------Analisis de resultados-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;+-----------------------------------------------------------------------------------------------------+------+--------------------------------------------------------------------------------------------------------------------------------+
;|                                            Parte                                                    | Nota | Explicacion Adicional                                                                                                          |
;+-----------------------------------------------------------------------------------------------------+------+--------------------------------------------------------------------------------------------------------------------------------+
;| Desplegar acerca de en la parte superior de la pantalla.                                            | A    | Funciona correctamente                                                                                                         |
;| Desplegar la animacion solicitada en al menos las 18 filas inferiores.							   | A    | Funciona correctamente                                                                                                         |
;| Recibir un solo numero de entrada en la linea de comandos que indique la cantidad de anillos.       | A    | Funciona correctamente                                                                                                         |
;| Desplegar los postes de forma que se vean claramente.                                               | A    | Funciona correctamente                                                                                                         |
;| Desplegar la cantidad de anillos escogida, que sean de dos filas de alto y columnas razonables.     | A    | Funciona correctamente                                                                                                         |
;| Los anillos son de diferentes colores cada uno.                                                     | A    | Funciona correctamente                                                                                                         |
;| Salirse del programa al terminar la animacion.                                                      | A    | Funciona correctamente                                                                                                         |
;| Manejo de pausa para la animacion de mover los anillos.                                             | A    | Funciona correctamente                                                                                                         |
;| Uso de acceso directo a memoria de video en modo texto 80x25 para hacer la animacion.               | A    | Funciona correctamente   																									   |
;| Mover los anillos al poste auxiliar o al poste objetivo dependiendo de los pasos que se deben tomar | C    | Los anillos solo se mueven al poste objetivo ya que no supe como hacer que supiera a cual moverse al momento de moverse        |
;| Mover los anillos sin sobreescribir los otros postes ni el fondo del programa.                      | A    | Funciona correctamente                                                                                                         |
;| Algoritmo recursivo para calcular los movimientos de los discos.                                    | C    | Hice un algoritmo recursivo que dice que pasos tomar, pero solo lo dice en texto, no pude conectarlo a mover los anillos en si.|
;| Desplegar animacion a una velocidad razonable.                                                      | A    | Funciona correctamente                                                                                                         |
;| Documentación (Portada, manual de usuario y analisis de resultados con ABCD y comentarios).         | A    | Escrita correctamente                                                                                                          |
;+-----------------------------------------------------------------------------------------------------+------+--------------------------------------------------------------------------------------------------------------------------------+

data segment

	acercade db 'Arquitectura de Computadores Gr 2$'
	acercade2 db 'Alejandro Castro Araya Carne 2020034944$'
	acercade3 db 'Ver. 0.74-3 14/11/2020 Tarea Hanoimacion$'
	ventana1 db '|$'
	ventana2 db '+------------------------------------------------------------------------------+$'
	poste1 db '-$'
	poste2 db '|$'
	anillo1 db '-------$'
	anillo1L db ' |   | $'
	anillo2 db '---------$'
	anillo2L db '  |   |  $'
	anillo3 db '-----------$'
	anillo3L db '   |   |   $'
	anillo4 db '-------------$'
	anillo4L db '    |   |    $'
	anillo5 db '---------------$'
	anillo5L db '     |   |     $'
	anillo6 db '-----------------$'
	anillo6L db '      |   |      $'
	anillo7 db '-------------------$'
	anillo7L db '       |   |       $'
	anillo8 db '---------------------$'
	anillo8L db '        |   |        $'
	Fil db 2
    Col db 0
    ColF db 9   ; Azul Claro
    ColB db 3   ; Cyan Oscuro
	errorletra db '		Por favor ingrese un numero entre 1-8.$'
	
	numero db 80, 0, 80 dup('$')
	
	hola db 'hola$'
	Tam dw 4
	Pant db 128 dup(?)
	
	x db 3
	text db "Mueva el disco en el poste "
	d1 db ?
	text2 db " al poste "
	d2 db ?
	newline db 0AH, 0DH, '$'

    PAUSA1 dw 1000
    PAUSA2 dw 100 ; En total hace de pausa 10000x2000=20 000 000 de nops
	
data ends


pila segment stack 'stack'
   dw 256 dup(?)

pila ends


code segment

        assume  cs:code, ds:data, ss:pila

printAX proc ; Esta es la rutina de printAX que el profesor usa en los ejemplos vistos en clase y subidos en el foro.
; imprime a la salida estándar un número que supone estar en el AX
; supone que es un número positivo y natural en 16 bits.
; lo imprime en decimal.  
    
    push AX
    push BX
    push CX
    push DX

    xor cx, cx
    mov bx, 10
ciclo1PAX: xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne ciclo1PAX
    mov ah, 02h
ciclo2PAX: pop DX
    add dl, 30h
    int 21h
    loop ciclo2PAX

    pop DX
    pop CX
    pop BX
    pop AX
    ret
printAX endP

space proc near ; Esta es la rutina de space que el profesor usa en los ejemplos vistos en clase y subidos en el foro.
; imprime a la salida estándar CX espacios en blanco
 
    push AX
    push CX
    push DX

    mov ah, 02h
    mov dl, 32
spacecic: int 21h
    loop spacecic

    pop DX
    pop CX
    pop AX
    ret
space endP

println proc near ; Esta es la rutina de println que el profesor usa en los ejemplos vistos en clase y subidos en el foro.
; imprime a la salida estándar un cambio de línea
 
    push AX
    push DX

    mov ah, 02h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h

    pop DX
    pop AX
    ret
println endP

CamLin proc ; Esta es la rutina de CamLin que el profesor usa en los ejemplos vistos en clase y subidos en el foro.
; despliega a la salida estandar un Cambio de Línea

  push ax
  push dx

  mov dl, 0Dh
  mov ah, 02h
  int 21h

  mov dl, 0Ah
  mov ah, 02h
  int 21h


  pop dx
  pop ax
  ret

CamLin endP

printAcercaDe Proc
; Esta rutina despliega el acerca de con una ventana creada con acceso directo de memoria de video modo texto 80 x 25
	push dx
	push bx
	push si
	push ax

	mov dl, Fil
    mov dh, Col
	dec ColB
	sub ColF,4
    mov bh, ColB
    mov bl, ColF
    lea si, ventana2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana2
	call PrnRot
	
	mov al,3
	mov Fil,al
	mov al,18
	mov Col,18
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, acercade
	call PrnRot
	
	mov al,Col
	push ax
	mov al,79
	mov Col,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, ventana1
	call PrnRot
	
	pop ax
	mov Col,al
	dec Fil
	dec Fil
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, acercade2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, acercade3
	call PrnRot
	
	pop dx
	pop bx
	pop ax
	pop si
	
	ret
printAcercaDe endP

printPoste1 Proc
; Esta rutina despliega el poste de la pura izquierda de las torres de hanoi por medio de desplegar los caracteres que la componen en varias filas y columnas
	MOV AX,0B800H
    MOV ES,AX
	
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	sub Col,9
	mov al,7
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	inc Col
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	inc Col
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	
	dec Col
	dec Col
	dec Col
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	add Col,4
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	ret
printPoste1 endP

printPoste2 Proc
; Esta rutina despliega el poste del medio de las torres de hanoi por medio de desplegar los caracteres que la componen en varias filas y columnas
	MOV AX,0B800H
    MOV ES,AX
	
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	add Col,25
	mov al,7
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	inc Col
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	inc Col
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	dec Col
	dec Col
	dec Col
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	add Col,4
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	ret
printPoste2 endP

printPoste3 Proc
; Esta rutina despliega el poste de la pura derecha de las torres de hanoi por medio de desplegar los caracteres que la componen en varias filas y columnas
	MOV AX,0B800H
    MOV ES,AX
	
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	add Col,28
	mov al,7
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	inc Col
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	inc Col
	mov Fil,al
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste1
	call PrnRot
	
	
	dec Col
	dec Col
	dec Col
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	inc Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	add Col,4
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	dec Fil
	mov dl, Fil
    mov dh, Col
    mov bh, ColB
    mov bl, ColF
    lea si, poste2
	call PrnRot
	
	ret
printPoste3 endP

GetRot Proc ;Esta rutina es la rutina usada por el profesor en los ejemplos del foro y en clase, obtiene el rotulo que hay en la posicion dada como input de la pantalla
; Recibe en el DS:[si] un puntero al rótulo donde se va a salvar.  Supone que es un asciiz
; Recibe en el DX la coordenada donde se debe salvar (DL=Fila y DX=Columna)
; Recibe en el CX la cantidad de caracteres de el rotulo a salvar

         push ax 
         push bx 
         push cx 
         push dx 
         push di 
         push si 
         push es        

         mov ax, 0B800h
         mov es, ax 

         mov Al, Dl
         mov bl, 80
         mul bl
         mov bl, dh
         xor bh, bh
         add ax, bx
         shl ax, 1
         mov di, ax
         
cicGetRot:
         
         mov al, byte ptr Es:[di]  
         mov byte ptr [si], al
         inc di
         inc di
         inc si 
         loop cicGetRot

         mov byte ptr [si],'$'    

        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret 

GetRot EndP

PrnRot Proc ; Esta rutina despliega el rotulo que se le da como input en la posicion de la pantalla dada como input
; Recibe en el DS:[si] un puntero al rótulo.  Supone que es un asciiz
; Recibe en el DX la coordenada donde se debe desplegar (DL=Fila y DX=Columna)
; Recibe en el BX el color (BL=Foreground y BH=Background) 

         push ax 
         push bx 
         push cx 
         push dx 
         push di 
         push si 
         push es        

         mov ax, 0B800h
         mov es, ax 

         mov Al, Dl
         mov cl, 80
         mul cl
         mov cl, dh
         xor ch, ch
         add ax, cx
         shl ax, 1
         mov di, ax
         
         mov ah, bl
         and ah,0Fh
         mov cl, 4
         shl bh, cl
         or ah, bh         

cicPrnRot:
         cmp byte ptr [si],'$'
         je salirprnRot

         mov al, byte ptr [si]
         mov word ptr Es:[di], ax  
         inc di
         inc di
         inc si 
         jmp cicPrnRot

salirprnRot:

        pop es
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret 

PrnRot EndP

printAnillo1 Proc
; Esta rutina despliega el primer anillo de la torre de hanoi, es el mas pequeno y es color azul
	mov Fil,9
	mov Col,7
	mov al,3h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo1
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo1
	call prnRot
	
	ret
printAnillo1 endP

printAnillo2 Proc
; Esta rutina despliega el segundo anillo de la torre de hanoi, es color morado
	inc Fil
	dec Col
	mov al,5h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo2
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo2
	call prnRot
	
	ret
printAnillo2 endP

printAnillo3 Proc
; Esta rutina despliega el tercer anillo de las torres de hanoi, es color negro
	inc Fil
	dec Col
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo3
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo3
	call prnRot
	
	ret
printAnillo3 endP

printAnillo4 Proc
; Esta rutina despliega el cuarto anillo de la torre de hanoi, es color naranja
	inc Fil
	dec Col
	mov al,6h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo4
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo4
	call prnRot
	
	ret
printAnillo4 endP

printAnillo5 Proc
; Esta rutina despliega el quinto anillo de la torre de hanoi, es color blanco
	inc Fil
	dec Col
	mov al,7h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo5
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo5
	call prnRot
	
	ret
printAnillo5 endP

printAnillo6 Proc
; Esta rutina despliega el sexto anillo de la torre de hanoi, es color verde
	inc Fil
	dec Col
	mov al,2h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo6
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo6
	call prnRot
	
	ret
printAnillo6 endP

printAnillo7 Proc
; Esta rutina despliega el setimo anillo de la torre de hanoi, es color rojo
	inc Fil
	dec Col
	mov al,4h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo7
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo7
	call prnRot
	
	ret
printAnillo7 endP

printAnillo8 Proc
; Esta rutina despliega el octavo anillo de la torre de hanoi, es color azul oscuro
	inc Fil
	dec Col
	mov al,1h
	mov ColB,al
	mov al,9h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo8
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo8
	call prnRot
	
	ret
printAnillo8 endP

solve proc ; Este algoritmo recursivo calcula los pasos a tomar para resolver el puzzle de torres de hanoi y los despliega, recibe la cantidad de anillos como entrada de linea de comandos
   push bp
   mov bp, sp
   cmp word ptr ss:[bp+4], 0
   je down
   
   push word ptr ss:[bp+0AH]
   push word ptr ss:[bp+6]
   push word ptr ss:[bp+8]
   mov ax, word ptr ss:[bp+4]
   dec ax
   push ax
   call solve

   push word ptr ss:[bp+0AH]
   push word ptr ss:[bp+08]
   call print

   push word ptr ss:[bp+06H]
   push word ptr ss:[bp+8]
   push word ptr ss:[bp+0AH]
   mov ax, word ptr ss:[bp+4]
   dec ax
   push ax
   call solve

   pop bp
   ret 8
down:
   pop bp
   ret 8

solve endp

print proc ; Esta rutina es parte del algoritmo recursivo de torres de hanoi, despliega los pasos a tomar para resolver el puzzle dependiendo de la cantidad de anillos escogida
   push bp
   mov bp, sp
   mov d1, '0'
   mov al, byte ptr ss:[bp+06]
   add d1, al
   mov d2, '0'
   mov al, byte ptr ss:[bp+4]
   add d2, al
   lea dx, text
   mov ah, 09
   int 21h
   pop bp
   ret 4

print endp

moverAnillos1 PROC ; Esta rutina mueve el primer anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime1:
		
         mov dl, Fil
         mov dh, Col
         mov cx, 7
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo1
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Se hace una pausa de 100 x 1000 nops para que la animacion tenga una pausa
PausaNOP1:     PUSH CX
        MOV CX, PAUSA2
PausaNOP2:     NOP
        LOOP PausaNOP2
        POP CX
        LOOP PausaNOP1
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,66
		je derecha1
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha1

derecha1: cmp col, 66
        je segundoanillo1
		
        inc col 
		cmp col,66
		jne	imprime1
		
		mov al,3h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime1
		
der1:   mov col,0
        jmp imprime1
segundoanillo1: ; Luego de que se desplego la primera fila del anillo, se desplega la segunda fila del anillo
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,10
	je terminar1
	inc Fil
	mov Col,7
	jmp moverAnillos1

terminar1:
	call limpiarAnillo1 ; Se quita el anillo del poste en donde estaba
	ret
moverAnillos1 endp

limpiarAnillo1 PROC ; Esta rutina quita el anillo que se movio del poste donde estaba previamente
	mov Fil,9
	mov Col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo1L ; Se despliega el string que borra el anillo viejo
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo1L
	call prnRot
	
	ret
limpiarAnillo1 endP

moverAnillos2 PROC ; Esta rutina mueve el segundo anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime2:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 9
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo2
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Se hace una pausa de 100 x 1000 nops
PausaNOP12:     PUSH CX
        MOV CX, PAUSA2
PausaNOP22:     NOP
        LOOP PausaNOP22
        POP CX
        LOOP PausaNOP12
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,65
		je derecha2
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha2

derecha2: cmp col, 65
        je segundoanillo2
		
        inc col 
		cmp col,65
		jne	imprime2
		
		mov al,5h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime2
		
der2:   mov col,0
        jmp imprime2
segundoanillo2:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,12
	je terminar2
	inc Fil
	mov Col,6
	jmp moverAnillos2

terminar2:
	call limpiarAnillo2
	ret
moverAnillos2 endp

limpiarAnillo2 PROC ; Se borra el anillo de su poste viejo
	mov Fil,11
	mov Col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo2L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo2L
	call prnRot
	
	ret
limpiarAnillo2 endP

moverAnillos3 PROC ; Esta rutina mueve el tercer anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime3:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 11
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo3
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Se hace una pausa de 100 x 1000 nops
PausaNOP13:     PUSH CX
        MOV CX, PAUSA2
PausaNOP23:     NOP
        LOOP PausaNOP23
        POP CX
        LOOP PausaNOP13
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,64
		je derecha3
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha3

derecha3: cmp col, 64
        je segundoanillo3
		
        inc col 
		cmp col,64
		jne	imprime3
		
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime3
		
der3:   mov col,0
        jmp imprime3
segundoanillo3:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,14
	je terminar3
	inc Fil
	mov Col,5
	jmp moverAnillos3

terminar3:
	call limpiarAnillo3
	ret
moverAnillos3 endp

limpiarAnillo3 PROC ; Se borra el anillo viejo
	mov Fil,13
	mov Col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo3L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo3L
	call prnRot
	
	ret
limpiarAnillo3 endP

moverAnillos4 PROC ; Esta rutina mueve el cuarto anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime4:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 13
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo4
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Se hace una pausa de 100 x 1000 nops
PausaNOP14:     PUSH CX
        MOV CX, PAUSA2
PausaNOP24:     NOP
        LOOP PausaNOP24
        POP CX
        LOOP PausaNOP14
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,63
		je derecha4
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha4

derecha4: cmp col, 63
        je segundoanillo4
		
        inc col 
		cmp col,63
		jne	imprime4
		
		mov al,6h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime4
		
der4:   mov col,0
        jmp imprime4
segundoanillo4:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,16
	je terminar4
	inc Fil
	mov Col,4
	jmp moverAnillos4

terminar4:
	call limpiarAnillo4
	ret
moverAnillos4 endp

limpiarAnillo4 PROC ; Se borra el cuarto anillo de su viejo poste
	mov Fil,15
	mov Col,4
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo4L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo4L
	call prnRot
	
	ret
limpiarAnillo4 endP

moverAnillos5 PROC ; Esta rutina mueve el quinto anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime5:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 15
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo5
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Hacemos una pausa de 100 x 1000 nops
PausaNOP15:     PUSH CX
        MOV CX, PAUSA2
PausaNOP25:     NOP
        LOOP PausaNOP25
        POP CX
        LOOP PausaNOP15
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,62
		je derecha5
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha5

derecha5: cmp col, 62
        je segundoanillo5
		
        inc col 
		cmp col,62
		jne	imprime5
		
		mov al,7h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime5
		
der5:   mov col,0
        jmp imprime5
segundoanillo5:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,18
	je terminar5
	inc Fil
	mov Col,3
	jmp moverAnillos5

terminar5:
	call limpiarAnillo5
	ret
moverAnillos5 endp

limpiarAnillo5 PROC ; Se borra el quinto anillo de su viejo poste
	mov Fil,17
	mov Col,3
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo5L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo5L
	call prnRot
	
	ret
limpiarAnillo5 endP

moverAnillos6 PROC ; Esta rutina mueve el sexto anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime6:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 17
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo6
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Hacemos una pausa de 100 x 1000 nops
PausaNOP16:     PUSH CX
        MOV CX, PAUSA2
PausaNOP26:     NOP
        LOOP PausaNOP26
        POP CX
        LOOP PausaNOP16
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,61
		je derecha6
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha6

derecha6: cmp col, 61
        je segundoanillo6
		
        inc col 
		cmp col,61
		jne	imprime6
		
		mov al,2h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime6
		
der6:   mov col,0
        jmp imprime6
segundoanillo6:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,20
	je terminar6
	inc Fil
	mov Col,2
	jmp moverAnillos6

terminar6:
	call limpiarAnillo6
	ret
moverAnillos6 endp

limpiarAnillo6 PROC ; Se quita el sexto anillo de su viejo poste
	mov Fil,19
	mov Col,2
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo6L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo6L
	call prnRot
	
	ret
limpiarAnillo6 endP

moverAnillos7 PROC ; Esta rutina mueve el setimo anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime7:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 19
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo7
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Hacemos una pausa de 100 x 1000 nops
PausaNOP17:     PUSH CX
        MOV CX, PAUSA2
PausaNOP27:     NOP
        LOOP PausaNOP27
        POP CX
        LOOP PausaNOP17
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,60
		je derecha7
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha7

derecha7: cmp col, 60
        je segundoanillo7
		
        inc col 
		cmp col,60
		jne	imprime7
		
		mov al,4h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime7
		
der7:   mov col,0
        jmp imprime7
segundoanillo7:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,22
	je terminar7
	inc Fil
	mov Col,1
	jmp moverAnillos7

terminar7:
	call limpiarAnillo7
	ret
moverAnillos7 endp

limpiarAnillo7 PROC ; Se quita el setimo anillo de su viejo poste
	mov Fil,21
	mov Col,1
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo7L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo7L
	call prnRot
	
	ret
limpiarAnillo7 endP

moverAnillos8 PROC ; Esta rutina mueve el octavo anillo del poste de la pura izquierda al poste de la pura derecha por medio de guardar la posicion actual de la pantalla para no perderla e ir desplegando el anillo
		imprime8:
		
		
		
         mov dl, Fil
         mov dh, Col
         mov cx, 21
         lea si, Pant
         call GetRot

		

         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, anillo8
         call prnRot
		 
		 
		  MOV CX, PAUSA1       ; Hacemos una pausa de 100 x 1000 nops
PausaNOP18:     PUSH CX
        MOV CX, PAUSA2
PausaNOP28:     NOP
        LOOP PausaNOP28
        POP CX
        LOOP PausaNOP18
		
		
        ;xor ah, ah
        ;int 16h
		cmp col,59
		je derecha8
         mov dl, Fil
         mov dh, Col
         mov bh, ColB
         mov bl, ColF
         lea si, Pant
         call prnRot

         jmp derecha8

derecha8: cmp col, 59
        je segundoanillo8
		
        inc col 
		cmp col,59
		jne	imprime8
		
		mov al,1h
		mov ColB,al
		mov al,9h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF
		
		jmp imprime8
		
der8:   mov col,0
        jmp imprime8
segundoanillo8:
		mov al,0h
		mov ColB,al
		mov al,7h
		mov ColF,al
		mov bh, ColB
		mov bl, ColF

	cmp Fil,24
	je terminar8
	inc Fil
	mov Col,0
	jmp moverAnillos8

terminar8:
	call limpiarAnillo8
	ret
moverAnillos8 endp

limpiarAnillo8 PROC ; Se quita el octavo anillo de su viejo poste
	mov Fil,23
	mov Col,0
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo8L
	call prnRot
	
	inc Fil
	mov dl, Fil
	mov dh, Col
	mov bh, ColB
	mov bl, ColF
	lea si, anillo8L
	call prnRot
	
	ret
limpiarAnillo8 endP

main:
	
	mov ax,ds ; Se mueve ds a es
	mov es,ax

	mov ax,data ; Inicializa el data segment mandandolo al ds register
	mov ds,ax

	mov ax,pila ; Inicializa la pila mandandola al ss register
	mov ss,ax

	mov si,81h
getNumero1:
	mov al,byte ptr es:[si] ; Se recorren los espacios hasta que se llegue a un caracter que no sea un espacio, lo que significa que es un numero
	cmp al,' '
	jne getNumero2
	inc si
	jmp getNumero1
getNumero2:
	mov al,byte ptr es:[si] ; Se mueve el numero a la variable numero y esa es la cantidad de anillos que se debe desplegar y mover
	mov numero,al
	mov x,al
	sub x,'0'
	
	mov ah,0h
	mov al,03h
	int 10h
	
	call printAcercaDe ; Se despliega el acerca de y los tres postes de las torres de hanoi
	call printPoste1
	call printPoste2
	call printPoste3

preguntar1:				; Se hacen varios saltos de conejo para determinar que cantidad de anillos se escribio, si no es un numero entre 1-8 entonces despliega un error y termina el programa
	cmp numero,'1'
	jne preguntar2
	jmp printear1
preguntar2:
	cmp numero,'2'
	jne preguntar3
	jmp printear2
preguntar3:
	cmp numero,'3'
	jne preguntar4
	jmp printear3
preguntar4:
	cmp numero,'4'
	jne preguntar5
	jmp printear4
preguntar5:
	cmp numero,'5'
	jne preguntar6
	jmp printear5
preguntar6:
	cmp numero,'6'
	jne preguntar7
	jmp printear6
preguntar7:
	cmp numero,'7'
	jne preguntar8
	jmp printear7
preguntar8:
	cmp numero,'8'
	jne darError
	jmp printear8
darError:
	lea dx,errorletra
	mov ah,9h
	int 21h
	jmp terminarMain
printear1:
	call printAnillo1 ; Se van desplegando los anillos y moviendolos dependiendo de la cantidad que se pidio
	dec Fil
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	jmp terminarMain
printear2:
	call printAnillo1
	call printAnillo2
	dec Fil
	dec Fil
	dec Fil
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	jmp terminarMain
printear3:
	call printAnillo1
	call printAnillo2
	call printAnillo3
	dec Fil
	dec Fil
	dec Fil
	dec Fil
	dec Fil
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	inc Fil
	mov col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos3
	jmp terminarMain
printear4:
	call printAnillo1
	call printAnillo2
	call printAnillo3
	call printAnillo4
	sub Fil,7
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	inc Fil
	mov col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos3
	inc Fil
	mov col,4
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos4
	jmp terminarMain
printear5:
	call printAnillo1
	call printAnillo2
	call printAnillo3
	call printAnillo4
	call printAnillo5
	sub Fil,9
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	inc Fil
	mov col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos3
	inc Fil
	mov col,4
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos4
	inc Fil
	mov col,3
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos5
	jmp terminarMain
printear6:
	call printAnillo1
	call printAnillo2
	call printAnillo3
	call printAnillo4
	call printAnillo5
	call printAnillo6
	sub Fil,11
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	inc Fil
	mov col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos3
	inc Fil
	mov col,4
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos4
	inc Fil
	mov col,3
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos5
	inc Fil
	mov col,2
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos6
	jmp terminarMain
printear7:
	call printAnillo1
	call printAnillo2
	call printAnillo3
	call printAnillo4
	call printAnillo5
	call printAnillo6
	call printAnillo7
	sub Fil,13
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	inc Fil
	mov col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos3
	inc Fil
	mov col,4
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos4
	inc Fil
	mov col,3
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos5
	inc Fil
	mov col,2
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos6
	inc Fil
	mov col,1
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos7
	jmp terminarMain
printear8:					; Si se pidieron los ocho anillos, se mueven los ocho y se van borrando de sus viejas posiciones en su viejo poste
	call printAnillo1
	call printAnillo2
	call printAnillo3
	call printAnillo4
	call printAnillo5
	call printAnillo6
	call printAnillo7
	call printAnillo8
	sub Fil,15
	mov col,7
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos1
	inc Fil
	mov col,6
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos2
	inc Fil
	mov col,5
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos3
	inc Fil
	mov col,4
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos4
	inc Fil
	mov col,3
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos5
	inc Fil
	mov col,2
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos6
	inc Fil
	mov col,1
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos7
	inc Fil
	mov col,0
	mov al,0h
	mov ColB,al
	mov al,7h
	mov ColF,al
	mov bh, ColB
	mov bl, ColF
	call moverAnillos8
terminarMain: ; Se termina el programa
	mov ah,4ch ; Hace interrupt para hacer exit hacia DOS para terminar el programa
	int 21h

code ends

end main