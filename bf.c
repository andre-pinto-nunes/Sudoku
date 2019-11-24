#include <stdio.h>

int* merge(int* tab, int* key){
    int k = 0;
    for (int i = 0; i < 81; i++){
        if (!tab[i]){
            tab[i] = key[k];
            k++;
        }
    }
    return tab;
}

// return 1 si tableau est bon
int check (int tableau[81]){
	int probleme_trouve = 0;
	//check lignes
	for (int ligne = 0; ligne < 9; ++ligne){
		int tab[9] = {};
		for (int colonne = 0; colonne < 9; ++colonne){
			for (int i = 0; i < 9; ++i){
				if (tableau[ligne*9 + colonne] == tab[i]){
					probleme_trouve = 1;
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
				if (tableau[ligne*9 + colonne] == tab[i]){
					probleme_trouve = 1;
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
						if (tableau[(ligne*3+i)*9 + colonne*3 + j] == tab[k]){
							probleme_trouve = 1;
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
            size_of_key++;
        }else{
			tab[i] = c - '0';
			end += c - '0';
		}
	}

    int key[size_of_key];

    for (int i = 0; i < size_of_key; ++i)
    {
    	key[i]=0;
    }
    printf("%d\n", size_of_key);


    while (!check(merge(tab, key)))
	{
    	key[0]++;
    	for (int i = 0; i < size_of_key; ++i)
    	{
    		if (key[i]>9)
    		{
    			key[i]=0;
    			key[i+1]++;
    		}
    	}
    	printf("%d%d%d%d%d\n", key[0], key[1], key[2], key[3], key[4]);
    }
   

    //affiche tableau
	for (int i = 0; i < 81; ++i){
		if (!(i%3) && (i%9))
			printf(" ");
		else if(!(i%9) && i)
			printf("\n");
		if (!(i%27) && i)
			printf("\n");
		printf("%d", merge(tab, key)[i]);
	}














	printf("\n");   
    return 0;
}



