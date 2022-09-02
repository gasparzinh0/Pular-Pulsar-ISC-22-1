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
MAIN:
	li s0, MMIO_set
POOLING_LOOP:
	lb t1, 0(s0)
	beqz t1, POOLING_LOOP	# ready bit == 0
	lw a0, MMIO_add		# Dados MMIO
	
	syscall(11)
	
	li t2, 0x41
	beq t2, a0, RED
	li t2, 0x42
	beq t2, a0, GREEN
	j POOLING_LOOP
	exit()
RED:
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 1
	sw t2,0(s0)		# seleciona a Frame t2
	# Preenche a tela de vermelho
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	li t3,0x07070707	# cor vermelho|vermelho|vermelhor|vermelho
	LOOP: 	
		beq t1,t2,MAIN		# Se for o último endereço então sai do loop
		sw t3,0(t1)		# escreve a word na memória VGA
		addi t1,t1,4		# soma 4 ao endereço
		j LOOP		# volta a verificar
GREEN:	
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,1			# inicio Frame 1
	sw t2,0(s0)		# seleciona a Frame t2

	li t1,0xFF100000	# endereco inicial da Memoria VGA - Frame 1
	li t2,0xFF112C00	# endereco final
	li t3,0x70707070	# cor vermelho|vermelho|vermelhor|vermelho
	LOOP2: 	
		beq t1,t2,MAIN		# Se for o último endereço então sai do loop
		sw t3,0(t1)		# escreve a word na memória VGA
		addi t1,t1,4		# soma 4 ao endereço
		j LOOP2			# volta a verificar
