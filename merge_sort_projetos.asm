Main: 
	#bloco de inicializacao do vetor, salvando com frame pointer
	#considerando o exemplo com 7 inteiros como elementos
	addi $sp, $sp, -28 
	move $fp, $sp
    lui   $t0, 38     #li = load immediate (pseudoinstrucao) rd = imm
    sw   $t0, 0($fp)
    lui   $t0, 27
    sw   $t0, 4($fp)
    lui   $t0, 43
    sw   $t0, 8($fp)
    lui   $t0, 3
    sw   $t0, 12($fp)
    lui   $t0, 9
    sw   $t0, 16($fp)
    lui   $t0, 82
    sw   $t0, 20($fp)
    lui   $t0, 10
    sw   $t0, 24($fp)
	
	#atribuindo o vetor, esq e dir no a0 - a2
	move $a0, $fp  #move -> rd = rs
	lui $a1, 0
	lui $a2, 6
	jal merge_sort
	lui $v0, 10
	syscall
	
	#merge_sort
merge_sort: 
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $s0, 16($sp)
	bge $a1, $a2, retorno  #esq >= dir retorna
	add $s0, $a1, $a2
	srl $s0, $s0, 1  #meio em s0
	addi $a2, $s0, 0
	jal merge_sort
	lw $a2, 12($sp)
	addi $a1, $s0, 1
	jal merge_sort
	lw $a1, 8($sp)
	jal merge
retorno:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $s0, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
	#merge
merge: 
	addi $t0, $s0, 1 #$t0 = meio + 1
for: 
	bgt $t0, $a2, fora_merge
	move $t1, $t0 
while: 
	ble $t1, $a1, soma_i
	sll $t2, $t1, 2
	add  $t2, $a0, $t2          # $t2 = &a[k]
    lw   $t3, 0($t2)            # a[k]
    lw   $t4, -4($t2)           # a[k-1]
    ble  $t4, $t3, soma_i       # já está em ordem
    sw   $t4, 0($t2)            # troca
    sw   $t3, -4($t2)
    addi $t1, $t1, -1           # k--
    j    while
soma_i:
	addi $t0, $t0, 1            # i++
    j    for
fora_merge:
    jr   $ra