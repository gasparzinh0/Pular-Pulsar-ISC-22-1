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
	li t3,0xd0d0d0d0	# cor vermelho|vermelho|vermelhor|vermelho
	LOOP: 	
		beq t1,t2,OUT		# Se for o último endereço então sai do loop
		sw t3,0(t1)		# escreve a word na memória VGA
		addi t1,t1,4		# soma 4 ao endereço
		j LOOP		# volta a verificar
OUT:
	li s1, 160
	li s2, 120
A:
	print_player(s1,s2,0x71717171)
	li, t1, 10
	wait_time(t1)
	print_player(s1,s2,0xd0d0d0d0)
	
	addi s1,s1,320
	j A
	
