! -----------------------------------------------
! 66.70 - Estructura del Computador
! Facultad de Ingenieria
! Universidad de Buenos Aires
! 
! Grupo:	8
! Alumnos:	Pántano, Laura Raquel
!		Extramiana, Federico
!		Rossi, Federico Martín
! -----------------------------------------------
! RESOLUCION DEL TP EN ASSEMBLY ARC
! Sistema de semaforos
! 
! Direccion de entrada 0xD6000020:
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
! 
!	%r1 - 
!	%r5 - Contador de ciclos para el timer T1
!	%r6 - Contador de ciclos para el timer T2
!	%r7 - Contador de ciclos para el timer T3
! 

		.begin				
		.org 	2048
IO_addr	.equ	0xD6000020		! Direccion donde se encuentran mapeados los
						! pulsadores de entrada y las luces de salida

		ld 	[IO], %r1		! Carga las entradas
secA:		sethi	0, %r0
		!ld 	LA1, [IO]		! Muestra las luces por defecto
		!call	T1			! Delay de 1 segundo
		!ld	LA2, [IO]		! Muestra las luces por defecto
		!ba	secA			! Reiniciamos secuencia A
secB:		sethi	0, %r0			! Secuencia de cruce de peatones
secC:		sethi	0, %r0			! Secuencia de camion de bomberos

controlBB:	andcc 	%r1, BB, %r0 		! Verifica si esta encendido el boton de bomberos
		be 	secC			! Salta a la secuencia de camion de bomberos
controlBP:	andcc 	%r1, BP, %r0 		! Verifica si esta encendido el boton de peaton
		be 	secB			! Salta a la secuencia de cruce de peatones




! RUTINAS DE TIMERS
! Timers existentes para uso
!	T1  - Timer de 1 segundo
!	T5  - Timer de 5 segundos
!	T30 - Timer de 30 segundos

T1:		ld	[T1_ciclos], %r5	! %r5 <-- T1_ciclos
		ba	T_loop			! Iniciamos timer
T5:		ld	[T5_ciclos], %r5	! %r5 <-- T5_ciclos
		ba	T_loop			! Iniciamos timer
T30:		ld	[T30_ciclos], %r5	! %r5 <-- T30_ciclos
		ba	T_loop			! Iniciamos timer

T_loop:	andcc	%r5, %r5, %r0		! Verificar cantidad restante de ciclos
		be	T_done			! Finaliza cuando no quedan ciclos por ejecutar
		sethi	0, %r0			! No operation (NOP)
		addcc	%r5, -1, %r5		! Decrementamos cantidad restante de ciclos
		ba	T_loop			! Repetir bucle
T_done:  	jmpl	%r15+4, %r0		! Retorno a la rutina invocante

! FIN RUTINA TIMER



! Input/Output 
IO:		IO_addr

! Botones 
BP:		0x00000001			! Estado activo del boton de cruce de peatones					
BB:		0x00000002			! Estado activo del boton de salida de bomberos

! Luces de la secuencia A
LA1:		0x00000000			! Todas las luces apagadas
LA2:		0x02020000			! A1 y A2 prendidas

! Luces de la secuencia B
LB1:		0x04020001			! A1 y R2 encedidas
LB2:		0x04010001			! V1 y R2 encendidas
LB3:		0x04020001			! A1 y R2 encendidas
LB4:		0x02040001			! R1 y A2 encendidas
LB5:		0x01040001			! R1 y V2 encendidas
LB6:		0x02040001			! R1 y A2 encendidas

! Luces de la secuencia C
LC1:		0x06060000			! R1, A1, R2 y A2 encendidas

! Timers
T1_ciclos:	1				! Cantidad de ciclos a ejecutar en T1
T5_ciclos:	12				! Cantidad de ciclos a ejecutar en T5
T30_ciclos:	100				! Cantidad de ciclos a ejecutar en T30

		.end
