/*
	on enleve argc
	on enleve argv[0]
	i = 0			
	on recupere la clef (argv[1])
	atoi(clef) pour recuperer un entier
	on prend le modulo de la clef par 26 pour que çà reste un decalage dans l'alphabet
	on recupere le mot
	
	tant que (mot[i]!=0)
	char_courant=mot[i]
	char_courant+=clef
		if (char_courant/122<1)
			char_courant
		else
			char_courant-96
	i++
	afficher_caractere(char_courant)
	fin_tant_que
	
*/

	.data
clef:
	.quad 0

	.text
	.globl debut
debut:
	xorq %r15,%r15 #i
	pop %rax #on enleve argc
	pop %rax #on enleve argv[0]

	pop %rcx #on recupere la clef
	call atoi # on la convertit en entier
	mov $26, %r9 #on prend le modulo de la clef
	xor %rdx,%rdx
	divq %r9
	movq %rdx,clef
	
	pop %rax #on recupere notre mot à coder
tant_que:
	movb (%rax,%r15), %bl #bl est notre caractere courant
	test %rbx, %rbx
	je  fin_tq

	xorq %rdx,%rdx
	push %rax #on sauvegarde notre chaine
	movq %rbx,%rax
	addq clef,%rax
	addb clef,%bl

	mov $122,%r9
	div %r9 #on a 0 ou 1 dans rax
	
	#si char_courant/122<1)
	cmp $1,%rax
	jl alors
	subq $26,%rbx
	
alors:
	pop %rax
	incq %r15
	#AFFICHE LE CARACTERE
	push %rax 
	movq %rbx,%rsi
	call affchar
	pop %rax
	jmp tant_que

fin_tq:
	#affiche un petit \n
	xorq %r9, %r9
	movb $10, (%rax,%r9)
	inc %r9
	movb $0, (%rax,%r9)
	movq %rax, %rsi
	movq $1, %rax
	movq $1, %rdi
	movq $1, %rdx
	syscall
	

	#exit(0)
	mov $60,%rax
	xor %rdi,%rdi
	syscall
	
