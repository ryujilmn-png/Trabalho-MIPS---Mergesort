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
	#parte que espera a entrada do valor de n e atribuindo a t0 
	addi $v0, $zero, 5
	syscall 
	move $t0, $v0
	
	sll $t1, $t0, 2   #t1 = n * 4 bytes
	sub $sp, $sp, $t1  #aloca na pilha 
	move $fp, $sp     #guarda em $fp fixo o inicio do vetor (v[0])
	
	addi $t2, $zero, 0  #inicializa i = 0
	addi $t3, $zero, 0  #temp que vai aumentar de 4 em 4 p/ fp 
inicio_vetor: 
	beq $t2, $t0, vetor_pronto
	add $t5, $fp, $t3  #coloca em t5 o offset do endereço de fp
	
	#parte que espera a entrada do valor do elemento
	addi $v0, $zero, 5
	syscall 
	move $t4, $v0
	
	sw $t4, 0($t5)  #valor do elemento em $t4
	addi $t3, $t3, 4  #t3 + 4
	addi $t2, $t2, 1  #i++
	j inicio_vetor

vetor_pronto: 
	move $a0, $fp   #em $a0 fica o endereço de v[0] 
	
	#atribuindo esq e dir no a1 e a2
    addi $a1, $zero, 0
    addi $a2, $t0, -1   #tam_vet = n - 1
    jal merge_sort
   
