						.data
						tableau: .byte 0, 9, 0, 6, 0, 0, 8, 0, 0, 0, 0, 0, 5, 0, 3, 4, 0, 0, 8, 0, 7, 0, 0, 0, 6, 1, 0, 0, 0, 0, 0, 5, 0, 0, 0, 7, 0, 0, 0, 7, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 6, 3, 0, 0, 0, 7, 0, 0, 0, 0, 0, 2, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 2, 0, 3, 0, 6, 1, 0, 0, 4
						cle: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
						fusion: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
						tabcheck: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0
#						indice: .byte 0
						end: .word 124
						.text
main:		
						la $t1, cle						# t1 = pointeur vers cle[i]
						lbu $t2, 0($t1)						# t2 = valeur de cle[i]
						addi $t2, $t2, 1
						sb $t2, 0($t1)
						bleu $t2, 9, pas_de_depassement

depassement:
						lw $t3, end						#|
						subu $t3, $t3, $t2					#|
						addi $t3, $t3, 1					#|
						sw $t3, end						#|_ end -= cle[i] - 1
						
						or $t2, $0, $0						#|
						sb $t2, 0($t1)						#| cle[i] = 0
						
						subi $t1, $t1, 1					# i--
						lbu $t2, 0($t1)		
						bgt  $t2, 9, depassement				# si cle[i] > 9, depassement

pas_de_depassement:				lw $t3, end
						addiu $t3, $t3, 1					# end++	
			
			
			
			
			
			
			
			
			
			
			
			
			
			
				
		






















#fonction - fusionne le tableau avec la cle
merge:						#int* merge (int*, int*, int*)
		 	#la $t1, tableau
			#la $t2, cle
			#la $t3, fusion
			
			lb $t4, 0($t1)		#tableau[i]
			lb $t5, 0($t2)		#cle[i]
			lb $t6, 0($t3)		#fusion[i]

			
			bnez $t4, merge_else
			#if !tab[i]
			
			or $t6, $0, $t5
			sb $t6, 0($t3)
			j merge_for
merge_else:		#else
			
			or $t6, $0, $t4
			sb $t6, 0($t3)

merge_for:		
			addiu $t7, $t7, 1
			addiu $t1, $t1, 1			
			addiu $t2, $t2, 1
			addiu $t3, $t3, 1
			ble $t7, 81, merge




#fonction - verifie s'il y a une erreur sur le tableau
check:							#int check(int*tableau)
check_lignes:
			#la $t5, tableau
			sb $0, tabcheck
			sw $0, tabcheck+1
			sw $0, tabcheck+5		# int tab[9]= {}
			la $t4, tabcheck		# t4 = tab
			la $t9, tabcheck		# t9 = tab[col]			
check_lignes_for:
			lb $t6, 0($t5)
			lb $t7, 0($t4)

			beqz $t7, ppt_lignes			# tab[i] != 0
			bne $t6, $t7, ppt_lignes
			ori $s0, $0 , 0			# resultat
			beq $t6, $t7, findemerge	# return $t8 = 0
ppt_lignes:							# pas de probleme trouve
			addiu $t3, $t3, 1		# t3 = i ++
			addiu $t4, $t4, 1		# tab [i++] deplacement d'un octet ds la mmr
			ble $t3, 9, check_lignes_for

			sb $t6, 0($t9)
			addiu $t9, $t9, 1
			addiu $t5, $t5, 1
			addiu $t2, $t2, 1		# t2 = colonne
			ble $t2, 9, check_lignes_for
			
			addiu $t5, $t5, 9		# t5 = *tableau[ligne*9 + colonne]					
			addiu $t1, $t1, 1		# t1 = ligne
			ble $t1, 9, check
check_colonnes:
			#la $t5, tableau
			sb $0, tabcheck
			sw $0, tabcheck+1
			sw $0, tabcheck+5		# int tab[9]= {}
			la $t4, tabcheck		# t4 = tab
			la $t9, tabcheck		# t9 = tab[col]			
check_colonnes_for:
			lb $t6, 0($t5)
			lb $t7, 0($t4)

			beqz $t7, ppt_colonnes			# tab[i] != 0
			bne $t6, $t7, ppt_colonnes
			ori $s0, $0 , 0			# resultat
			beq $t6, $t7, findemerge	# return $t8 = 0
ppt_colonnes:							# pas de probleme trouve
			addiu $t3, $t3, 1		# t3 = i ++
			addiu $t4, $t4, 9		# tab [i++] deplacement d'un octet ds la mmr
			ble $t3, 9, check_colonnes_for

			sb $t6, 0($t9)
			addiu $t9, $t9, 1
			addiu $t5, $t5, 1
			addiu $t2, $t2, 1		# t2 = colonne
			ble $t2, 9, check_colonnes_for
			
			addiu $t5, $t5, 1		# t5 = *tableau[ligne*9 + colonne]					
			addiu $t1, $t1, 1		# t1 = ligne
			ble $t1, 9, check
check_cellules:						#for colonne for ligne
			#la $a0, tableau
			ori $s0, $0 , 1
			sb $0, tabcheck
			sw $0, tabcheck+1
			sw $0, tabcheck+5		# int tab[9]= {}
			la $t6, tabcheck		# t6 = tab
			la $t9, tabcheck		# t9 = tab[col]	

check_cellules_for:					#for i for j for k
			lb $t7, 0($a0)
			lb $t8, 0($t6)

			beqz $t7, ppt_cellules			# tab[i] != 0
			bne $t8, $t7, ppt_cellules
			ori $s0, $0 , 0			# resultat
			j findemerge			# return $t8 = 0
ppt_cellules:							# pas de probleme trouve
			addiu $t5, $t5, 1		# t5 = k ++
			addiu $t4, $t4, 1		# tab [k++] deplacement d'un octet ds la mmr
			ble $t5, 9, check_cellules_for

			sb $a0, 0($t9)
			
			addiu $a0, $a0, 1		# a0 = *tableau[ligne*9 + colonne]					
			addiu $t9, $t9, 1
			addiu $t4, $t4, 1		# t4 = j
			ble $t4, 3, check_cellules_for
			addiu $a0, $a0, 9
			addiu $t9, $t9, 3
			addiu $t3, $t3, 1		# t3 = i
			ble $t3, 3, check_cellules_for
			addiu $a0, $a0, 3
			addiu $t2, $t2, 1		# t2 = colonne
			ble $t2, 3, check_cellules
			addiu $a0, $a0, 27
			addiu $t1, $t1, 1		# t1 = ligne
			ble $t1, 3, check_cellules

findemerge:
			jalr $a2
