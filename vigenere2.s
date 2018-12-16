/*----------------NIVEAU 2----------------------
on recupere argc
si argc !=2
	afficher :" Entrez 2 arguments !"
	exit(1)
sinon{
	on enleve argv[0]
	on recup la clef dans un registre
	le mot dans un autre
	i=0
	j=0
	tq mot[i]!=0 ---on parcourt la chaine
	test=mot[i]
	if test>122 ou test<97
		si majuscule
			alors on transforme en minuscule ('a'-'A')
		si (mot[i-1] != '.' ou i=0)
			afficher '.'
			ecrire '.' dans mot[i]
	sinon{
		if clef[j]=0 --- si la clef est finie
			j=0  --- on la reparcours
			clef[j]-97=decalage  --- 'a' ayant 97 comme code ASCII
			char_courant = mot[i] + decalage
		if (char_courant/123<1) cette condition regarde si le decalage + le caractere depasse le code ascii de Z
			char_courant ---on change rien 
		else
			char_courant-26 ---on revient au code ascii de a
		i++
		si mot[i]!='.'
			j++
		afficher_caractere(char_courant)
	fin_tant_que
	exit(0)
	}
*/


	.data
decalage:
	.quad 0
err:
	.string "Entrez 2 arguments !\n"
	.text
	.globl debut
debut:
	pop %rax #on a argc dans rax
	cmp $3, %rax #on regarde qu'il y a bien 2 arguments
	jnz errexit

	pop %rax #on enleve argv[0]
	pop %rbx #on recupere la clef
	pop %rax #on recupere le mot
	xor %r12,%r12 #i
	xor %r13,%r13 #j
	#on va aussi utiliser R15 comme registre temporaire

tant_que:
	xorq %rcx,%rcx
	movb (%rax,%r12), %cl #cl notre caractere courant du mot
	test %rcx, %rcx       #on regarde si notre chaine est terminée
	je fin_tq

	movq $122,%r15
	cmp %r15, %rcx #si ASCII>122
	jg point       #alors on regarde si y a un point

	movq $97,%r15 
	cmp %r15, %rcx #si ASCII<97
	jl maj         #alors on regarde si y a majuscule

	#sinon on transforme normalement
	jmp transform

maj:	
	#sinon on va allez chercher les majuscules A:65, Z:90
	movq $65, %r15
	cmp %r15, %rcx #si ASCII <65
	jl point       #on va voir si on ecrit un point ou pas

	movq $90, %r15
	cmp %r15, %rcx #si ASCII >90
	jg point       #on va voir si on ecrit un point ou pas

	addq $32, %rcx #on ajoute 'a'-'A' pour transformer en minuscule
	jmp transform  #puis on transforme notre mot normalement

point:	
	test %r12, %r12 #si i=0
	je affpoint2    #on affiche un point

	movq %r12,%r15
	decq %r15 #on recup i-1


	push %rdx
	xorq %rdx,%rdx
	movb (%rax,%r15),%dl #on recup mot[i-1]
	movq $46, %r15 #on met '.' dans r15
	movq %rdx, %rsi
	pop %rdx
	
	cmp %rsi, %r15
	je tra       #si mot[i-1]= '.',on ecrit . dans mot[i] puis on passe au caractere suivant

affpoint2:
	movb $46, (%rax,%r12) #on ecris . dans mot[i]
	xorq %rcx, %rcx
	movb $46, %cl #on met . le caractere a afficher
	push %rax     
	jmp alors

tra:
	movb $46, (%rax,%r12) #on ecris . dans mot[i]
	jmp next

	
transform:	
	movb (%rbx,%r13), %dl #dl le caractere courant de la clef
	test %rdx, %rdx       #si la clef est finie (bout du mot)
	jne sinon
	xorq %r13,%r13        #alors on la reparcours du debut
	movb (%rbx,%r13), %dl #(on met j=0 et on prend clef[j] dans rdx)
sinon:
	movq $97, %r15 # r15 est mon registre temporaire tout au long du programme 
	push %rdx      # sauvegarde de rdx
	subq %r15, %rdx # clef[j]-97
	movq %rdx, decalage #on recupere le decalage dans notre variable
	pop %rdx       #chargement de rdx
	
	addq decalage, %rcx # mot[i] += dec
	
	push %rax # (on save notre mot)
	push %rcx #_______________caractere

	xorq %rdx,%rdx #pour la division rdx:rax/123
	movq %rcx, %rax #idem
	movq $123,%r15 #idem
	divq %r15 #on a 0 ou 1 dans rax (1 si caractere>'z')
	pop %rcx
	incq %r13 #j++ (on incremente j la case de clef seulement si le caractere est une majuscule ou une minuscule et pas un autre caractere)
	cmp $1,%rax #si (mot[i]/123<1)
	jl alors
	subq $26,%rcx # si il est + grand on le renvoie au debut de l'alphabet
	
alors:	
	#AFFICHE LE CARACTERE
	push %rbx      #sauvegarde de notre clef
	mov %rcx,%rbx  #on envoie notre caractere dans rbx pour affchar
	call affchar
	pop %rbx
	pop %rax

next:	
	incq %r12      #i++
	jmp tant_que
	
fin_tq:
	#affiche un petit \n
	movb $10, %bl
	call affchar

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
