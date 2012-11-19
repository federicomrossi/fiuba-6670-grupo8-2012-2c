! resulocion del TP en Assembly ARC
! direccion de entradas 0xd6000020
! Bit0: Botón de peatón.
! Bit1: Botón para salida de bomberos.
! Bit16: Luz verde semáforo 1.
! Bit17: Luz amarilla semáforo 1.
! Bit18: Luz roja semáforo 1.
! Bit24: Luz verde semáforo 2.
! Bit25: Luz amarilla semáforo 2.
! Bit26: Luz roja semáforo 2.

		.begin
		.org 2048
loop:	ld pos, %r1 				! carga las entradas
		andcc %r1, BB, %r0 			! verifica si esta encendido el boton de bomberos
		be secb						! salta a la secuencia de bomberos
		andcc %r1, BP, %r0 			! verifica si esta encendido el boton de peaton
		be secp						! salta a la secuencia de peatones
		ld LD1, pos					! muestra las luces por defecto
		(esperar 1 segundo)
		ld LD2, pos					! muestra las luces por defecto
		ba loop
		
secb:								! aca comienza la secuencia de bomberos
secp:								! aca comienza la secuencia de peatones

BP:	0x00000001
BB:	0x00000002
pos:0x00000000
LD1:0x00000000
LD2:0x02020000
LP1:0x04020000
LP2:
LP3:
LP4:
LP5:
LP6:
LB:	