# # # # # # # #  
# CONSTANTES 
# # # # # # # # 
.eqv MMIO_add 0xff200004 # Receiver Data Register (ASCII)
.eqv MMIO_set 0xff200000 # Receiver Control Register (Bool) : 1=dados, restaura pra 0 automaticamente quando usa lw MMIO_add


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

.macro get_time(%reg)
	syscall(30)
	mv %reg, a0
.end_macro

.macro sleep(%reg)
	mv a0, %reg
	syscall(32)
.end_macro

.macro print_str(%reg)
	syscall(4, %reg)
.end_macro

.macro print_int(%int)
	syscall(1, %int)
.end_macro

.macro print_int(%reg)
	mv a0, %reg
	syscall(1)
.end_macro

.macro print_char(%int)
	syscall(11, %int)
.end_macro

.macro get_time (%reg)
	li a7, 30
	ecall
	mv %reg, a0
.end_macro

.macro wait_time (%reg)
	mv a0, %reg
	li a7, 32
	ecall
.end_macro

.macro wait_frame (%reg) 
	# reg = old time
	# 1 frame = 33ms
	# return reg = new time
	get_time(t0)
	sub t0, t0, %reg
	li t1, 33
	
	bge t0, t1, SKIP_WAIT
	sub t1, t1, t0
	wait_time(t1)
	SKIP_WAIT: get_time(%reg)
.end_macro

.macro read_input(%reg)
	lw %reg, MMIO_add
.end_macro
 
.macro DEBUG_SCREEN_RED()   # FRAME 0
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 0
	sw t2,0(s0)		# seleciona a Frame t2
	# Preenche a tela de vermelho
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	li t3,0x07070707	# cor vermelho|vermelho|vermelhor|vermelho
	LOOP: 	
		beq t1,t2,OUT		# Se for o último endereço então sai do loop
		sw t3,0(t1)		# escreve a word na memória VGA
		addi t1,t1,4		# soma 4 ao endereço
		j LOOP		# volta a verificar
	OUT:
.end_macro

.macro DEBUG_SCREEN_GREEN() # FRAME 1
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,1			# inicio Frame 1
	sw t2,0(s0)		# seleciona a Frame t2

	li t1,0xFF100000	# endereco inicial da Memoria VGA - Frame 1
	li t2,0xFF112C00	# endereco final
	li t3,0x70707070	# cor vermelho|vermelho|vermelhor|vermelho
	LOOP: 	
		beq t1,t2,OUT		# Se for o último endereço então sai do loop
		sw t3,0(t1)		# escreve a word na memória VGA
		addi t1,t1,4		# soma 4 ao endereço
		j LOOP			# volta a verificar
	OUT:
.end_macro


.macro NEXT_FRAME() # Avancar frame
	li s0,0xFF200604	
	lw t2,0(s0)	
	xori t2,t2, 1
	sw t2,0(s0)		
.end_macro 

.macro SETUP_REGS()
	li s1, 20
	li s2, 20
	li s3, 0xFF000000
.end_macro