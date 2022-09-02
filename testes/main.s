# # # # # # # #  
# INCLUDES
# # # # # # # #
.include "./MACROS.s"

# # # # # # # #  
# TEXT
# # # # # # # #
.text
MAIN:
	DEBUG_SCREEN_RED()
	DEBUG_SCREEN_GREEN()
	get_time(a0)
	li t4, 0
	li t6, 30
LOOP:
	print_int(a0)
	wait_frame(a0)
	addi t4, t4, 1
	blt t4, t6, LOOP
	FLASH:
		li t4,0
		li s0,0xFF200604	# Escolhe o Frame 0 ou 1
		lb t1, 0(s0)
		not t1,t1
		sw t2,0(s0)
	j LOOP
	
	
