! -----------------------------------------------
! 66.70 - Estructura del Computador
! Facultad de Ingenieria
! Universidad de Buenos Aires
! 
! Grupo:	8
! Alumnos:	Pantano, Laura Raquel
!		Extramiana, Federico
!		Rossi, Federico Martin
! -----------------------------------------------
! RESOLUCION DEL TP EN ASSEMBLY ARC
! Sistema de semaforos
! 
! Direccion de entrada 0xD6000020:
! 
! 	Bit0: Boton de peaton.
! 	Bit1: Boton para salida de bomberos.
! 	Bit16: Luz verde semaforo 1.
! 	Bit17: Luz amarilla semaforo 1.
! 	Bit18: Luz roja semaforo 1.
! 	Bit24: Luz verde semaforo 2.
! 	Bit25: Luz amarilla semaforo 2.
! 	Bit26: Luz roja semaforo 2.
! 
! Utilizacion de registros:
! 
!	%r1 - Direccion base de la region I/O de la memoria
!	%r2 - Registro auxiliar para armado de estados a activar
!	%r3 - Registro auxiliar para memorizacion de botones activos
!	%r4 - Registro auxiliar para verificacion de botones activos
!	%r5 - Contador de ciclos para el timer T1
!	%r6 - Contador de ciclos para el timer T2
!	%r7 - Contador de ciclos para el timer T3
! 

		.begin				
		.org 	2048
BASE_IO	.equ	0x358000		! Punto de comienzo de la region mapeada en memoria
IO		.equ	0x20			! 0xD6000020 Posicion de memoria donde se encuentran
						! mapeadas las luces y pulsadores
		
		sethi	BASE_IO, %r1		! %r1 <-- Direccion base de la region I/O de memoria
default:	and	%r2, 0x0, %r2		! %r2 <-- 0x0
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 (reset de los bits de la 
						! posicion de memoria 0xD6000020)
secuenciaA:	call	T1			! Delay de 1 segundo
		ld 	[%r1 + IO], %r3	! %r3 <-- Valor de I/O mapeado en 0xD6000020
		and	%r3, 0x3, %r2		! Guardamos en %r2 los dos primeros bits de %r3
						! Estado de luces LA1 (todas las luces apagadas)
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2
		call	T1			! Delay de 1 segundo
		sethi	LA2, %r2		! %r2 <-- LA2 en 22 bits mas significativos
		ld 	[%r1 + IO], %r3	! %r3 <-- Valor de I/O mapeado en 0xD6000020
		and	%r3, 0x3, %r3		! Guardamos en %r3 los dos primeros bits de 0xD6000020
		add	%r2, %r3, %r2		! %r2 <-- %r2 + %r3
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2
		ba	secuenciaA		! Reiniciamos secuencia A

secuenciaB:	sethi	LB1, %r2		! %r2 <-- LB1 en 22 bits mas significativos
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
		call	T5			! Delay de 5 segundos
		sethi	LB2, %r2		! %r2 <-- LB2 en 22 bits mas significativos
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
		call	T30			! Delay de 30 segundos
		sethi	LB3, %r2		! %r2 <-- LB3 en 22 bits mas significativos
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
		call	T5			! Delay de 5 segundos
		sethi	LB4, %r2		! %r2 <-- LB4 en 22 bits mas significativos
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
		call	T5			! Delay de 5 segundos
		sethi	LB5, %r2		! %r2 <-- LB5 en 22 bits mas significativos
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
		call	T30			! Delay de 30 segundos
		sethi	LB6, %r2		! %r2 <-- LB6 en 22 bits mas significativos
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
		call	T5			! Delay de 5 segundos
		ba	secuenciaA		! Retornamos a la secuencia A
			
secuenciaC:	sethi	LC1, %r2		! %r2 <-- LA2 en 22 bits mas significativos
		add	%r2, BB, %r2		! %r2 <-- %r2 + BB (mantenemos activo el boton BB)
		st	%r2, [%r1 + IO]	! 0xD6000020 <-- %r2 
chequeoBB:	call	controlBB_d		! Verificacion de BB desactivado
		ba	chequeoBB		! Bucle para permanecer en la secuencia C		




! Rutina de verificacion de pulsador BB activado
controlBB_a:	ld 	[%r1 + IO], %r4	! %r4 <-- Valor de I/O mapeado en 0xD6000020
		andcc 	%r4, BB, %r0 		! Verifica si esta encendido el boton de bomberos
		bne 	secuenciaC		! Salto a la secuencia C
		jmpl	%r15+4, %r0		! Retornamos a la rutina invocante

! Rutina de verificacion de pulsador BB desactivado
controlBB_d:	ld 	[%r1 + IO], %r4	! %r4 <-- Valor de I/O mapeado en 0xD6000020
		andcc 	%r4, BB, %r0 		! Verifica si esta encendido el boton de bomberos
		be 	default		! Salto a la secuencia A
		jmpl	%r15+4, %r0		! Retornamos a la rutina invocante

! Rutina de verificacion de pulsador BP activado
controlBP_a:	ld 	[%r1 + IO], %r4	! %r4 <-- Valor de I/O mapeado en 0xD6000020
		andcc 	%r4, BP, %r0 		! Verifica si esta encendido el boton de peaton
		bne 	secuenciaB		! Salto a la secuencia B
		jmpl	%r15+4, %r0		! Retornamos a la rutina invocante




! RUTINAS DE TIMERS
! Timers existentes para uso
!	T1  - Timer de 1 segundo
!	T5  - Timer de 5 segundos
!	T30 - Timer de 30 segundos

T1:		add	%r15, %r0, %r16	! %r16 <-- %r15
		ld	[T1_ciclos], %r5	! %r5 <-- T1_ciclos
T1_loop:	call	controlBB_a		! Realizamos control del pulsador BB
		call	controlBP_a		! Realizamos control del pulsador BP
		addcc	%r5, -1, %r5		! Decrementamos cantidad restante de ciclos
		be	T_done			! Finaliza cuando no quedan ciclos por ejecutar
		ba	T1_loop		! Repetir bucle
	
T5:		add	%r15, %r0, %r16	! %r16 <-- %r15
		ld	[T5_ciclos], %r5	! %r5 <-- T5_ciclos
T5_loop:	addcc	%r5, -1, %r5		! Decrementamos cantidad restante de ciclos
		be	T_done			! Finaliza cuando no quedan ciclos por ejecutar
		call	controlBB_a		! Realizamos control del pulsador BB
		ba	T5_loop		! Repetir bucle

T30:		add	%r15, %r0, %r16	! %r16 <-- %r15
		ld	[T30_ciclos], %r5	! %r5 <-- T30_ciclos
T30_loop:	addcc	%r5, -1, %r5		! Decrementamos cantidad restante de ciclos
		be	T_done			! Finaliza cuando no quedan ciclos por ejecutar
		call	controlBB_a		! Realizamos control del pulsador BB
		ba	T30_loop		! Repetir bucle

T_done:  	jmpl	%r16+4, %r0		! Retorno a la rutina invocante

! FIN RUTINA TIMER




! Botones 
BP		.equ	0x1			! Estado activo del boton de cruce de peatones					
BB		.equ	0x2			! Estado activo del boton de salida de bomberos

! Luces de la secuencia A
LA1		.equ	0x0			! 0x00000000 - Todas las luces apagadas
LA2		.equ	0x8080			! 0x02020000 - A1 y A2 prendidas

! Luces de la secuencia B
LB1		.equ	0x10080		! 0x04020000 - A1 y R2 encedidas
LB2		.equ	0x10040		! 0x04010000 - V1 y R2 encendidas
LB3		.equ	0x10080		! 0x04020000 - A1 y R2 encendidas
LB4		.equ	0x8100			! 0x02040000 - R1 y A2 encendidas
LB5		.equ	0x4100			! 0x01040000 - R1 y V2 encendidas
LB6		.equ	0x8100			! 0x02040000 - R1 y A2 encendidas

! Luces de la secuencia C
LC1		.equ	0x18180		! 0x06060000 - R1, A1, R2 y A2 encendidas

! Timers
T1_ciclos:	1				! Cantidad de ciclos a ejecutar en T1
T5_ciclos:	10				! Cantidad de ciclos a ejecutar en T5
T30_ciclos:	40				! Cantidad de ciclos a ejecutar en T30

		.end
