# Game
# 	# Check ms / fps
# 	# 	# 33.3ms 30 fps	16.6ms 60fps
#	#	# if time - last_time > 33: Run
#	#	# Else: sleep last_time - 33; Run
#	# Increase frame counter by 1
#	# If counter == 150 (5seg) : random wall, reset counter  

#	# Move Bullet
#	#	# Move ally bullet
#	#	#	# Check Colision
#	#	#	# 	#s e colidir com um tiro, destroi os 2 tiros
#	#	#	# Se colidir com o inimigo
#	#	#	#	# Combustivel
#	#	#	#	# Reduz vida ou mata direto?
#	#	# Move enemy Bullet
#	#	#	# Check Colision player

#	# Move and Render Enemies
#	#	# Move Ranged
#	#	# Move Meele
#	#	#	# Check Colision
#	#	#	# Com player: morte
#	#	#	# Com tiro: combustivel

#	# Grab MMIO Input
#	#	# If pause: goto pause
#	#	# Check Latest Directional
#	#	#	# 
#	#	# Check if attack

#	# Player Move 
#	#	# Diminui combustivel
#	#	# Check wall colision
#	#	# Move
#	#	# Check Bullet/enemy colision: Die

.include "game.s"
# # # # # # # #  
# CONSTANTES 
# # # # # # # # 
.eqv MMIO_add 0xff200004 # Receiver Data Register (ASCII)
.eqv MMIO_set 0xff200000 # Receiver Control Register (Bool) : 1=dados, restaura pra 0 automaticamente quando usa lw MMIO_add

# # # # # # # #  
# DATA
# # # # # # # #

# # # # # # # #  
# MACROS
# # # # # # # #
.macro syscall(%op)
	li a7, %op
	ecall
.end_macro
.macro syscall(%op, %val)
	li a7, %op
	li a0, %val
	ecall
.end_macro
.macro exit()
	syscall(10)
.end_macro
.macro exit(%int)
	syscall(10, %int)
.end_macro


# # # # # # # #  
# TEXT
# # # # # # # #
.text:
MAIN:
	li s0, MMIO_set
POOLING_LOOP:
	lb t1, 0(s0)
	beqz t1, POOLING_LOOP	# ready bit == 0
	lw a0, MMIO_add		# Dados MMIO
	jal MENU
	
	j POOLING_LOOP
	exit()

MENU:
	li t3, 32
	beq a0, t3, PLAY
	li t3, 27
	beq a0, t3, END
	li t3, 73 # i
	beq a0, t3, INST
	li t3, 105
	beq a0, t3, INST
	
	ret
END:
	li a7, 10
	ecall
INST:
	li a7, 1
	li a0, 111
	ecall
	#INST()
	j MAIN
PLAY:
	li a7, 1
	li a0, 222
	ecall
	GAME_SETUP()
	j MAIN

# RESERVADOS
# s11 = 	|   8   |   9   |    5    |  10  |
# 		| Pos Y | Pos X | Map Ctr | FREE |
# Pos Y 	
# Pos X 	
# MapCtr