.data

message_erreur:
.string "Il faut deux arguments !\n"
caratere_a_afficher:
.string " "
.text
.global debut_programme

debut_programme:
pop %rax
cmp $3, %rax # on compare le nombre d'arguments ( si < 3 on quitte)
je continuer_programme
#write message d'erreur 
mov $25, %rdx # on met le nombre de caractères dans rdx
mov $1, %rax  # on mets le numero correspondant à l'appel écrire dans rax 
mov $1, %rdi  # on écrit dans le terminal
mov $message_erreur, %rsi #on ecrit le message d'erreur
syscall
mov $60, %rax # quitte 
mov $-1, %rdi # on renvoies une valeur par défaut (-1)
syscall

continuer_programme:
pop %rax # on supprime de la pile argv[o]
pop %rax # on à argv[1] dans rax ( qui correspond à la chaine clef) (info)
pop %rbx # on recupere assembleur 

xor %r9, %r9 # le compteur de la chaine 
xor %r8, %r8 # le compteur de la clef
mov $caratere_a_afficher, %r15
xor %r10, %r10

boucle_tant_que:
xor %rcx, %rcx
xor %rdx, %rdx
movb (%rbx,%r9), %cl # on à la première case du mot de rbx dans rcx
movb (%rax,%r8), %dl #on à la premiere case de la clef dans rdx
test %rcx, %rcx # est ce que le caractere courant est 0 ?
jz fin_de_programme
inc %r9
inc %r8
test %rdx, %rdx
jnz continuer
xor %r8, %r8 # on remet le compteur de la clef a 0
movb (%rax,%r8), %dl
inc %r8
continuer:
sub $97, %rdx
add %rdx, %rcx
cmp $122, %rcx
jle inferieur_z
sub $26, %rcx
inferieur_z:
movb %cl, (%r15,%r10) # on convertit en chaine de caractère chaine[0]
push %rax
mov $1, %rdx 
mov $1, %rax  
mov $1, %rdi  
mov %r15, %rsi 
syscall
pop %rax	
jmp boucle_tant_que
	
fin_de_programme:
mov $60, %rax # quitte 
mov $0, %rdi # on renvoies une valeur par défaut (0)
syscall






