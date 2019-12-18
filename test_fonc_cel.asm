					.data

m1:					.asciiz "bienbien"
m2:					.asciiz "pasbien"
#tableau:			.byte 1, 5, 4, 8, 7, 3, 2, 9, 6, 3, 8, 6, 5, 9, 2, 7, 1, 4, 7, 2, 9, 6, 4, 1, 8, 3, 5, 8, 6, 3, 7, 2, 5, 1, 4, 9, 9, 7, 5, 3, 1, 4, 6, 2, 8, 4, 1, 2, 9, 6, 8, 3, 5, 7, 6, 3, 1, 4, 5, 7, 9, 8, 2, 5, 9, 8, 2, 3, 6, 4, 7, 1, 2, 4, 7, 1, 8, 9, 5, 6, 3
tableau:			.byte 1, 5, 0,   5, 0, 0,   0, 0, 0, 
				      0, 0, 0,   0, 0, 0,   0, 0, 0, 
				      4, 0, 7,   7, 0, 0,   4, 0, 0, 
				      
				      2, 0, 0,   0, 0, 0,   0, 0, 0, 
				      0, 0, 0,   0, 0, 0,   0, 0, 0, 
				      0, 0, 0,   0, 0, 0,   0, 0, 0, 
				      
				      0, 0, 0,   0, 0, 0,   0, 0, 0, 
				      0, 0, 0,   0, 0, 0,   0, 7, 0, 
				      0, 0, 0,   0, 0, 0,   0, 0, 0
					.align 2
small_tab:			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0

					.text

main:				


#######################################################################################################
					#check cellules
					ori $t1, $0, 0							# i: indice de la case (cellule*9 + colonne)
for1:
					sw $0, small_tab						#-
					sw $0, small_tab+4						#-
					sb $0, small_tab+8						#- small_tab[9]=[];
#					ori $t2, $0, 0							#- j: indice de la case de la cellule (colonne)

					ori $t4, $0, 0
					ori $t5, $0, 0
					ori $t9, $0, 0
for4:
					lb $t7, tableau($t1)
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
