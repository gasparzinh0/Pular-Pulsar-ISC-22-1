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

.macro print_int(%reg)
	mv a0, %reg
	syscall(11)
.end_macro