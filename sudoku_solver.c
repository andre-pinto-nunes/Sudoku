# Execution ./sudoku_solver sudoku.txt

#include <stdio.h>

/*
	Remplace toutes les cases vides du tableau sudoku (tab) par les elements d'une cle (key).
	Renvoie un tableau (merged) qui correspond a la fusion du tableau initial avec la cle.
*/
int* merge(int* tab, int* key, int* merged){
    int k = 0;
    for (int i = 0; i < 81; i++){	// on parcourt le tableau a resoudre
        if (!tab[i]){			// si on trouve un 0 (= case vide) ...
            merged[i] = key[k];		// 	... on recopie un element de la cle
            k++;
        }else{				// sinon ...
        	merged[i] = tab[i];	// 	... on recopie un element du tableau
        }
    }
    return merged;
}

/*
	Verifie si un tableau n'a pas d'erreurs (les cases vides ne sont pas prises en compte)
	Renvoi 1 si c'est le cas, 0 sinon
*/
int check (int tableau[81]){
	
	//check lignes
	// on parcourt les lignes
	for (int ligne = 0; ligne < 9; ++ligne){					
		
		//tableau contenant les chiffres trouves dans une ligne sauf les 0
		int tab[9] = {};
		
		// on parcourt les cases de chaque ligne
		for (int colonne = 0; colonne < 9; ++colonne){
			
			// on parcourt le tableau des chiffres trouves dans la ligne
			for (int i = 0; i < 9; ++i){
				
				// si on trouve un chiffre qque l'on avait deja trouve (pas 0)...
				if (tableau[ligne*9 + colonne] == tab[i] && tab[i]){
					
					// le tableau a une erreur
					return 0;
				}
			}
			
			// on met le chiffre que l'on vient de trouver dans le tableau de chiffres que l'on vient de trouver sauf si cest un 0
			tab[colonne] = tableau[ligne*9 + colonne];
		}
	}

	//check colonnes
	// apres c la mm chose du coup je vais tout reecrire 
	for (int colonne = 0; colonne < 9; ++colonne){
		int tab[9] = {};
		for (int ligne = 0; ligne < 9; ++ligne){
			for (int i = 0; i < 9; ++i){
				if (tableau[ligne*9 + colonne] == tab[i] && tab[i]){
					return 0;
				}
			}
			tab[ligne] = tableau[ligne*9 + colonne];
		}
	}

	//check cellules
	// ici, on dirait pas mais c aussi la meme chose sauf qu'il y a plus de for
	for (int ligne = 0; ligne < 3; ++ligne){
		for (int colonne = 0; colonne < 3; ++colonne){
			int tab[9] = {};
			for (int i = 0; i < 3; ++i){
				for (int j = 0; j < 3; ++j){
					for (int k = 0; k < 9; ++k){
						if (tableau[(ligne*3+i)*9 + colonne*3 + j] == tab[k] && tab[k]){
							return 0;
						}
					}
					tab[i*3 +j] = tableau[(ligne*3+i)*9 + colonne*3 + j];
				}
			}
		}
	}
	return 1;
}

/*
	Brute Force: on va essayer toutes les valeurs possibles
	
	1º - on met un chiffre (=1) sur la premiere case vide (donc sur la cle)
	2º - tant qu'il n'y a pas de probleme, on passe a la prochaine case vide et on y met un chiffre (=1)
	3º - si on trouve un probleme et tant qu'on trouve un probleme, on incremente le chiffre (=2) (=3) (=4) etc. et on passe a la case suivante
	4º - si on arrive a la limite (=9) et il y a toujours un probleme (on a teste toutes les possibilités), on revient a la case 'vide' precedente et on incremente la valeur
	5º - on revient a 3º
*/
int main(int argc, char const *argv[]){

	int tab[81];		// tableau lu dans le fichier
	int tab_merge[81];	// tableau issu de la fusion de cle avec tab
	int end = 0;		// somme des elements du tableau - doit etre egal a 405 a la fin
	int size_of_key = 0;	// taille de la cle - correspond au nombre de cases vides du tableau

	FILE* file = fopen(argv[1], "r");

	// creation tab a partir du fichier
	// les 'X' deviennent des 0
	for (int i = 0; i < 81; ++i){
		char c;
		fscanf(file, "%c", &c);
		if (c == ' ' || c == '\n')
			i--;
		else if (c == 'X'){
			tab[i] = 0;
			tab_merge[i] = 0;
			// a chaque fois que l'on trouve un 0, on augmente la taille de la cle
			size_of_key++;
		}else{
			tab_merge[i] = 0;
			tab[i] = c - '0';
			end += c - '0';
		}
	}

	// creation du tableau cle
	int key[size_of_key];
	for (int i = 0; i < size_of_key; ++i){
		key[i]=0;
	}
	
	//indice de la cle
	int i = 0;
	while (!(end == 405 && check(merge(tab, key, tab_merge)))){
		
		// on incremente key[i], si on depasse 9...
		while (++key[i] > 9){
			// on remet key[i] a 0 et on met a jour la valeur de end
			end -= key[i]-1;
			key[i] = 0;
			// on revient a l'indice precedent
			i--;
		}
		
		// on met a jour la valeur de end (a cause du key ++ dans le while)
		end ++;
		
		// si il n'y a pas de probleme dans le tableau
		if (check(merge(tab, key, tab_merge))){
			
			// on passe a l'indice suivant
			i++;
		}

    }

	//affiche tableau
	for (int i = 0; i < 81; ++i){
		if (!(i%3) && (i%9))
			printf(" ");
		else if(!(i%9) && i)
			printf("\n");
		if (!(i%27) && i)
			printf("\n");
		printf("%d.", merge(tab, key, tab_merge)[i]);
	}

	printf("\n");
    return 0;
}
