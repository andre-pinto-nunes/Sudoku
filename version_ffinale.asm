# java -jar .\Mars4_5.jar .\LECTURE.asm pa sudoku.txt
# pour executer il faut passer le nom du texte en argument
					.data

# stockage des caracteres lus dans le fichier
lecture:				.space 	118
					.align 	2

# tableau sudoku à résoudre
tableau:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# nom du fichier contenant le tableau
nom_du_fichier:				.space 	1
					.align 	2
					
# liste des chiffres déjà trouvés dans une ligne/colonne/cellule - (fonction vérification)
small_tab:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0

# clé calculée dans le main qui résout le sudoku
cle:					.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

					#.align 2
taille_de_la_cle:			.byte   0
tab_fusion:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 

			.text
				
# LECTURE
#####################################################################################################

# Ouverture fichier
					ori 	$v0, $0, 13		# syscall : ouvrir fichier
					lw 	$a0, ($a1)		# $a0 : nom du fichier = argc[0]
					ori 	$a1, $0, 0		# $a1 : 0 = read ; 1 = write
					ori 	$a2, $0, 0		# $a2 : mode - ?
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
lire:					lb 	$t1, ($t0)		# valeur pointee
					blt 	$t1, '1', nan		#	- si cest plus petit que 1 cest pas un chiffre
					bgt 	$t1, '9', nan		#	- si cest plus grand que 9 cest pas un chiffre
					j 	eff
nan:									# si c'est pas un chiffre c'est : soit X, soit ' ', soit '\n'
					bne 	$t1, 'X', t		# si cest pas un X on passe au suivant, sans rien faire
					ori 	$t1, $0, '0'		# si cest un X, on envoie un 0
					addi	$t4, $t4, 1             # on compte le nombre de '0' dans $t4, cela correspond à la taille de la clé
				
eff:				
					subi 	$t1, $t1, '0'		# on enleve '0' pour convertir le ASCII en int
					sb 	$t1, 0($t2)		# on met l'entier ds la destination
					addi 	$t2, $t2, 1		# &destination[i] ++
					addi 	$t3, $t3, 1		# i++ : compteur tours de boucle
t:				
					addi 	$t0, $t0, 1		# &source[i] ++
					blt 	$t3, 81, lire
					
# Fermeture du fichier

					move	$a0, $v0		# pointeur vers le fichier à fermer
					ori	$v0, $0, 16		# syscall: fermer fichier
					syscall				# fermeture du fichier

# FIN LECTURE				
#####################################################################################################


# Main #
					sb	$t4, taille_de_la_cle
					la 	$t0, cle
loop:				
					lb 	$t1, ($t0)			# KEY[i]
					addi 	$t1, $t1, 1			# KEY[i]++
					sb 	$t1, ($t0)
					ble 	$t1, 9, pas_de_depassement	
					subi 	$t2, $t2, 9			# end -= 9
					ori 	$t1, $0, 0			# KEY[i]=0
					sb 	$t1, ($t0)
					subi 	$t0, $t0, 1			# i--
					j 	loop
pas_de_depassement:				
					ori	$fp, $sp, 0			# fp prend la valeur de sp
					addi	$sp, $sp, 12			# on avance sp de 12 bytes pour pouvoir stocker 3 mots
					
					sw 	$t0, 0($fp)			#
					sw 	$t1, 4($fp)			# on stocke les registres entre fp et sp
					sw 	$t2, 8($fp)			#
					
					jal 	Fonction_Fusion			# appel de fusion
					jal 	Fonction_Verification		# appel de verification
					
					lw 	$t0, 0($fp)			#
					lw 	$t1, 4($fp)			# on recupere les registres stockes
					lw 	$t2, 8($fp)			#
					
					ori	$sp, $fp, 0			# on remet le stack pointer a sa place originale

				
					beqz 	$t3, loop
					addi 	$t0, $t0, 1
					
					lb 	$t3, taille_de_la_cle
					lb	$t4, cle($t3)			# on charge le bit qui se situe juste après la fin de la clé
					beqz 	$t4, loop			# si la valeur de ce bit est différente de 0, c'est que la clé est finie

					
# Affichage #				##################
					ori 	$v0, $0, 1			# print entier
					ori 	$t3, $0, 3			# $t3 = 3 (on utilise cette constante pour séparer les cellules par des espaces/paragraphes)
					ori 	$t2, $0, 0			# $t2 
					la 	$t0, tab_fusion			# $t0 = &tab_fusion[i]
affiche:				lb 	$a0, ($t0)			# on veut afficher $a0 = tab_fusion[i]
					div 	$t2, $t3			# on divise l'indice par 3
					mfhi 	$t4				# dans hi on a le reste de la division
					beqz 	$t4, espace			# si le reste est nul (indice multiple de 3), on affiche un espace
call:					syscall
					addi 	$t0, $t0, 1			# &tab_fusion[i++]
					addi 	$t2, $t2, 1			# i++
					blt 	$t2, 81, affiche		# ceci se repete 81 fois
					j 	fin

# On sépare les colonnes en 3 groupes de 3
espace:					ori 	$t3, $0, 9
					div 	$t2, $t3			# on divise l'indice par 9
					ori 	$t3, $0, 3
					mfhi 	$t4
					beqz 	$t4, newline			# si l'indice est multiple de 9, on est en fin de ligne - on affiche un newline
					ori 	$v0, $0, 11			# affiche char
					ori 	$a0, $0, 32			# affiche espace
					syscall
					lb 	$a0, ($t0)			# $a0 reprend la valeur de l'indice
					ori 	$v0, $0, 1			# $v0 reprend la valeur qui correspond à "affiche entier"
					j 	call				# on revient à l'affichage du tableau

# On sépare les lignes en 3 groupes de 3
newline:
					ori 	$t3, $0, 27			# $t3 = 9*3 = 27 
					div 	$t2, $t3			# on divise l'indice par 27
					ori 	$t3, $0, 3
					mfhi 	$t4				# on recupere le reste de la division
					ori 	$v0, $0, 11			# affiche char
					ori 	$a0, $0, 10			# affiche newline 
					syscall
					beqz 	$t4, newline2			# si l'indice est multiple de 27, on est en fin de la 3éme ligne - on affiche un deuxieme newline
					j 	rien

newline2:				syscall
				
rien:				
					lb 	$a0, ($t0)			# $a0 reprend la valeur de l'indice
					ori 	$v0, $0, 1			# $v0 reprend la valeur qui correspond à "affiche entier"
					j 	call

# fin du code					
fin:
					ori 	$v0, $0, 10
					syscall
				
############################### FONCTIONS ###############################

# FUSION
########
Fonction_Fusion:
					la 	$t1, tableau		# &tableau[i]
					la 	$t2, cle		# &cle[i]
					la 	$t3, tab_fusion		# &tab_fusion[i]
					ori 	$t6, $0, 0		# i  (compteur de tours de boucle)
				
load:					lb 	$t4, ($t1)		# tableau[i]
					lb 	$t5, ($t2)		# cle[i]
				
					beqz 	$t4, store_from_key	# si tableau[i] == 0
					
					sb 	$t4, ($t3)		# si tableau[i] n'est pas '0', alors on le recopie dans tab_fusion[i]
					j 	continue
				
store_from_key:				sb 	$t5, ($t3)		# si on trouve un zero dans le tableau, on le remplace par un élément de la clé
					addi 	$t2, $t2, 1		# &cle[i++], on passe a l'element suivant de la cle
				
continue:
					addi 	$t1, $t1, 1		# &tableau[i++]
					addi 	$t3, $t3, 1		# &tab_fusion[i++]
					addi 	$t6, $t6, 1		# i ++
					blt 	$t6, 81, load		# ceci se repete 81 fois
				
					jr  	$ra			# on revient à $ra sans rien retourner

# CHECK
########
Fonction_Verification:

#######################################################################################################
					
					#check lignes
					
					ori $t1, $0, 0							# i: indice de la case (i = ligne*9 + colonne)
for_lignes:			
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];
					ori $t6, $0, 1							# taille de small_tab
					ori $t2, $0, 1							#- j: indice de la case sur une ligne (i.e. numero de la colonne)
					lb $t4, tab_fusion($t1)
					sb $t4, small_tab
					addi $t1, $t1, 1

forfor_lignes:
					lb $t4, tab_fusion($t1)
					ori $t3, $0, 0							#-- k: indice de small_tab
				
forforfor_lignes:											#--- on parcourt small_tab
					lb $t5, small_tab($t3)

					bne $t4, $t5, no_problemo_lignes				#--- si tableau[ligne*9 + colonne] != small_tab[k] -> pas de probleme
					beqz $t5, no_problemo_lignes					#--- si small_tab[k] == 0 							-> pas de probleme
					j return_0
no_problemo_lignes:				
					addi $t3, $t3, 1						#--- k++
					blt $t3, $t6, forforfor_lignes					# on parcourt small_tab de '0' à  'taille de small_tab'
					
					bgt $t6, 8, max_neuf_lignes					# la taille de small_tab est incrmentee sans dépasser 9 
					addi $t6, $t6, 1

max_neuf_lignes:			sb $t4, small_tab($t2)						#-- on met le chiffre dans small_tab
					
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
					ori $t6, $0, 1#taille de small_tab
					ori $t2, $0, 9							#- j: indice de la case de la ligne (colonne)
					lb $t4, tab_fusion($t1)
					sb $t4, small_tab
					addi $t1, $t1, 9
					
forfor_colonnes:
					lb $t4, tab_fusion($t1)
					ori $t3, $0, 0							#-- k: indice de small_tab
				
forforfor_colonnes:											#--- on parcourt small_tab
					lb $t5, small_tab($t3)

					bne $t4, $t5, no_problemo_colonnes		#--- si tableau[ligne*9 + colonne] != small_tab[k] -> pas de probleme
					beqz $t5, no_problemo_colonnes			#--- si small_tab[k] == 0 							-> pas de probleme
					j return_0
no_problemo_colonnes:				
					addi $t3, $t3, 1						#--- k++
					blt $t3, $t6, forforfor_colonnes
		
					bgt $t6, 8, max_neuf_colonnes
					addi $t6, $t6, 1

max_neuf_colonnes:			div $t7, $t2, 9							#-- $t7 = colonne = $t2 / 9
					sb $t4, small_tab($t7)
					addi $t2, $t2, 9						#-- j+=9 (on se deplace sur une colonne (verticale <=> +9))
					addi $t1, $t1, 9						#-- i+=9 (on se deplace sur une colonne (verticale <=> +9))
					blt $t7, 8, forfor_colonnes
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
					lb $t7, tab_fusion($t1)
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
