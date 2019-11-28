#include <stdio.h>

int* merge(int* tab, int* key, int* merged){
    int k = 0;
    for (int i = 0; i < 81; i++){
        if (!tab[i]){
            merged[i] = key[k];
            k++;
        }else{
        	merged[i] = tab[i];
        }
    }
    return merged;
}

// return 1 si tableau est bon
int check (int tableau[81]){
	//check lignes
	for (int ligne = 0; ligne < 9; ++ligne){
		int tab[9] = {};
		for (int colonne = 0; colonne < 9; ++colonne){
			for (int i = 0; i < 9; ++i){
				if (tableau[ligne*9 + colonne] == tab[i] && tab[i]){
					return 0;
				}
			}
			tab[colonne] = tableau[ligne*9 + colonne];
		}
	}

	//check colonnes
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


int main()
{


    int tab[81];
    int tab_merge[81];
	int end = 0;
    int size_of_key = 0;

	FILE* file = fopen("sudoku.txt", "r");

	//creation tab
	for (int i = 0; i < 81; ++i){
		char c;
		fscanf(file, "%c", &c);
		if (c == ' ' || c == '\n')
			i--;
		else if (c == 'X'){
			tab[i] = 0;
			tab_merge[i] = 0;
            size_of_key++;
        }else{
			tab_merge[i] = 0;
			tab[i] = c - '0';
			end += c - '0';
		}
	}

    int key[size_of_key];


    for (int i = 0; i < size_of_key; ++i)
    {
    	key[i]=0;
    }

    int i = 0;

    while (!(end == 405 && check(merge(tab, key, tab_merge)))){

		while (++key[i] > 9)
		{
			end -= key[i]-1;
			key[i] = 0;
			i--;
		}

		end ++;

		if (check(merge(tab, key, tab_merge))){
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
