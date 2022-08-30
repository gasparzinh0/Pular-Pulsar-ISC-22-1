.text
.macro GET_TIME (%reg)
	li a7, 30
	ecall
	mv %reg, a0
.end_macro

# Pausa o programa pelo tempo no registrador %reg, em milissegundos
.macro WAIT (%reg)
	mv a0, %reg
	bgez a0, WAIT_SKIP	# Caso o loop demore demais, não esperamos nada
	li a7, 32
	ecall
WAIT_SKIP:
.end_macro

.macro GAME_LOOP()
POOLING:
	li s0, MMIO_set
POOLING_LOOP:
	GET_TIME(t0)
	sub t1, t0, s3 # SUB LAST SAVED TIME
	addi t1, t1, -16 # ms NORMAL_TIME_STEP
	WAIT(t1)
	lw a0, MMIO_add		# Dados MMIO
	li t0, 72
	beq a0, t0, PAUSE
	PAUSE_CHECK:   # Se nao fizermos isso, pausar gastaria um frame... permitindo exploits
		jal RUN_GAME # salva s0 e s3 automaticamente?
		GET_TIME(s3)
		j POOLING_LOOP
RUN_GAME:
	li a7, 1
	li a0, 444
	ecall
	ret
PAUSE:
	li a7, 1
	li a0, 333
	ecall
	j PAUSE_CHECK
.end_macro

.macro GAME_SETUP()
GET_TIME(s3)
GAME_LOOP()
.end_macro

# RESERVADOS
# s11 = 	|   8   |   9   |    5    |  10  |
# 		| Pos Y | Pos X | Map Ctr | FREE |
# Pos Y 	
# Pos X 	
# MapCtr

# s3 = last_time