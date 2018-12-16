/* -----------NIVEAU 1--------------
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
		if (char_courant/122<1) cette condition regarde si la clef + le caractere depasse le code ascii de Z
			char_courant on change rien 
		else
			sinon on revient au code ascii de a ie char_courant-96 
	i++
	afficher_caractere(char_courant)
	fin_tant_que
*/
	
/*------------NIVEAU 2--------------
	au lieu de supprimer argc on regarde combien il vaut
	si argc !=2
	  afficher :" Entrez 2 arguments !"
	et exit(1)
	sinon on lance le programme normalement
*/
	

	.data
clef:
	.quad 0
err:
	.string "Entrez 2 arguments !\n"
	.text
	.globl debut
debut:
	xorq %r15,%r15 #i
	pop %rax #on a argc dans rax
	cmp $3, %rax
	jnz errexit
	
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

errexit:

	#affiche message d'erreur
	movq $21, %rdx
	movq $1, %rdi
	movq $1, %rax
	movq $err, %rsi
	syscall

	#exit(1)
	mov $60, %rax
	movq $1, %rdi
	syscall
	
