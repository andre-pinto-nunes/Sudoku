# java -jar .\Mars4_5.jar .\LECTURE.asm pa sudoku.txt
# pour executer il faut passer le nom du texte en argument
					.data
					.align 	2
lecture:				.space 	118
					.align 	2
tableau:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
nom_du_fichier:				.space 	1
#					.align 	2
end:					.word 	0 #ne sert a rien
small_tab:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0
cle:					.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
tab_merge:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
size_of_key:				.word 	0 
arg1:					.word 	0
arg2:					.word 	0

					.text
				
# LECTURE
#####################################################################################################

# Ouverture fichier
					ori 	$v0, $0, 13		# syscall : ouvrir fichier
					lw 	$a0, ($a1)		# $a0 : nom du fichier = argc[0]
					ori 	$a1, $0, 0		# $a1 : 0 = read ; 1 = write
					ori 	$a2, $0, 0		# $a2 : mode - je sais pas a quoi ca sert
					syscall				# ouvrir fichier
					move 	$t0, $v0		# on garde FILE* pour la lecture


# Lecture fichier
					ori 	$v0, $0, 14		# syscall : ouvrir fichier
					move	$a0, $t0		# pointeur du fichier FILE*
					la 	$a1, lecture		# destination des caracteres lus
					ori 	$a2, $0, 119		# nb de caracteres a lire  #'\n' = 2 char
					syscall				# lire fichier
				
# Conversion en tableau d'entiers				
					la 	$t0, lecture		# pointeur lecture
					la 	$t2, tableau		# tableau SUDOKU
					lw 	$t4, end		# somme des chiffres du tableau
					lw 	$t5, size_of_key	# taille de la cle, nombre de cases vides du tableau
lire:					lb 	$t1, ($t0)		# valeur pointee
					blt 	$t1, '1', nan		#	- si cest plus petit que 1 cest pas un chiffre
					bgt 	$t1, '9', nan		#	- si cest plus grand que 9 cest pas un chiffre
					j 	eff
nan:									# si c'est pas un chiffre cest : soit X, soit ' ', soit '\n'
					bne 	$t1, 'X', t		# si cest pas un X on passe au suivant, sans rien faire
					ori 	$t1, $0, '0'		# si cest un X, on envoie un 0
					addi 	$t4, $t4, 1       	# on augmente le compteur de cases vides (size_ofkey)
				
eff:				
					subi 	$t1, $t1, '0'		# on enleve '0' pour convertir le ASCII en int
					add 	$t5, $t5, $t1		# on augmente la variable end (somme des chiffres du tableau)
					sb 	$t1, 0($t2)		# on met l'entier ds la destination
					addi 	$t2, $t2, 1		# &destination[i] ++
					addi 	$t3, $t3, 1		# i++ : compteur tours de boucle
t:				
					addi 	$t0, $t0, 1		# &source[i] ++
					blt 	$t3, 81, lire
					
					sw 	$t4, size_of_key
					sw 	$t5, end
						
# FIN LECTURE				
#####################################################################################################
					la 	$t0, cle
					lw 	$t2, end


loop:				
					lb 	$t1, ($t0)			# KEY[i]
					addi 	$t1, $t1, 1			# KEY[i]++
					sb 	$t1, ($t0)
					ble 	$t1, 9, finloop
					sub 	$t2, $t2, $t1 			# end -= KEY[i]
					addi 	$t2, $t2, 1			# end ++
					#subi 	$t2, $t2, 9
					ori 	$t1, $0, 0			# KEY[i]=0
					sb 	$t1, ($t0)
					subi 	$t0, $t0, 1			# i--
					j 	loop
finloop:				
					addi 	$t2, $t2, 1			# end ++				
				

					sw 	$t0, arg1
					sw 	$t1, arg2
					sw 	$t2, end
					jal 	FONCTION_MERGE
					jal 	FONCTION_CHECK
					lw 	$t0, arg1
					lw 	$t1, arg2
					lw 	$t2, end
				
					beqz 	$t3, loop
					addi 	$t0, $t0, 1
					#ori	$v0, $0, 1
					#ori	$a0, $t2, 0
					#syscall
					#ori	$v0, $0, 11
					#ori	$a0, $0, 10
					#syscall
					#lw 	$t8, size_of_key
					#subi 	$t8, $t8, 1
					lb 	$t9, cle + 56

					#beqz 	$t9, loop
					bne 	$t2, 405, loop																																																																																																																																																																																																																																																																																																																												
					
# Affichage
					ori 	$v0, $0, 1
					ori 	$t3, $0, 3
					ori 	$t2, $0, 0
					la 	$t0, tab_merge
affiche:				lb 	$a0, ($t0)
					div 	$t2, $t3
					mfhi 	$t4
					beqz 	$t4, espace
call:					syscall
					addi 	$t0, $t0, 1
					addi 	$t2, $t2, 1
					blt 	$t2, 81, affiche
					j 	fin

espace:					ori 	$t3, $0, 9
					div 	$t2, $t3
					ori 	$t3, $0, 3
					mfhi 	$t4
					beqz 	$t4, newline
					ori 	$v0, $0, 11
					ori 	$a0, $0, 32		
					syscall
					lb 	$a0, ($t0)
					ori 	$v0, $0, 1
					j 	call



newline:
					ori 	$t3, $0, 27
					div 	$t2, $t3
					ori 	$t3, $0, 3
					mfhi 	$t4
					ori 	$v0, $0, 11		# affiche char
					ori 	$a0, $0, 10		# affiche newline 
					syscall
					beqz 	$t4, newline2
					j 	rien

newline2:				syscall
				
rien:				
					lb 	$a0, ($t0)		# remet le caractere lu pour l'affichage
					ori 	$v0, $0, 1		# affiche int
					j 	call
																																																																																																																																																																																																																																																																																																																																											
fin:																																																																																																																																																																																																																																																																																																																																																
					#end
					ori 	$v0, $0, 10
					syscall
				
############################### FONCTIONS ###############################

# MERGE
########
FONCTION_MERGE:
					la 	$t1, tableau		# &tableau[i]++
					la 	$t2, cle		# &cle[i]++
					la 	$t3, tab_merge		# &tab_merge[i]++
					ori 	$t6, $0, 0 
				
load:					lb 	$t4, ($t1)		# tableau[i]
					lb 	$t5, ($t2)		# cle[i]
				
					beqz 	$t4, store_from_key	
					
					sb 	$t4, ($t3)		# si tableau[i] != 0 , alors, merge[i] = tab[i]
					j 	continue
				
store_from_key:				sb 	$t5, ($t3)		# si tableau[i] == 0 , alors, merge[i] = cle[i]
					addi 	$t2, $t2, 1
				
continue:
					addi 	$t1, $t1, 1
					addi 	$t3, $t3, 1
					addi 	$t6, $t6, 1
					blt 	$t6, 81, load
				
					jr  	$ra

					# Affichage
					ori 	$v0, $0, 1
					ori 	$t3, $0, 3
					ori 	$t2, $0, 0
					la 	$t0, tab_merge
affiche1:				lb 	$a0, ($t0)
					div 	$t2, $t3
					mfhi 	$t4
					beqz 	$t4, espace1
call1:					syscall
					addi 	$t0, $t0, 1
					addi 	$t2, $t2, 1
					blt 	$t2, 81, affiche1
					jr 	$ra
					j 	FONCTION_CHECK

espace1:				ori 	$t3, $0, 9
					div 	$t2, $t3
					ori 	$t3, $0, 3
					mfhi 	$t4
					beqz 	$t4, newline1
					ori 	$v0, $0, 11
					ori 	$a0, $0, 32		
					syscall
					lb 	$a0, ($t0)
					ori 	$v0, $0, 1
					j 	call1



newline1:
					ori 	$t3, $0, 27
					div 	$t2, $t3
					ori 	$t3, $0, 3
					mfhi 	$t4
					ori 	$v0, $0, 11		# affiche char
					ori 	$a0, $0, 10		# affiche newline 
					syscall
					beqz 	$t4, newline21
					j 	rien1
				
newline21:				syscall
				
rien1:				
					lb 	$a0, ($t0)		# remet le caractere lu pour l'affichage
					ori 	$v0, $0, 1		# affiche int
					j 	call1


# CHECK
########
FONCTION_CHECK:

#######################################################################################################
					#check lignes
					ori $t1, $0, 0							# i: indice de la case (ligne*9 + colonne)
for_lignes:			
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];
					ori $t2, $0, 0							#- j: indice de la case de la ligne (colonne)

forfor_lignes:
					lb $t4, tab_merge($t1)
					ori $t3, $0, 0							#-- k: indice de small_tab
				
forforfor_lignes:											#--- on parcourt small_tab
					lb $t5, small_tab($t3)

					bne $t4, $t5, no_problemo_lignes		#--- si tableau[ligne*9 + colonne] != small_tab[k] -> pas de probleme
					beqz $t5, no_problemo_lignes			#--- si small_tab[k] == 0 							-> pas de probleme
					j return_0
no_problemo_lignes:				
					addi $t3, $t3, 1						#--- k++
					blt $t3, 9, forforfor_lignes

					sb $t4, small_tab($t2)					#-- on met le chiffre dans small_tab
					addi $t2, $t2, 1						#-- j++
					addi $t1, $t1, 1						#-- i++
					blt $t2, 9, forfor_lignes

					blt $t1, 81, for_lignes


#######################################################################################################
					#check colonnes
					ori $t1, $0, 0							# i: indice de la case (ligne*9 + colonne)
for_colonnes:			
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];
					ori $t2, $0, 0							#- j: indice de la case de la ligne (colonne)

forfor_colonnes:
					lb $t4, tab_merge($t1)
					ori $t3, $0, 0							#-- k: indice de small_tab
				
forforfor_colonnes:											#--- on parcourt small_tab
					lb $t5, small_tab($t3)

					bne $t4, $t5, no_problemo_colonnes		#--- si tableau[ligne*9 + colonne] != small_tab[k] -> pas de probleme
					beqz $t5, no_problemo_colonnes			#--- si small_tab[k] == 0 							-> pas de probleme
					j return_0
no_problemo_colonnes:				
					addi $t3, $t3, 1						#--- k++
					blt $t3, 9, forforfor_colonnes

					div $t6, $t2, 9							#-- $t6 = colonne = $t2 / 9
					sb $t4, small_tab($t6)
					addi $t2, $t2, 9						#-- j+=9 (on se deplace sur une colonne (verticale <=> +9))
					addi $t1, $t1, 9						#-- i+=9 (on se deplace sur une colonne (verticale <=> +9))
					blt $t6, 8, forfor_colonnes
					subi $t2, $t2, 9						#- a la fin du dernier branch, on depasse les limites donc on fait un subi
					subi $t1, $t1, 9						#- " "  "   "  "       "       "  "       "   "       "    "  "    "  "
					subi $t1, $t1, 71						#- quand on arrive a la fin d'une colonne: $t1 -= 72 pour remonter en haut de la colonne et $t1 +=1 pour passer a la colonne suivante
					blt $t1, 9, for_colonnes


#######################################################################################################
					#check cellules
					ori $t1, $0, 0							# i: indice de la case (cellule*9 + colonne)
					ori $t2, $0, 0
					ori $t3, $0, 0
for1:
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];

					ori $t4, $0, 0
					ori $t5, $0, 0
					ori $t9, $0, 0
for4:
					lb $t7, tab_merge($t1)
					ori $t6, $0, 0							#-- k: indice de small_tab				
smalltab_cellules:											#--- on parcourt small_tab
					lb $t8, small_tab($t6)

					beqz $t8, no_problemo_cellules			#--- si small_tab[k] == 0 							-> pas de probleme
					bne $t7, $t8, no_problemo_cellules		#--- si tableau[cellule*9 + colonne] != small_tab[k] -> pas de probleme
					j return_0
no_problemo_cellules:				
					addi $t6, $t6, 1						#--- k++
					blt $t6, 9, smalltab_cellules

					sb $t7, small_tab($t9)					#-- on met le chiffre dans small_tab
					addi $t9, $t9, 1
					addi $t1, $t1, 1
					addi $t5, $t5, 1
					blt $t5, 3, for4

					ori $t5, $0, 0
					addi $t1, $t1, 6
					addi $t4, $t4, 1
					blt $t4, 3, for4
					
					addi $t3, $t3, 1
					blt $t3, 3, for1
					
					ori $t3, $0, 0
					subi $t1, $t1, 78
					addi $t2, $t2, 1
					blt $t2, 3, for1

return_1:				ori $t3, $0, 1
					jr $ra

return_0:				ori $t3, $0, 0
					jr $ra
