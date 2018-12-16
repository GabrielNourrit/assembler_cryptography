	.data
chaine:
	.string "11"
	
	.text
	.globl affchar
affchar:
	movq $chaine,%rsi #notre chaine a afficher
	xorq %r9,%r9
	movb %bl,(%rsi,%r9) #on recup char a afficher dans rbx
	movq $1,%r9
	movb $0,(%rsi,%r9)
	
	/*write*/
	
	movq $1,%rax
	movq $1,%rdi
	movq $1,%rdx
	syscall

	ret
