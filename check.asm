					.data

m1:					.asciiz "bienbien"
m2:					.asciiz "pasbien"
#tableau:			.byte 1, 5, 4, 8, 7, 3, 2, 9, 6, 3, 8, 6, 5, 9, 2, 7, 1, 4, 7, 2, 9, 6, 4, 1, 8, 3, 5, 8, 6, 3, 7, 2, 5, 1, 4, 9, 9, 7, 5, 3, 1, 4, 6, 2, 8, 4, 1, 2, 9, 6, 8, 3, 5, 7, 6, 3, 1, 4, 5, 7, 9, 8, 2, 5, 9, 8, 2, 3, 6, 4, 7, 1, 2, 4, 7, 1, 8, 9, 5, 6, 3
tableau:			.byte 0, 2, 0, 0, 0, 1, 0, 0, 4, 
				      5, 4, 0, 0, 7, 0, 0, 8, 9, 
				      0, 7, 0, 0, 0, 6, 0, 3, 0, 
				      0, 1, 0, 3, 0, 0, 0, 5, 0, 
				      2, 0, 9, 0, 0, 0, 3, 0, 0, 
				      1, 0, 0, 0, 0, 2, 8, 0, 0, 
				      3, 6, 0, 4, 0, 0, 5, 0, 0, 
				      0, 0, 0, 0, 0, 0, 0, 9, 0, 
				      9, 0, 2, 0, 8, 0, 0, 5, 0
					.align 2
small_tab:			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0

					.text

main:				
					#check lignes
					ori $t1, $0, 0							# i: indice de la case (ligne*9 + colonne)
for_lignes:			
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];
					ori $t2, $0, 0							#- j: indice de la case de la ligne (colonne)

forfor_lignes:
					lb $t4, tableau($t1)
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


					#check colonnes
					ori $t1, $0, 0							# i: indice de la case (ligne*9 + colonne)
for_colonnes:			
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];
					ori $t2, $0, 0							#- j: indice de la case de la ligne (colonne)

forfor_colonnes:
					lb $t4, tableau($t1)
					ori $t3, $0, 0							#-- k: indice de small_tab
				
forforfor_colonnes:											#--- on parcourt small_tab
					lb $t5, small_tab($t3)

					bne $t4, $t5, no_problemo_colonnes		#--- si tableau[ligne*9 + colonne] != small_tab[k] -> pas de probleme
					beqz $t5, no_problemo_colonnes			#--- si small_tab[k] == 0 							-> pas de probleme
					j return_0
no_problemo_colonnes:				
					addi $t3, $t3, 1						#--- k++
					blt $t3, 9, forforfor_colonnes

					div $t6, $t2, 9
					sb $t4, small_tab($t6)					#-- on met le chiffre dans small_tab
					addi $t2, $t2, 9						#-- j++
					addi $t1, $t1, 9						#-- i++
					blt $t6, 8, forfor_colonnes
					subi $t2, $t2, 9						#-- j++
					subi $t1, $t1, 9						#-- i++
					slti $t3, $t1, 80
					subi $t1, $t1, 71
					bnez $t3, for_colonnes
					j return_1
















return_1:			ori $v0, $0, 4					# aucun probleme trouve
					la $a0, m1
					syscall 
					ori $v0, $0, 10
					syscall 

return_0:			ori $v0, $0, 4					# probleme trouve
					la $a0, m2
					syscall
					ori $v0, $0, 10
					syscall 