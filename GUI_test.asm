# java -jar ./Mars4_5.jar ./sudoku.asm pa sudoku.txt
# pour executer il faut passer le nom du texte en argument
					.data

# stockage des caracteres lus dans le fichier
lecture:				.space 	200
					.align 	2

# tableau sudoku à résoudre
tableau:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# nom du fichier contenant le tableau
nom_du_fichier:				.space 100
					.align 2
nom_du_fichier_corrige:			.space 100
					.align 	2
					
# liste des chiffres déjà trouvés dans une ligne/colonne/cellule - (fonction vérification)
petit_tableau:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0

# clé calculée dans le main qui résout le sudoku
cle:					.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

					#.align 2
taille_de_la_cle:			.byte   0
tab_fusion:				.byte 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

msg_erreur_fichier:			.asciiz "Le fichier n'existe pas!"
msg_erreur:				.asciiz "La grille entrée présente un problème ! Veuillez choisir une grille correcte"
msg_debut:				.asciiz "Veuillez rentrer le nom d'un fichier"
msg_debut_1:				.asciiz "Veuillez rentrer le nom d'un fichier valide"

chaine_finale:				.space 10

					.text
					la	$t2, msg_debut
					ori $v0, $0, 31				#
					ori $a0, $0, 80				#
					ori $a1, $0, 1000			#
					ori $a2, $0, 12				#
					ori $a3, $0, 127			# bruit pop-up
					syscall
debut:					ori 	$v0, $0, 54			# InputDialogString
					la 	$a0, ($t2)			# On demande a l'utilisateur d'ecrire le nom du fichier
					la 	$a1, nom_du_fichier 		# on stocke ce nom dans nom_du_fichier
					la 	$a2, 20
					syscall
					
					bne	$a1, -2, ok_selectione		# si $a1 = -2, on a appuie sur cancel
					ori	$v0, $0, 10
					syscall					
ok_selectione:				bnez	$a1, fichier_invalide		# si $a1 != 0, il y a un probleme

					# la chaîne de caractères nom_du_fichier se termine toujours par un newline (\n), et on n'en veut pas
					# alors on recopie tous les caractères de nom_du_fichier dans nom_du_fichier_corrige sauf le '\n'
					
					ori $t1, $0, 0				# $t1 = i
					lb $a0, nom_du_fichier($t1)		# $a0 = nom_du_fichier[i]
repet:										
					sb $a0, nom_du_fichier_corrige($t1)	# on recopie nom_du_fichier[i] dans nom_du_fichier_corrige[i]
					addi $t1, $t1,1				# $t1 = i++
					lb $a0, nom_du_fichier($t1)		# $a0 = nom_du_fichier[i]
					bne $a0, 10, repet			# si $a0 = nom_du_fichier[i] vaut 10 (i.e. '\n'), alors la boucle s'arrête
					
# LECTURE
#####################################################################################################

# Ouverture fichier
					ori 	$v0, $0, 13			# syscall : ouvrir fichier
					la 	$a0, nom_du_fichier_corrige	# $a0 : nom du fichier
					ori 	$a1, $0, 0			# $a1 : 0 = read ; 1 = write
					syscall					# ouvrir fichier
					move 	$t0, $v0			# on garde FILE* pour la lecture
					bne	$t0, -1, fichier_valide		# si $t0 = -1, le fichier n'existe pas
					
fichier_invalide:			ori $v0, $0, 31				#
					ori $a0, $0, 8				#
					ori $a1, $0, 1000			#
					ori $a2, $0, 12				#
					ori $a3, $0, 127			# bruit erreur
					syscall
					
					ori	$v0, $0, 55
					la	$a0, msg_erreur_fichier
					ori	$a1, $0, 0
					la	$t2, msg_debut_1
					syscall
					j debut
fichier_valide:

# Lecture fichier
					ori 	$v0, $0, 14			# syscall : ouvrir fichier
					move	$a0, $t0			# pointeur du fichier FILE*
					la 	$a1, lecture			# destination des caracteres lus
					ori 	$a2, $0, 119			# nb de caracteres a lire 
					syscall					# lire fichier
				
# Conversion en tableau d'entiers				
					la 	$t0, lecture			# $t0 : pointeur lecture
					la 	$t2, tableau			# $t2 : tableau SUDOKU
lire:					lb 	$t1, ($t0)			# $t1 : valeur pointee
					blt 	$t1, '1', nan			#	- si c'est plus petit que 1 ce n'est pas un chiffre
					bgt 	$t1, '9', nan			#	- si c'est plus grand que 9 ce n'est pas un chiffre
					j 	eff
nan:										# si ce n'est pas un chiffre c'est : soit X, soit ' ', soit '\n'
					bne 	$t1, 'X', t			# si ce n'est pas un X on passe au suivant, sans rien faire
					ori 	$t1, $0, '0'			# si c'est un X, on envoie un 0
					addi	$t4, $t4, 1             	# $t4 : compteur du nombre de '0', cela correspond à la taille de la clé
				
eff:				
					subi 	$t1, $t1, '0'			# on retranche '0' pour convertir le code ASCII en int
					sb 	$t1, 0($t2)			# on met l'entier dans la destination
					addi 	$t2, $t2, 1			# &destination[i] ++
					addi 	$t3, $t3, 1			# $t3 : compteur tours de boucle
t:				
					addi 	$t0, $t0, 1			# &source[i] ++
					blt 	$t3, 81, lire
					
					sb	$t4, taille_de_la_cle
# Fermeture du fichier

					move	$a0, $v0			# pointeur vers le fichier à fermer
					ori	$v0, $0, 16			# syscall: fermer fichier
					syscall					# fermeture du fichier

# FIN LECTURE				
#####################################################################################################


# Main #
					la	$a0, tableau
					jal	Fonction_Verification		# vérification du tableau de base
					beqz	$v0, probleme_grille_depart
					
					la 	$t0, cle
boucle:				
					lb 	$t1, ($t0)			# cle[i] (initialement a 0)
					addi 	$t1, $t1, 1			# cle[i]++
					sb 	$t1, ($t0)
					ble 	$t1, 9, pas_de_depassement	
					subi 	$t2, $t2, 9			# end -= 9
					ori 	$t1, $0, 0			# cle[i]=0
					sb 	$t1, ($t0)
					subi 	$t0, $t0, 1			# i--
					j 	boucle
pas_de_depassement:				
					ori	$fp, $sp, 0			# $fp prend la valeur de $sp
					addi	$sp, $sp, 12			# on avance $sp de 12 octets pour pouvoir stocker 3 mots
					
					sw 	$t0, 0($fp)			#
					sw 	$t1, 4($fp)			# on stocke les registres entre fp et sp
					sw 	$t2, 8($fp)			#
					la	$a0, tab_fusion			# passage argument
					
					jal 	Fonction_Fusion			# appel de fusion
					jal 	Fonction_Verification		# appel de verification
					
					lw 	$t0, 0($fp)			#
					lw 	$t1, 4($fp)			# on recupere les registres stockes
					lw 	$t2, 8($fp)			#
					
					ori	$sp, $fp, 0			# on remet le stack pointer a sa place initiale

				
					beqz 	$v0, boucle
					addi 	$t0, $t0, 1
					
					lb 	$t3, taille_de_la_cle
					lb	$t4, cle($t3)			# on charge l'octet qui se situe juste après la fin de la clé
					beqz 	$t4, boucle			# si cette valeur est différente de 0, c'est que la clé est finie
					la	$a0, tab_fusion
					jal	Fonction_Affichage
					ori	$a1, $0, 1			# syscall 55  : mode information	
					j	pas_pb_grille_depart

probleme_grille_depart:			ori $v0, $0, 31				#
					ori $a0, $0, 8				#
					ori $a1, $0, 1000			#
					ori $a2, $0, 12				#
					ori $a3, $0, 127			# bruit erreur
					syscall
					
					ori	$v0, $0, 55			#
					la	$a0, msg_erreur			#
					ori	$a1, $0, 0			# message erreur
					syscall
					la	$a0, tableau
					jal	Fonction_Affichage
					ori	$a1, $0, 0			# syscall 55  : mode erreur
					
pas_pb_grille_depart:			



					
# fin du code					
fin:
# son
					ori $v0, $0, 31				#
					ori $a0, $0, 72				#
					ori $a1, $0, 2000			#
					ori $a2, $0, 90				#
					ori $a3, $0, 120			#
					syscall					# son 1
					
					ori $v0, $0, 32				#
					ori $a0, $0, 1000			#
					syscall					# pause
					
					ori $v0, $0, 31				#
					ori $a0, $0, 72				#
					ori $a1, $0, 1000			#
					ori $a2, $0, 90				#
					ori $a3, $0, 120			#
					syscall					# son 1
					
					ori $v0, $0, 31				#
					ori $a0, $0, 65				#
					ori $a1, $0, 1000			#
					ori $a3, $0, 80				#
					syscall					# son 2
											
					ori $v0, $0, 31				#
					ori $a0, $0, 29				#
					ori $a1, $0, 1200			#
					ori $a3, $0, 50				#
					syscall					# son 3
											
					ori	$v0, $0, 55			#			
					la	$a0, chaine_finale		#				
					syscall					# sudoku resolu	

			


					ori 	$v0, $0, 10
					syscall
				
############################### FONCTIONS ###############################

# FUSIONNER
###########
Fonction_Fusion:
					la 	$t1, tableau			# $t1 = &tableau[i]
					la 	$t2, cle			# $t2 = &cle[i]
					la 	$t3, tab_fusion			# $t3 = &tab_fusion[i]
					ori 	$t6, $0, 0			# $t6 = i  (compteur de tours de boucle)
				
charger:				lb 	$t4, ($t1)			# $t4 = tableau[i]
					lb 	$t5, ($t2)			# $t5 = cle[i]
				
					beqz 	$t4, remplir_avec_cle		# si tableau[i] == 0
					
					sb 	$t4, ($t3)			# si tableau[i] n'est pas '0', alors on le recopie dans tab_fusion[i]
					j 	continue
				
remplir_avec_cle:			sb 	$t5, ($t3)			# si on trouve un zero dans le tableau, on le remplace par un élément de la clé
					addi 	$t2, $t2, 1			# &cle[i++], on passe a l'element suivant de la cle
				
continue:
					addi 	$t1, $t1, 1			# &tableau[i++]
					addi 	$t3, $t3, 1			# &tab_fusion[i++]
					addi 	$t6, $t6, 1			# i ++
					blt 	$t6, 81, charger		# ceci se repete 81 fois
				
					jr  	$ra				# on revient à $ra sans rien retourner

# VERIFIER
##########
Fonction_Verification:

#######################################################################################################
					
					#verifier lignes
					
					ori 	$t1, $0, 0						# $t1 = i: indice de la case (i = ligne*9 + colonne)
for_lignes:			
					sw 	$0, petit_tableau					#-
					sw 	$0, petit_tableau+4					#-
					sb 	$0, petit_tableau+8					#- petit_tableau[9]=[];
					ori 	$t6, $0, 1						#- $t6 = taille de petit_tableau
					ori 	$t2, $0, 1						#- j: indice de la case sur une ligne (i.e. numero de la colonne)
					lb 	$t4, ($a0)						#- $t4 = tab[i]
					sb 	$t4, petit_tableau					#- (avant la boucle), on place un premier element dans petit_tableau
					addi 	$a0, $a0, 1						#- on passe a l'element suivant
					addi	$t1, $t1, 1

forfor_lignes:
					lb 	$t4, ($a0)						#- $t4 = tab[i]
					ori	$t3, $0, 0						#-- k: indice de petit_tableau
				
forforfor_lignes:											#--- on parcourt petit_tableau
					lb 	$t5, petit_tableau($t3)					#--- $t5 = petit_tableau[i]

					bne 	$t4, $t5, no_problemo_lignes				#--- si tableau[ligne*9 + colonne] != petit_tableau[k] (i.e. si petit_tableau ne contient pas deja le chiffre en quesion)	-> pas de probleme
					beqz 	$t5, no_problemo_lignes					#--- si petit_tableau[k] == 0 (i.e. si petit_tableau contient deja le chiffre, mais il s'agit d'un 0, c'est une case vide)	-> pas de probleme
					j 	return_0						#--- sinon, on trouve un chiffre deux fois dans la meme ligne -> probleme trouve -> return 0
no_problemo_lignes:				
					addi 	$t3, $t3, 1						#--- k++
					blt 	$t3, $t6, forforfor_lignes				#-- on parcourt petit_tableau de '0' à  'taille de petit_tableau'
					
					bgt 	$t6, 8, max_neuf_lignes					#-- la taille de petit_tableau est incrementee sans dépasser 9 
					addi 	$t6, $t6, 1

max_neuf_lignes:			sb 	$t4, petit_tableau($t2)					#-- on met le chiffre dans petit_tableau
					
					addi 	$t2, $t2, 1						#-- j++
					addi 	$a0, $a0, 1						#-- i++
					addi	$t1, $t1, 1
					blt 	$t2, 9, forfor_lignes					#- ceci se repete 9 fois

					blt 	$t1, 9, for_lignes					# ceci se repete 9 fois





#######################################################################################################
					#verifier colonnes
					subu	$a0, $a0, $t1						# "remise a zero"
					ori 	$t1, $0, 0						# $t1 = i: indice de la case (ligne*9 + colonne)
for_colonnes:			
					sw 	$0, petit_tableau					#-
					sw 	$0, petit_tableau+4					#-
					sb 	$0, petit_tableau+8					#- petit_tableau[9]=[];
					ori 	$t6, $0, 1						#- $t6 = taille de petit_tableau
					ori 	$t2, $0, 9						#- j: indice de la case de la ligne (colonne)
					lb 	$t4, ($a0)						#- $t4 = tab_fusion[i]
					sb 	$t4, petit_tableau					#- (avant la boucle), on place un premier element dans petit_tableau
					addi 	$t1, $t1, 9						#- on passe a l'element suivant
					addi 	$a0, $a0, 9
					
forfor_colonnes:
					lb 	$t4, ($a0)						#- $t4 = tab_fusion[i]
					ori 	$t3, $0, 0						#-- k: indice de petit_tableau
				
forforfor_colonnes:											#--- on parcourt petit_tableau
					lb 	$t5, petit_tableau($t3)					#--- $t5 = petit_tableau[i]

					bne 	$t4, $t5, no_problemo_colonnes				#--- si tableau[ligne*9 + colonne] != petit_tableau[k] (i.e. si petit_tableau ne contient pas deja le chiffre en quesion)	-> pas de probleme
					beqz 	$t5, no_problemo_colonnes				#--- si petit_tableau[k] == 0 (i.e. si petit_tableau contient deja le chiffre, mais il s'agit d'un 0, c'est une case vide)	-> pas de probleme
					j 	return_0						#--- sinon, on trouve un chiffre deux fois dans la meme ligne -> probleme trouve -> return 0
no_problemo_colonnes:				
					addi 	$t3, $t3, 1						#--- k++
					blt 	$t3, $t6, forforfor_colonnes				#-- on parcourt petit_tableau de '0' à  'taille de petit_tableau'
		
					bgt 	$t6, 8, max_neuf_colonnes				#-- la taille de petit_tableau est incrementee sans dépasser 9
					addi 	$t6, $t6, 1

max_neuf_colonnes:			div 	$t7, $t2, 9						#-- $t7 = colonne = $t2 / 9
					sb 	$t4, petit_tableau($t7)
					addi 	$t2, $t2, 9						#-- j+=9 (on se deplace sur une colonne (verticale <=> +9))
					addi 	$t1, $t1, 9						#-- i+=9 (on se deplace sur une colonne (verticale <=> +9))
					addi 	$a0, $a0, 9
					blt 	$t7, 8, forfor_colonnes
					subi 	$t2, $t2, 9						#- a la fin du dernier branch, on depasse les limites donc on fait un subi
					subi 	$a0, $a0, 9
					subi 	$t1, $t1, 9						#- " "  "   "  "       "       "  "       "   "       "    "  "    "  "
					subi 	$a0, $a0, 71
					subi 	$t1, $t1, 71						#- quand on arrive a la fin d'une colonne: $t1 -= 72 pour remonter en haut de la colonne et $t1 +=1 pour passer a la colonne suivante
					blt 	$t1, 9, for_colonnes



#######################################################################################################
					#verifier cellules
					subu	$a0, $a0, $t1
					ori 	$t1, $0, 0						# $t = i: indice de la case (cellule*9 + colonne) 
					ori 	$t2, $0, 0
					ori 	$t3, $0, 0
for1:
					sw 	$0, petit_tableau					#-
					sw 	$0, petit_tableau+4					#-
					sb 	$0, petit_tableau+8					#- petit_tableau[9]=[];
					ori 	$s1, $0, 0						#- $s1 = taille de petit_tableau

					ori 	$t4, $0, 0
					ori 	$t5, $0, 0
					ori 	$t9, $0, 0
for4:
					lb 	$t7, ($a0)						# $t7 = tab_fusion[i]
					ori	$t6, $0, 0						#-- k: indice de petit_tableau				
petit_tableau_cellules:											#--- on parcourt petit_tableau
					lb 	$t8, petit_tableau($t6)

					beqz 	$t8, no_problemo_cellules				#--- si petit_tableau[k] == 0 (i.e. si petit_tableau contient deja le chiffre, mais il s'agit d'un 0, c'est une case vide)	-> pas de probleme
					bne 	$t7, $t8, no_problemo_cellules				#--- si tableau[ligne*9 + colonne] != petit_tableau[k] (i.e. si petit_tableau ne contient pas deja le chiffre en quesion)	-> pas de probleme
					j 	return_0						#--- sinon, on trouve un chiffre deux fois dans la meme ligne -> probleme trouve -> return 0
no_problemo_cellules:				
					addi 	$t6, $t6, 1						#--- k++
					blt 	$t6, $s1, petit_tableau_cellules
					
					bgt 	$s1, 8, max_neuf_colonnes				#-- la taille de petit_tableau est incrementee sans dépasser 9
					addi 	$s1, $s1, 1

					sb 	$t7, petit_tableau($t9)					#-- on met le chiffre dans petit_tableau
					addi 	$t9, $t9, 1
					addi 	$t1, $t1, 1
					addi 	$a0, $a0, 1
					addi 	$t5, $t5, 1
					blt 	$t5, 3, for4

					ori 	$t5, $0, 0
					addi 	$t1, $t1, 6
					addi 	$a0, $a0, 6
					addi 	$t4, $t4, 1
					blt 	$t4, 3, for4
					
					addi 	$t3, $t3, 1
					blt 	$t3, 3, for1
					
					ori 	$t3, $0, 0
					subi 	$t1, $t1, 78
					subi 	$a0, $a0, 78
					addi 	$t2, $t2, 1
					blt 	$t2, 3, for1

return_1:				ori 	$v0, $0, 1						# si aucun probleme n'a ete trouve, on renvoie '1' sur le registre $t3
					jr 	$ra							# on revient à l'endroit ou la fonction a ete appelee

return_0:				ori 	$v0, $0, 0						# si un probleme a ete trouve, on renvoie '0' sur le registre $t3
					jr 	$ra
					

# AFFICHAGE
###########
Fonction_Affichage:

#######################################################################################################
					ori	$t0, $a0, 0			# $t0 = &tableau[i]
					ori 	$t1, $0, 0
					ori 	$t3, $0, 3			# $t3 = 3 (on utilise cette constante pour séparer les cellules par des espaces/paragraphes)
					ori 	$t2, $0, 0			# $t2 = i
							
					
affiche:				lb 	$a0, ($t0)			# on veut afficher $a0 = tab_fusion[i]
					div 	$t2, $t3			# on divise l'indice par 3
					mfhi 	$t4				# dans hi on a le reste de la division
					beqz 	$t4, espace			# si le reste est nul (indice multiple de 3), on affiche un espace
call:					
					addi	$a0, $a0, 48			# conversion int -> char
					sb	$a0, chaine_finale($t1)		# on ajoute le char a la chaine finale
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			# affiche espace
					sb	$a0, chaine_finale($t1)


#syscall
					
					addi	$t1, $t1, 1
					addi 	$t0, $t0, 1			# &tab_fusion[i++]
					addi 	$t2, $t2, 1			# i++
					blt 	$t2, 81, affiche		# ceci se repete 81 fois
					jr	$ra

# On sépare les colonnes en 3 groupes de 3
espace:					ori 	$t3, $0, 9
					div 	$t2, $t3			# on divise l'indice par 9
					ori 	$t3, $0, 3
					mfhi 	$t4
					beqz 	$t4, saut_de_ligne		# si l'indice est multiple de 9, on est en fin de ligne - on affiche un saut de ligne
					ori 	$a0, $0, 124			# affiche barre verticale
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			# affiche espace
					sb	$a0, chaine_finale($t1)
#syscall
					addi	$t1, $t1, 1
					lb 	$a0, ($t0)			# $a0 reprend la valeur de l'indice
					j 	call				# on revient à l'affichage du tableau

# On sépare les lignes en 3 groupes de 3
saut_de_ligne:
					ori 	$t3, $0, 27			# $t3 = 9*3 = 27 
					div 	$t2, $t3			# on divise l'indice par 27
					ori 	$t3, $0, 3
					mfhi 	$t4				# on recupere le reste de la division
					ori 	$a0, $0, 10			# affiche saut de ligne 
					sb	$a0, chaine_finale($t1)
					
#syscall
					addi	$t1, $t1, 1
					beqz	$t2, rien			# si $t2 vaut 0, on est au debut donc on ne fait rien 
					beqz 	$t4, saut_de_ligne2		# si l'indice est multiple de 27, on est en fin de la 3éme ligne - on affiche un deuxieme saut de ligne
					j 	rien

saut_de_ligne2:				ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 46			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 46		
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 95			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					ori 	$a0, $0, 32			
					sb	$a0, chaine_finale($t1)
					addi	$t1, $t1, 1
					
					
					
					ori 	$a0, $0, 10			# affiche saut de ligne 
					sb	$a0, chaine_finale($t1)
#syscall
					addi	$t1, $t1, 1
				
rien:				
					lb 	$a0, ($t0)			# $a0 reprend la valeur de l'indice
					j 	call
					
