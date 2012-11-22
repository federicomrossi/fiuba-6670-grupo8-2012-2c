! --------------------------------------
! 66.70 - Estructura del Computador
! Facultad de Ingenieria
! Universidad de Buenos Aires
! 
! Grupo:	8
! Alumnos:	Pántano, Laura Raquel
!		Extramiana, Federico
!		Rossi, Federico Martín
! --------------------------------------
! RESOLUCION DEL TP EN ASSEMBLY ARC
! Sistema de semaforos
!
! Direccion de entrada 0xd6000020:
!
! 	Bit0: Botón de peatón.
! 	Bit1: Botón para salida de bomberos.
! 	Bit16: Luz verde semáforo 1.
! 	Bit17: Luz amarilla semáforo 1.
! 	Bit18: Luz roja semáforo 1.
! 	Bit24: Luz verde semáforo 2.
! 	Bit25: Luz amarilla semáforo 2.
! 	Bit26: Luz roja semáforo 2.
! 
! Utilizacion de registros:
!	%r1 - 
!	%r5 - Contador de ciclos para los timer
! 

		.begin
		.org 	2048
secA:		ld 	pos, %r1		! Carga las entradas
		andcc 	%r1, BB, %r0 		! Verifica si esta encendido el boton de bomberos
		be 	secC			! Salta a la secuencia de camion de bomberos
		andcc 	%r1, BP, %r0 		! Verifica si esta encendido el boton de peaton
		be 	secB			! Salta a la secuencia de cruce de peatones
		ld 	LA1, pos		! Muestra las luces por defecto
		call	T1			! Delay de 1 segundo
		ld	LA2, pos		! Muestra las luces por defecto
		ba	secA			! Reiniciamos secuencia A
secB:						! Secuencia de cruce de peatones
secC:						! Secuencia de camion de bomberos


resetT:	andcc %r5, %r0, %r5		! Establecemos en cero el registro contador de ciclos
		jmpl	%r15+4, %r0		! Retorno a rutina invocante
T1:		sethi	0x000000, %r0 	! Delay de 1 segundo
		addcc	%r5, ciclo, %r5	! Incrementamos el contador de ciclos
		[COMPLETAR]			! Verificamos si se llego a XX ciclos
		[COMPLETAR]			! Si no se llego, volvemos a T1
		jmpl	%r15+4, %r0		! Si se llego, retornamos a la secuencia invocante
T5:		[COMPLETAR]			! Delay de 5 segundos	
T30:		[COMPLETAR]			! Delay de 30 segundos


pos		.equ	0xd6000020						


! Botones 
BP		.equ	0x00000001						
BB		.equ	0x00000002
pos		.equ	0x00000000

! Luces de la secuencia A
LA1		.equ	0x00000000		! Todas las luces apagadas
LA2		.equ	0x02020000		! A1 y A2 prendidas

! Luces de la secuencia B
LB1		.equ	0x04020001		! A1 y R2 encedidas
LB2		.equ	0x04010001		! V1 y R2 encendidas
LB3		.equ	0x04020001		! A1 y R2 encendidas
LB4		.equ	0x02040001		! R1 y A2 encendidas
LB5		.equ	0x01040001		! R1 y V2 encendidas
LB6		.equ	0x02040001		! R1 y A2 encendidas

! Luces de la secuencia C
LC1		.equ	0x06060000		! R1, A1, R2 y A2 encendidas

! Auxiliares
ciclo		.equ	1			! Constante que representa un ciclo de instruccion
