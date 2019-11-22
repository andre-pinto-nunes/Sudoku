#include <stdio.h>

int lc_to_cel(int ligne, int colonne){
	int a = ligne / 3;
	int b = colonne / 3;
	return b + a*3;
}

// return 1 si le tableau est bon, 0 sinon
int check (int tableau[81]){
	int probleme_trouve = 0;
	//check lignes
	for (int ligne = 0; ligne < 9; ++ligne){
		int tab[9] = {};
		for (int colonne = 0; colonne < 9; ++colonne){
			for (int i = 0; i < 9; ++i){
				if (tableau[ligne*9 + colonne] == tab[i]){
					printf("%d\n", tableau[ligne*9 + colonne]);
					for (int effefe = 0; effefe < 9; ++effefe){
						printf("%d ", tab[effefe]);
					}
					probleme_trouve = 1;
					printf("ligne:%d colonne:%d\n", ligne, colonne);
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
					printf("colonne:%d ligne:%d\n", colonne, ligne);
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
							printf("sddds\n");
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

int main(int argc, char const *argv[])
{	
	int tab[81] = {8,2,7, 1,5,4, 3,9,6,
				  9,6,5, 3,2,7, 1,4,8,
				  3,4,1, 6,8,9, 7,5,2,

				  5,9,3, 4,12,8, 2,7,1,
				  4,7,2, 5,1,3, 6,8,9,
				  6,1,8, 9,7,2, 4,3,5,

				  7,8,12, 2,6,5, 9,1,4,
				  1,5,4, 7,9,6, 8,2,3,
				  2,3,9, 8,4,1, 5,6,7};
	printf("%d\n", check(tab));

	/*
	char tab[81];
	int end = 0;

	FILE* file = fopen("sudoku2.txt", "r");
	
	//creation tab
	for (int i = 0; i < 81; ++i)
	{
		char c;
		fscanf(file, "%c", &c);
		if (c == ' ' || c == '\n')
			i--;
		else if (c == 'X')
			tab[i] = 0;
		else{
			tab[i] = c - '0';
			end += c - '0';
		}
	}

	for (int i = 0; i < 81; ++i)
	{
		if (!(i%3) && (i%9))
			printf(" ");
		else if(!(i%9) && i)
			printf("\n");
		if (!(i%27) && i)
			printf("\n");
		printf("%d", tab[i]);
	}
	printf("\n");


	char* colonne_0[9] = {&tab[0+0], &tab[1*9+0], &tab[2*9+0], &tab[3*9+0], &tab[4*9+0], &tab[5*9+0], &tab[6*9+0], &tab[7*9+0], &tab[8*9+0]};
	char* colonne_1[9] = {&tab[0+1], &tab[1*9+1], &tab[2*9+1], &tab[3*9+1], &tab[4*9+1], &tab[5*9+1], &tab[6*9+1], &tab[7*9+1], &tab[8*9+1]};
	char* colonne_2[9] = {&tab[0+2], &tab[1*9+2], &tab[2*9+2], &tab[3*9+2], &tab[4*9+2], &tab[5*9+2], &tab[6*9+2], &tab[7*9+2], &tab[8*9+2]};
	char* colonne_3[9] = {&tab[0+3], &tab[1*9+3], &tab[2*9+3], &tab[3*9+3], &tab[4*9+3], &tab[5*9+3], &tab[6*9+3], &tab[7*9+3], &tab[8*9+3]};
	char* colonne_4[9] = {&tab[0+4], &tab[1*9+4], &tab[2*9+4], &tab[3*9+4], &tab[4*9+4], &tab[5*9+4], &tab[6*9+4], &tab[7*9+4], &tab[8*9+4]};
	char* colonne_5[9] = {&tab[0+5], &tab[1*9+5], &tab[2*9+5], &tab[3*9+5], &tab[4*9+5], &tab[5*9+5], &tab[6*9+5], &tab[7*9+5], &tab[8*9+5]};
	char* colonne_6[9] = {&tab[0+6], &tab[1*9+6], &tab[2*9+6], &tab[3*9+6], &tab[4*9+6], &tab[5*9+6], &tab[6*9+6], &tab[7*9+6], &tab[8*9+6]};
	char* colonne_7[9] = {&tab[0+7], &tab[1*9+7], &tab[2*9+7], &tab[3*9+7], &tab[4*9+7], &tab[5*9+7], &tab[6*9+7], &tab[7*9+7], &tab[8*9+7]};
	char* colonne_8[9] = {&tab[0+8], &tab[1*9+8], &tab[2*9+8], &tab[3*9+8], &tab[4*9+8], &tab[5*9+8], &tab[6*9+8], &tab[7*9+8], &tab[8*9+8]};
	char** colonnes[9] = {colonne_0, colonne_1, colonne_2, colonne_3, colonne_4, colonne_5, colonne_6, colonne_7, colonne_8};

	char* ligne_0[9] = {&tab[0+0*9], &tab[1+0*9], &tab[2+0*9], &tab[3+0*9], &tab[4+0*9], &tab[5+0*9], &tab[6+0*9], &tab[7+0*9], &tab[8+0*9]};
	char* ligne_1[9] = {&tab[0+1*9], &tab[1+1*9], &tab[2+1*9], &tab[3+1*9], &tab[4+1*9], &tab[5+1*9], &tab[6+1*9], &tab[7+1*9], &tab[8+1*9]};
	char* ligne_2[9] = {&tab[0+2*9], &tab[1+2*9], &tab[2+2*9], &tab[3+2*9], &tab[4+2*9], &tab[5+2*9], &tab[6+2*9], &tab[7+2*9], &tab[8+2*9]};
	char* ligne_3[9] = {&tab[0+3*9], &tab[1+3*9], &tab[2+3*9], &tab[3+3*9], &tab[4+3*9], &tab[5+3*9], &tab[6+3*9], &tab[7+3*9], &tab[8+3*9]};
	char* ligne_4[9] = {&tab[0+4*9], &tab[1+4*9], &tab[2+4*9], &tab[3+4*9], &tab[4+4*9], &tab[5+4*9], &tab[6+4*9], &tab[7+4*9], &tab[8+4*9]};
	char* ligne_5[9] = {&tab[0+5*9], &tab[1+5*9], &tab[2+5*9], &tab[3+5*9], &tab[4+5*9], &tab[5+5*9], &tab[6+5*9], &tab[7+5*9], &tab[8+5*9]};
	char* ligne_6[9] = {&tab[0+6*9], &tab[1+6*9], &tab[2+6*9], &tab[3+6*9], &tab[4+6*9], &tab[5+6*9], &tab[6+6*9], &tab[7+6*9], &tab[8+6*9]};
	char* ligne_7[9] = {&tab[0+7*9], &tab[1+7*9], &tab[2+7*9], &tab[3+7*9], &tab[4+7*9], &tab[5+7*9], &tab[6+7*9], &tab[7+7*9], &tab[8+7*9]};
	char* ligne_8[9] = {&tab[0+8*9], &tab[1+8*9], &tab[2+8*9], &tab[3+8*9], &tab[4+8*9], &tab[5+8*9], &tab[6+8*9], &tab[7+8*9], &tab[8+8*9]};
	char** lignes[9] = {ligne_0, ligne_1, ligne_2, ligne_3, ligne_4, ligne_5, ligne_6, ligne_7, ligne_8};

	char* cellule_00[9] = {&tab[0*9+0+0], &tab[0*9+1+0], &tab[0*9+2+0], &tab[1*9+0+0], &tab[1*9+1+0], &tab[1*9+2+0], &tab[2*9+0+0], &tab[2*9+1+0], &tab[2*9+2+0]};
	char* cellule_01[9] = {&tab[0*9+0+3], &tab[0*9+1+3], &tab[0*9+2+3], &tab[1*9+0+3], &tab[1*9+1+3], &tab[1*9+2+3], &tab[2*9+0+3], &tab[2*9+1+3], &tab[2*9+2+3]};
	char* cellule_02[9] = {&tab[0*9+0+6], &tab[0*9+1+6], &tab[0*9+2+6], &tab[1*9+0+6], &tab[1*9+1+6], &tab[1*9+2+6], &tab[2*9+0+6], &tab[2*9+1+6], &tab[2*9+2+6]};
	char* cellule_10[9] = {&tab[(3*1+0)*9+0+0], &tab[(3*1+0)*9+1+0], &tab[(3*1+0)*9+2+0], &tab[(3*1+1)*9+0+0], &tab[(3*1+1)*9+1+0], &tab[(3*1+1)*9+2+0], &tab[(3*1+2)*9+0+0], &tab[(3*1+2)*9+1+0], &tab[(3*1+2)*9+2+0]};
	char* cellule_11[9] = {&tab[(3*1+0)*9+0+3], &tab[(3*1+0)*9+1+3], &tab[(3*1+0)*9+2+3], &tab[(3*1+1)*9+0+3], &tab[(3*1+1)*9+1+3], &tab[(3*1+1)*9+2+3], &tab[(3*1+2)*9+0+3], &tab[(3*1+2)*9+1+3], &tab[(3*1+2)*9+2+3]};
	char* cellule_12[9] = {&tab[(3*1+0)*9+0+6], &tab[(3*1+0)*9+1+6], &tab[(3*1+0)*9+2+6], &tab[(3*1+1)*9+0+6], &tab[(3*1+1)*9+1+6], &tab[(3*1+1)*9+2+6], &tab[(3*1+2)*9+0+6], &tab[(3*1+2)*9+1+6], &tab[(3*1+2)*9+2+6]};
	char* cellule_20[9] = {&tab[(3*2+0)*9+0+0], &tab[(3*2+0)*9+1+0], &tab[(3*2+0)*9+2+0], &tab[(3*2+1)*9+0+0], &tab[(3*2+1)*9+1+0], &tab[(3*2+1)*9+2+0], &tab[(3*2+2)*9+0+0], &tab[(3*2+2)*9+1+0], &tab[(3*2+2)*9+2+0]};
	char* cellule_21[9] = {&tab[(3*2+0)*9+0+3], &tab[(3*2+0)*9+1+3], &tab[(3*2+0)*9+2+3], &tab[(3*2+1)*9+0+3], &tab[(3*2+1)*9+1+3], &tab[(3*2+1)*9+2+3], &tab[(3*2+2)*9+0+3], &tab[(3*2+2)*9+1+3], &tab[(3*2+2)*9+2+3]};
	char* cellule_22[9] = {&tab[(3*2+0)*9+0+6], &tab[(3*2+0)*9+1+6], &tab[(3*2+0)*9+2+6], &tab[(3*2+1)*9+0+6], &tab[(3*2+1)*9+1+6], &tab[(3*2+1)*9+2+6], &tab[(3*2+2)*9+0+6], &tab[(3*2+2)*9+1+6], &tab[(3*2+2)*9+2+6]};
	char** cellules[9] = {cellule_00, cellule_01, cellule_02, cellule_10, cellule_11, cellule_12, cellule_20, cellule_21, cellule_22};

	while(end != 405){

		for (int i = 0; i < 81; ++i){								// for all squares
			char possibilites[9] = {1, 1, 1, 1, 1, 1, 1, 1, 1};
			char num_possibilites = 9;
			if (!tab[i]){
				printf("%d\n", i);
				for (int j = 0; j < 9; ++j)							// check column
				{
					if (*(colonnes[i%9][j]) && possibilites[*(colonnes[i%9][j])])	// si la colone a un element non nul et qui soit nouveau
					{
						possibilites[*(colonnes[i%9][j])] = 0; //alors ce n'est plus une possibilite
						num_possibilites--;
						for (int iww= 0; iww < 9; ++iww)
						{
							printf("%d ", possibilites[iww]);
						}
						printf("\n");
					}

					if (*(lignes[i/9][j]) && possibilites[*(lignes[i/9][j])])	// si la ligne a un element non nul et qui soit nouveau
					{
						possibilites[*(lignes[i/9][j])] = 0; //alors ce n'est plus une possibilite
						num_possibilites--;
						//printf("%d\n", num_possibilites);
					}

					if (*(cellules[lc_to_cel(i/9,i%9)][j]) && possibilites[*(cellules[lc_to_cel(i/9,i%9)][j])])	// si la cellule a un element non nul et qui soit nouveau
					{
						possibilites[*(cellules[lc_to_cel(i/9,i%9)][j])] = 0; //alors ce n'est plus une possibilite
						num_possibilites--;
						//printf("%d\n", num_possibilites);
					}
				}

				if (num_possibilites == 1) // si 1 seule possibilite
				{
					for (int k = 0; k < 9; ++k) //parcourt possibilites
					{
						if (possibilites[k]){
							tab[i] = k;
							end += k;
						}
					}
				}
			}
		}

		for (int i = 0; i < 81; ++i)
		{
			if (!(i%3) && (i%9))
				printf(" ");
			else if(!(i%9) && i)
				printf("\n");
			if (!(i%27) && i)
				printf("\n");
			printf("%d", tab[i]);
		}
		printf("\n");
	}



/*
	while(end != 405){
		for (int i = 0; i < 3; ++i){
			for (int j = 0; j < 3; ++j){
				
				// on determine les inconnues d'une cellule
				
				char tab_inconnues[9] = {1,2,3,4,5,6,7,8,9};
				
				for (int ii = 0; ii < 3; ++ii){
					for (int jj = 0; jj < 3; ++jj){
						int connue = tab[9*(3*i+ii)+3*j+jj];
						if (connue)
							tab_inconnues[connue-1] = 0;
					}
				}

				for (int ii = 0; ii < 3; ++ii){
					for (int jj = 0; jj < 3; ++jj){
						char possibilites[9] = {1,1,1,1,1,1,1,1,1}
						for (int k = 0; k < 9; ++k){ //verif colonne
							if (tab[])
							{
								
							}
						}
					}
				}				
			}
		}
	}
*/

/*
	//affichage tab
	for (int i = 0; i < 81; ++i)
	{
		if (!(i%3) && (i%9))
			printf(" ");
		else if(!(i%9) && i)
			printf("\n");
		if (!(i%27) && i)
			printf("\n");
		printf("%c", tab[i]);
	}
	printf("\n");
*/
	return 0;
}