# java -jar .\Mars4_5.jar .\LECTURE.asm pa sudoku.txt
# pour executer il faut passer le nom du texte en argument
				.data
				.align 2
lecture:			.space 118
				.align 2
tableau:			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
nom_du_fichier:			.space 1
				.text


# Ouverture fichier
				ori $v0, $0, 13		# syscall : ouvrir fichier
				lw $a0, ($a1)		# $a0 : nom du fichier = argc[0]
				ori $a1, $0, 0		# $a1 : 0 = read ; 1 = write
				ori $a2, $0, 0		# $a2 : mode - je sais pas a quoi ca sert
				syscall			# ouvrir fichier
				move $t0, $v0		# on garde FILE* pour la lecture


# Lecture fichier
				ori $v0, $0, 14		# syscall : ouvrir fichier
				move $a0, $t0		# pointeur du fichier FILE*
				la $a1, lecture		# destination des caracteres lus
				ori $a2, $1, 119	# nb de caracteres a lire  #'\n' = 2 char
				syscall			# lire fichier
				
# Conversion en tableau d'entiers				
				la $t0, lecture		# pointeur lecture
				la $t2, tableau		# tableau SUDOKU
lire:				lb $t1, ($t0)		# valeur pointée
				blt $t1, '1', nan	#	- si cest plus petit que 1 cest pas un chiffre
				bgt $t1, '9', nan	#	- si cest plus grand que 9 cest pas un chiffre
				j eff
nan:							# si c'est pas un chiffre cest : soit X, soit ' ', soit '\n'
				bne $t1, 'X', t		# si cest pas un X on passe au suivant, sans rien faire
				ori $t1, $0, '0'	# si cest un X, on envoie un 0
				
eff:				
				subi $t1, $t1, '0'	# on enleve '0' pour convertir le ASCII en int
				sb $t1, 0($t2)		# on met l'entier ds la destination
				addi $t2, $t2, 1	# &destination[i] ++
				addi $t3, $t3, 1	# i++ : compteur tours de boucle
t:				
				addi $t0, $t0, 1	# &source[i] ++
				blt $t3, 81, lire

# Affichage
				ori $v0, $0, 1
				ori $t3, $0, 3
				ori $t2, $0, 0
				la $t0, tableau
affiche:			lb $a0, ($t0)
				div $t2, $t3
				mfhi $t4
				beqz $t4, espace
call:				syscall
				addi $t0, $t0, 1
				addi $t2, $t2, 1
				blt $t2, 81, affiche
				j fin

espace:				ori $t3, $0, 9
				div $t2, $t3
				ori $t3, $0, 3
				mfhi $t4
				beqz $t4, newline
				ori $v0, $0, 11
				ori $a0, $0, 32		
				syscall
				lb $a0, ($t0)
				ori $v0, $0, 1
				j call



newline:
				ori $t3, $0, 27
				div $t2, $t3
				ori $t3, $0, 3
				mfhi $t4
				ori $v0, $0, 11		# affiche char
				ori $a0, $0, 10		# affiche newline 
				syscall
				beqz $t4, newline2
				j rien
				
newline2:			syscall
				
rien:				
				lb $a0, ($t0)		# remet le caractere lu pour l'affichage
				ori $v0, $0, 1		# affiche int
				j call



#				ori $v0, $0, 1
				
#				ori $t2, $0, 0
#				la $t0, tableau
#affiche:			lb $a0, ($t0)
#				syscall
#				addi $t0, $t0, 1
#				addi $t2, $t2, 1
#				blt $t2, 81, affiche






































































































































fin:
				ori $v0, $0, 10
				syscall
