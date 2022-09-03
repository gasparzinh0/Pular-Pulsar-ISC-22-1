.macro print_player(%reg, %reg2, %int)
	mv t0, %reg
	mv t1, %reg2
	
	
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 1
	sw t2,0(s0)		# seleciona a Frame 
	
	li t3, %int
	li t2, 0xFF000000
	
	add t0, t2, t0 # Pos X
	
	li t4, 320
	mul t1, t1, t4 # Pos Y

	add t1, t0, t1
	li t4, 11
	VERT_DRAW:
		sw t3, 0(t1)
		sw t3, 4(t1)
		sw t3, 8(t1)
		
		addi t1, t1,320
		addi t4,t4,-1
		bgez t4, VERT_DRAW

.end_macro
.include "MACROS.s"
.text
MAIN:
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 1
	sw t2,0(s0)		# seleciona a Frame t2
	# Preenche a tela
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	li t3,0x82828282	# cor vermelho|vermelho|vermelhor|vermelho
	LOOP: 	
		beq t1,t2,OUT		# Se for o último endereço então sai do loop
		sw t3,0(t1)		# escreve a word na memória VGA
		addi t1,t1,4		# soma 4 ao endereço
		j LOOP		# volta a verificar
OUT:
	li s1, 160
	li s2, 120
	print_player(s1,s2,0x71717171)

POOLING_LOOP:
	li s0, MMIO_set
	lb t1, 0(s0)
	beqz t1, POOLING_LOOP	# ready bit == 0
	lw a0, MMIO_add		# Dados MMIO
	
	syscall(11)
	
	li t2, 119
	beq t2, a0, UP
	li t2, 115
	beq t2, a0, DOWN
	li t2, 97
	beq t2, a0, LEFT
	li t2, 100
	beq t2, a0, RIGHT
	j POOLING_LOOP
	exit()
UP:
	print_player(s1,s2,0x82828282)
	addi s2,s2,-4
	print_player(s1,s2,0x71717171)
	j POOLING_LOOP
DOWN:
	print_player(s1,s2,0x82828282)
	addi s2,s2,4
	print_player(s1,s2,0x71717171)
	j POOLING_LOOP
LEFT:
	print_player(s1,s2,0x82828282)
	addi s1,s1,-4
	print_player(s1,s2,0x71717171)
	j POOLING_LOOP
RIGHT:
	print_player(s1,s2,0x82828282)
	addi s1,s1,4
	print_player(s1,s2,0x71717171)
	j POOLING_LOOP
