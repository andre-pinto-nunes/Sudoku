				.data
tableau:			.byte 0, 2, 0, 0, 0, 0, 0, 0, 0, 5, 4, 0, 0, 7, 0, 0, 8, 9, 0, 0, 0, 0, 0, 6, 0, 3, 0, 0, 0, 0, 3, 0, 0, 0, 5, 0, 2, 0, 9, 0, 0, 0, 3, 0, 0, 1, 0, 0, 0, 0, 2, 8, 0, 0, 3, 0, 0, 4, 0, 0, 5, 0, 0, 0, 7, 0, 0, 0, 0, 0, 9, 0, 9, 0, 2, 0, 8, 0, 0, 1, 0
cle:				.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
tab_merge:			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
				.text
main:
				la $t1, tableau		# &tableau[i]++
				la $t2, cle		# &cle[i]++
				la $t3, tab_merge	# &tab_merge[i]++
				ori $t6, $0, 0 
				
load:				lb $t4, ($t1)		# tableau[i]
				lb $t5, ($t2)		# cle[i]
				
				beqz $t4, store_from_key	
				
				sb $t4, ($t3)		# si tableau[i] != 0 , alors, merge[i] = tab[i]
				j continue
				
store_from_key:			sb $t5, ($t3)		# si tableau[i] == 0 , alors, merge[i] = cle[i]
				addi $t2, $t2, 1
				
continue:			ori $v0, $0, 1		#------------------
				lb $a0, ($t3)		# print pour tester
				syscall 		#------------------
				addi $t1, $t1, 1
				addi $t3, $t3, 1
				addi $t6, $t6, 1
				blt $t6, 81, load
				
				# fin
				ori $v0, $0, 10
				syscall
				
