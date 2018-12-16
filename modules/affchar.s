	.data
chaine:
	.string "1"
	
	.text
	.globl affchar
affchar:
	movq $chaine,%rsi #notre chaine a afficher
	xorq %r9,%r9
	movb %bl,(%rsi,%r9) #on recup char a afficher dans rbx
	incq %r9
	movb $0,(%rsi,%r9) #on met 0 pour fermer la chaine
	
	/*write*/ 
	
	movq $1,%rax # et on l'affiche
	movq $1,%rdi
	movq $1,%rdx
	syscall

	ret
