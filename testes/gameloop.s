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

# # # # # # # #  
# INCLUDES
# # # # # # # #
.include "./MACROS.s"

# # # # # # # #  
# TEXT
# # # # # # # #
.text
# Menu
#

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



MAIN:
# RESERVADOS
# s11 = 	|   8   |   9   |    5    |  10  |
# 		| Pos Y | Pos X | Map Ctr | FREE |
# Pos Y 	
# Pos X 	
# MapCtr 

# Game
# 	# Check ms / fps
	get_time(t0)
	get_time(a0)
