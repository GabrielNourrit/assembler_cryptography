/* -----------ALGO--------------
si argc !=2
	afficher :" Entrez 2 arguments !"
	et exit(1)
sinon {
	on enleve argv[0]
	i = 0
	on recupere la clef (argv[1])
	atoi(clef) pour recuperer un entier
	on prend le modulo de la clef par 26 pour que çà reste un decalage dans l'alphabet
	on recupere le mot
	
	tant que (mot[i]!=0){
		char_courant=mot[i]
		char_courant+=clef
		if (char_courant/123>0) cette condition regarde si la clef + le caractere depasse le code ascii de Z
			alors on revient au code ascii de a ie char_courant-96 
		i++
		afficher_caractere(char_courant)
	}fin_tant_que
	exit(0)
}
	
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
	jnz errexit #on verifie que argc = 3 sinon on sort en erreur
	
	pop %rax #on enleve argv[0]

	pop %rcx #on recupere la clef
	call atoi # on la convertit en entier
	mov $26, %r9  #on prend le modulo de la clef
	xor %rdx,%rdx #idem (rdx a 0 pour la division rdx:rax/26)
	divq %r9      #idem (division)
	movq %rdx,clef #on recupere notre clef
	
	pop %rax #on recupere notre mot à coder
tant_que:
	movb (%rax,%r15), %bl #bl est notre caractere courant
	test %rbx, %rbx       # si notre chaine est finie on sort de la boucle
	je  fin_tq

	xorq %rdx,%rdx        #on remet toujours rdx à 0 pour la division l64
	push %rax             #on sauvegarde notre chaine
	movq %rbx,%rax        #on save notre caractere courant
	addq clef,%rax        #on met une copie de notre caractere courant additionner a la clef
	addb clef,%bl         #idem

	mov $123,%r9         #on va diviser rax par 123 pour voir si le caractere courant depasse 'z' qui vaut 122
	div %r9              #on a 0 ou 1 dans rax, celon si 0: c'est ok 1: çà depasse
	
	#si char_courant/123<1) on continue
	cmp $1,%rax
	jl alors
	subq $26,%rbx  #sinon on soustrait la taille de l'alphabet
	
alors:
	incq %r15      #on met r15 +=1 pour preparer la suite du parcours de la chaine

	#AFFICHE LE CARACTERE
	call affchar  #on affiche le caractere stocké dans rbx
	pop %rax      #on recupere notre mot a coder qui trainait dans la pile
	jmp tant_que

fin_tq:
	#affiche un petit \n pour l'affichage
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
	
