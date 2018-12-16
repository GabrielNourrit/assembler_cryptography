	.data
base:
	.quad 10
	
	.text
.global atoi
atoi:
        xor %rax, %rax # RAX = 0
        xor %r9, %r9   # R9 = 0

tant_que:
	movb (%rcx, %r9), %bl # BL = RCX[R9]
        test %bl,%bl    # BL = 0 ?
        jz fin          # alors fini
        subb $48, %bl   # BL -= 48
        mulq base       # RAX *= 10
        add %rbx, %rax  # RAX += RBX
        inc %r9		# R9 ++
        jmp tant_que
fin:
	movb $0, (%rcx, %r9) # BL
	
	ret
