%Go/0
%Prédicat démarant la partie
go :- how_to_play,
    strt(
    [[v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v]]).


%how_to_play/0
%Prédicat d'affichage des règles
how_to_play :-
  write('Vous êtes le joueur rouge (r). Vous devez aligner 4 jetons horizontalement, verticalement ou diagonalement.'),
  nl,
  write('Choisissez la colonne ou vous voulez placer votre jeton (0-6)'),
  nl.


%matrix/4
%Dans la grille, récupère la valeur à l'indice de la colonne et de la rangée désiré, et la mets dans Value
matrix(Grille, IRangee,IColonne, Value) :-
    nth0(IColonne, Grille, Colonne),
    nth0(IRangee, Colonne, Value).

%adversaire/2
%retourne la couleur de l'adversaire du jeton demandé
adversaire(j,r).
adversaire(r,j).

%colonne_est_pleine/2
%Retourne vrai si la colonne spécifié ne contient que des jetons. Retourne faux sinon.
colonne_est_pleine(Grille,I) :- 
    nth0(I,Grille,Colonne),
    not(member(v,Colonne)).
%colonne_est_pleine/1
%Retourne vrai si la colonne en paramètres ne contient que des jetons
colonne_est_pleine(Colonne) :-
    not(member(v,Colonne)).


%place_jeton/4
%Place le jeton sur la colonne spécifié et retourne la nouvelle grille
%Cas de base: Colonne 0
place_jeton(Jeton,0,[CCourante|Reste],[Nouvelle_Colonne|Reste]) :-
    not(colonne_est_pleine(CCourante)),
    place_jeton_sur_colonne(Jeton,CCourante,Nouvelle_Colonne).

place_jeton(Jeton,Colonne,[CCourante|Reste],[CCourante|Nouvelle_Grille]) :-
    not(Colonne == 0),
    NColonne is Colonne - 1,
    place_jeton(Jeton,NColonne,Reste,Nouvelle_Grille).


    
%place_jeton_sur_colonne/3
%Place le Jeton sur la colonne [Courant|Reste] et retourne la nouvelle colonne
%avec le jeton ajouté

%Cas ou jeton dernière case est vide 
place_jeton_sur_colonne(Jeton,[v],[Jeton]).

%Cas ou case suivante est vide
place_jeton_sur_colonne(Jeton,[Courant|Reste],[Courant|Retour]) :-
    nth0(0,Reste,V),
    V == v,
    place_jeton_sur_colonne(Jeton,Reste,Retour).

%Cas ou case suivant appartient à un joueur
place_jeton_sur_colonne(Jeton,[Courant|Reste],[Jeton|Reste]) :-
    nth0(0,Reste,V),
    not(V == v).

%aligneVertical/3
%Vérifie que un nombre de jetons de la couleur spécifié est aligné et utilisable
%Un alignement est utilisable si le jeton au dessus de la pile est vide
aligneVertical(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Rprecedente is R-1, 
    matrix(Grille,Rprecedente,C,v), %on verifie que l'element precedent est vide
    %Cela signifie qu'on peut utiliser ce jeton pour gagner
    R1 is R+1,
    Nb1 is Nb-1,
    aligneVertical(Grille,Jeton,Nb1,R1,C).

%aligneVertical/5
%Même chose que aligneVertical/3, sauf qu'on passe les coordonnées du jeton a vérifier

%Cas de base:On vérifie que le jeton n'est pas au bout de l'alignement. On veut un alignement fixe.
aligneVertical(Grille,Jeton,0,R,C) :-
    not(matrix(Grille,R,C,Jeton)).

aligneVertical(Grille,Jeton,Nb,R,C) :-
    matrix(Grille,R,C,Jeton),
    R1 is R+1,
    Nb1 is Nb-1,
    aligneVertical(Grille,Jeton,Nb1,R1,C).

%aligneHorizontal/3
%Vérifie qu'un nombre de jetons de la couleur spécifié est aligné et utilisable
%Un alignement est utilisable si la case à gauche et/ou à droite de la rangée est vide
aligneHorizontal(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Cprecedente is C-1, Csuivante is C+Nb,
    %on vérifie si la case à gauche et/ou à droite de la rangée est vide
    (matrix(Grille,R,Cprecedente,v);matrix(Grille,R,Csuivante,v)),
    C1 is C+1,
    Nb1 is Nb-1,
    aligneHorizontal(Grille,Jeton,Nb1,R,C1).

%aligneHorizontal/5
%même chose que aligneHorizontal/3 mais on spécifie à quel endroit on veut rechercher.
aligneHorizontal(Grille,Jeton,0,R,C) :-
    not(matrix(Grille,R,C,Jeton)).
aligneHorizontal(Grille,Jeton,Nb,R,C) :-
    matrix(Grille,R,C,Jeton),
    C1 is C+1,
    Nb1 is Nb-1,
    aligneHorizontal(Grille,Jeton,Nb1,R,C1).


%aligneDiagonalD/3
aligneDiagonalD(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Cprecedente is C-1, Rprecedente is R-1,
    Csuivante is C+Nb,Rsuivante is C+Nb,
    (matrix(Grille,Rprecedente,Cprecedente,v);matrix(Grille,Rsuivante,Csuivante,v)),
    R1 is R+1, C1 is C+1,
    Nb1 is Nb-1,
    aligneDiagonalD(Grille,Jeton,Nb1,R1,C1).

%aligneDiagonalD/5
aligneDiagonalD(Grille,Jeton,0,R,C) :-
    not(matrix(Grille,R,C,Jeton)).
aligneDiagonalD(Grille,Jeton,Nb,R,C) :-
    matrix(Grille,R,C,Jeton),
    R1 is R+1, C1 is C+1,
    Nb1 is Nb-1,
    aligneDiagonalD(Grille,Jeton,Nb1,R1,C1).




%aligneDiagonalM/3
aligneDiagonalM(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Cprecedente is C-1, Rprecedente is R+1,
    Csuivante is C+Nb,Rsuivante is R-Nb,
    (matrix(Grille,Rprecedente,Cprecedente,v);matrix(Grille,Rsuivante,Csuivante,v)),
    R1 is R-1, C1 is C+1,
    Nb1 is Nb-1,
    aligneDiagonalM(Grille,Jeton,Nb1,R1,C1).   

%aligneDiagonalM/5
aligneDiagonalM(Grille,Jeton,0,R,C) :-
    not(matrix(Grille,R,C,Jeton)).
aligneDiagonalM(Grille,Jeton,Nb,R,C) :-
    matrix(Grille,R,C,Jeton),
    R1 is R-1, C1 is C+1,
    Nb1 is Nb-1,
    aligneDiagonalM(Grille,Jeton,Nb1,R1,C1).


%alignementEstValide
alignementEstValide(Grille,Jeton,Cprecedente,Csuivante,Rprecedente,Rsuivante) :-
    (matrix(Grille,Rprecedente,Cprecedente,v),matrix(Grille,Rsuivante,Csuivante,v));
    (not(matrix(Grille,Rprecedente,Cprecedente,Jeton)),matrix(Grille,Rsuivante,Csuivante,v));
    ().

%afficheGrille/1
%Affiche la grille au complet
afficheGrille([C1,C2,C3,C4,C5,C6,C7]) :- 
    nth0(0,C1,V1),
    nth0(0,C2,V2),
    nth0(0,C3,V3),
    nth0(0,C4,V4),
    nth0(0,C5,V5),
    nth0(0,C6,V6),
    nth0(0,C7,V7),
    write('|'),write([V1,V2,V3,V4,V5,V6,V7]),write('|'),nl,
    afficheGrilleRec([C1,C2,C3,C4,C5,C6,C7],1).
%afficheGrilleRec/2
%Affiche la ligne de l'indice I et appel afficheGrilleRec(Grille,I+1) pour afficher la ligne suivante.
afficheGrilleRec([C1,C2,C3,C4,C5,C6,C7],5) :- 
    nth0(5,C1,V1),
    nth0(5,C2,V2),
    nth0(5,C3,V3),
    nth0(5,C4,V4),
    nth0(5,C5,V5),
    nth0(5,C6,V6),
    nth0(5,C7,V7),
    write('|'),write([V1,V2,V3,V4,V5,V6,V7]),write('|'),nl.

afficheGrilleRec([C1,C2,C3,C4,C5,C6,C7],I) :- 
    nth0(I,C1,V1),
    nth0(I,C2,V2),
    nth0(I,C3,V3),
    nth0(I,C4,V4),
    nth0(I,C5,V5),
    nth0(I,C6,V6),
    nth0(I,C7,V7),
    write('|'),write([V1,V2,V3,V4,V5,V6,V7]),write('|'),nl,
    I2 is I+1,
    afficheGrilleRec([C1,C2,C3,C4,C5,C6,C7],I2).
    
strt(Grille) :- afficheGrille(Grille).