	j main

merge_sort:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $s0, 16($sp)
    slt $t5, $a1, $a2    # esq < dir 
    beq $t5, $zero, retorno    #esq >= dir retorno (caso base)
    add $s0, $a1, $a2
    srl $s0, $s0, 1    #meio em s0
    addi $a2, $s0, 0
    jal merge_sort
    lw $a2, 12($sp)
    addi $a1, $s0, 1
    jal merge_sort
    lw $a1, 8($sp)
	move $a3, $s0  #adicionando em $a3 o meio que está em $s0
    jal merge
	
retorno:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $s0, 16($sp)
    addi $sp, $sp, 20
    jr $ra
	
merge:
    addi $t0, $a3, 1    # i = meio + 1
	
for:
    slt $t5, $a2, $t0    # dir < i
    bne $t5, $zero, fora_merge
    add $t1, $t0, $zero    # k = i
	
while:
    slt $t5, $a1, $t1    # esq < k
    beq $t5, $zero, soma_i    # k <= esq
    sll $t2, $t1, 2
    add $t2, $a0, $t2
    lw $t3, 0($t2)    # a[k]
    lw $t4, -4($t2)    # a[k-1]
    slt $t5, $t3, $t4    # a[k] < a[k-1]
    beq $t5, $zero, soma_i    # já em ordem
    sw $t4, 0($t2)
    sw $t3, -4($t2)
    addi $t1, $t1, -1
    beq $zero, $zero, while
	
soma_i:
    addi $t0, $t0, 1
    beq $zero, $zero, for
	
fora_merge:
    jr $ra
	
main:
	#bloco de inicializacao do vetor, salvando com frame pointer
	#considerando o exemplo com 7 inteiros como elementos
    addi $sp, $sp, -28
    add $fp, $sp, $zero
    addi $t0, $zero, 38
    sw $t0, 0($fp)
    addi $t0, $zero, 27
    sw $t0, 4($fp)
    addi $t0, $zero, 43
    sw $t0, 8($fp)
    addi $t0, $zero, 3
    sw $t0, 12($fp)
    addi $t0, $zero, 9
    sw $t0, 16($fp)
    addi $t0, $zero, 82
    sw $t0, 20($fp)
    addi $t0, $zero, 10
    sw $t0, 24($fp)
    move $a0, $fp
	
	#atribuindo o vetor, esq e dir no a0 - a2
    addi $a1, $zero, 0
    addi $a2, $zero, 6
    jal merge_sort
	
addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $a3, $a2, 1
for_print: 
	beq $t0, $a3, fim_print
	add $t2, $fp, $t1
	lw $a0, 0($t2)
	addi $v0, $zero, 1
	syscall
	addi $v0, $zero, 11   #cod syscall de print character
	addi $a0, $zero, 32  #valor em ascii de ' '
	syscall
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	j for_print

fim_print: 
	

