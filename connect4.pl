%Go/0
%Prédicat démarant la partie
go :- how_to_play,
    afficheGrille( [[v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v]]),
    strt( [[v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v]],r).

%strt/2
%Débute un tour avec une nouvelle grille pour un joueur. On vérifie si le joueur précédent a gagné. Sinon, les joueurs jouent.
strt(Grille,j) :- gagne(Grille,r), nl, write('Rouge gagne!'),nl,afficheGrille(Grille).
strt(Grille,r) :- gagne(Grille,j), nl, write('Jaune gagne!'),nl,afficheGrille(Grille).
strt(Grille,_) :- grille_est_pleine(Grille), nl, write('Partie nulle!'),afficheGrille(Grille).
strt(Grille,r) :-
    rJoue(Grille,Nouvelle_Grille),
    afficheGrille(Nouvelle_Grille),nl,nl,
    strt(Nouvelle_Grille,j).
strt(Grille,j) :-
    jJoue(Grille,Nouvelle_Grille),
    afficheGrille(Nouvelle_Grille),nl,nl,
    strt(Nouvelle_Grille,r).

%rJoue/2
%le joueur rouge joue sur une grille et retourne la grille résultante
rJoue(Grille,Nouvelle_Grille) :-
    write('C\'est votre tour'),nl,
    read(N),
    place_jeton(r,N,Grille,Nouvelle_Grille).
%jJoue/2
%Le joueur jaune (IA) joue sur une grille et retourne la grille résultante.
jJoue(Grille,Nouvelle_Grille) :-
    minimax(Grille,j,Nouvelle_Grille,_).


%how_to_play/0
%Prédicat d'affichage des règles
how_to_play :-
  write('Vous êtes le joueur rouge (r). Vous devez aligner 4 jetons horizontalement, verticalement ou diagonalement.'),
  nl,
  write('Choisissez la colonne ou vous voulez placer votre jeton (0-6)'),
  nl.


%matrix/4
%Dans la grille, récupère la valeur à l'indice de la colonne et de la rangée désiré, et la mets dans Value
%Source:http://stackoverflow.com/questions/34949724/prolog-iterate-through-matrix
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

%grille_est_pleine/1
%Retourne vrai si la grille est pleine
grille_est_pleine([C1,C2,C3,C4,C5,C6,C7]) :- 
    not(member(v,C1)),not(member(v,C2)),not(member(v,C3)),not(member(v,C4)),not(member(v,C5)),not(member(v,C6)),not(member(v,C7)).


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

%gagne/2
%Vérifie si le Jeton gagne sur la Grille
gagne(Grille,Jeton) :-
    aligneVerticalPourVictoire(Grille,Jeton);
    aligneHorizontalPourVictoire(Grille,Jeton);
    aligneDiagonalDPourVictoire(Grille,Jeton);
    aligneDiagonalMPourVictoire(Grille,Jeton).


%%%%%Alignements%%%%%%%

%aligneVerticalPourVictoire/2
%Vérifie qu'un alignement vertical existe, mais enlève la restriction que la case précédente dois être vide
aligneVerticalPourVictoire(Grille,Jeton) :-
    matrix(Grille,R,C,Jeton),
    R1 is R+1,
    aligneVertical(Grille,Jeton,3,R1,C).

%aligneHorizontalPourVictoire/2
%Vérifie qu'un alignement horizontal existe, mais enlève la restriction que la case précédente ou suivante dois être vide
aligneHorizontalPourVictoire(Grille,Jeton) :-
    matrix(Grille,R,C,Jeton),
    C1 is C+1,
    aligneHorizontal(Grille,Jeton,3,R,C1).

%aligneDiagonalDPourVictoire/2
%Vérifie qu'un alignement diagonal descendant existe, mais enlève la restriction que la case précédente ou suivante dois être vide
aligneDiagonalDPourVictoire(Grille,Jeton) :-
    matrix(Grille,R,C,Jeton),
    C1 is C+1,R1 is R+1,
    aligneDiagonalD(Grille,Jeton,3,R1,C1).
%aligneDiagonalMPourVictoire/2
%Vérifie qu'un alignement diagonal montant existe, mais enlève la restriction que la case précédente ou suivante dois être vide
aligneDiagonalMPourVictoire(Grille,Jeton) :-
    matrix(Grille,R,C,Jeton),
    C1 is C+1,R1 is R-1,
    aligneDiagonalM(Grille,Jeton,3,R1,C1).



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
%Vérifie qu'un nombre de jetons de la couleur spécifié est aligné et utilisable horizontalement
aligneHorizontal(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Cprecedente is C-1, Csuivante is C+Nb,
    %on vérifie si la case à gauche et/ou à droite de la rangée est vide
    alignementEstValide(Grille,Jeton,Cprecedente,Csuivante,R,R),
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
%Vérifie qu'un nombre de jetons de la couleur spécifié est aligné et utilisable diagonalement en descendant
aligneDiagonalD(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Cprecedente is C-1, Rprecedente is R-1,
    Csuivante is C+Nb,Rsuivante is C+Nb,
    alignementEstValide(Grille,Jeton,Cprecedente,Csuivante,Rprecedente,Rsuivante),
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
%Vérifie qu'un nombre de jetons de la couleur spécifié est aligné et utilisable diagonalement en montant
aligneDiagonalM(Grille,Jeton,Nb) :-
    matrix(Grille,R,C,Jeton),
    Cprecedente is C-1, Rprecedente is R+1,
    Csuivante is C+Nb,Rsuivante is R-Nb,
    alignementEstValide(Grille,Jeton,Cprecedente,Csuivante,Rprecedente,Rsuivante),
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


%alignementEstValide/4
%Un alignement est utilisable si la case à gauche et à droite de la rangée est vide ou
%Si la case précédente n'est pas utilisé par le jeton et la case suivante est vide ou vice-versa
alignementEstValide(Grille,Jeton,Cprecedente,Csuivante,Rprecedente,Rsuivante) :-
    (matrix(Grille,Rprecedente,Cprecedente,v),matrix(Grille,Rsuivante,Csuivante,v));
    (not(matrix(Grille,Rprecedente,Cprecedente,Jeton)),matrix(Grille,Rsuivante,Csuivante,v));
    (matrix(Grille,Rprecedente,Cprecedente,v),not(matrix(Grille,Rsuivante,Csuivante,Jeton))).

%alignementExiste/4
%Vérifie si un alignement d'un certain nombre de jeton d'un type existe dans la grille
alignementExiste(Grille,Jeton,Nb) :-
    aligneVertical(Grille,Jeton,Nb);
    aligneHorizontal(Grille,Jeton,Nb);
    aligneDiagonalD(Grille,Jeton,Nb);
    aligneDiagonalM(Grille,Jeton,Nb).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Affichage de la grille%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%Partie IA %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code inspiré de l'exemple minimax.pl 

%%cas des feuilles
%%Non-Fonctionnel
%minimax(Grille,Joueur,_, Valeur ) :-
        %un noeud n'as pas d'enfant si le joueur gagne ou si la partie est nulle
%		(gagne(Grille,Joueur);grille_est_pleine(Grille)),
%        valeurGrille(Grille,Valeur).
%%cas des noeuds
minimax(Grille,Joueur,MeilleurSuccesseur,Valeur_) :-
        coupsPossibles(Grille,Joueur,ListeGrille),
        meilleur(ListeGrille,Joueur,MeilleurSuccesseur,Valeur_).


% Trouver la meilleure etape :
% 1) on calcule la valeur de chacune des etapes,
% 2) on recherche la valeur maximum,
% 3) on retourne cette valeur et l'etape correspondant a cette valeur
%meilleur/4
%calcule les valeurs heuristique de la liste d'étape et retourne le meilleur sucesseur
meilleur( ListeEtapes,Joueur, MS, Valeur ) :-
		calculeValeurs( ListeEtapes,Joueur, ListeValeurs ),
		rechercheMeilleurSuccesseur( Joueur, ListeEtapes, ListeValeurs, Valeur, MS).

%calculeValeurs/3
% Calcule la valeur minimax pour chaque etape de la liste.
calculeValeurs( [], _,[] ).
calculeValeurs( [ Grille | ListeGrille ],j,[Valeur|ListeValeurs] ) :-
		valeurGrille(Grille,Valeur),
		calculeValeurs( ListeGrille, j,ListeValeurs ).
calculeValeurs( [ Grille | ListeGrille ],r,[Valeur|ListeValeurs] ) :-
		valeurGrille(Grille,Valeur),
		calculeValeurs( ListeGrille, r,ListeValeurs ).

%rechercheMeilleurSuccesseur/5
% Recherche l'etape dans la liste ListeEtapes ayant la valeur donnee par
rechercheMeilleurSuccesseur(_,[Etape], [Valeur], Valeur, Etape ) :- !.
rechercheMeilleurSuccesseur(Joueur, [E1,E2|ListeEtapes], [V1,V2|ListeValeurs], MV, ME) :-
		meilleur_de(Joueur,E1, V1, E2, V2, Etape, Valeur),
		rechercheMeilleurSuccesseur(Joueur, [Etape|ListeEtapes], [Valeur|ListeValeurs], MV, ME).

%meilleur_de/7
% Pour faire remonter les valeurs des feuilles vers la racine
%Le premier paramètre représente le joueur qui joue présentement et qui recherche sa valeur préféré
%Si c'est à jaune de jouer, il veut l'étape avec la plus grande valeur
%Si c'est à rouge de jouer, il veut l'étape avec la plus petite valeur
meilleur_de(j,Etape1, Valeur1, Etape2, Valeur2, Etape1, Valeur1) :-
		Valeur1 > Valeur2, !.
meilleur_de(j, Etape1, Valeur1, Etape2, Valeur2, Etape2, Valeur2) :-
		Valeur1 =< Valeur2, !.
meilleur_de(r,Etape1, Valeur1, Etape2, Valeur2, Etape1, Valeur1) :-
		Valeur1 =< Valeur2, !.
meilleur_de(r,Etape1, Valeur1, Etape2, Valeur2, Etape2, Valeur2) :-
		Valeur1 > Valeur2, !.

%coupPossibles\3
%Vérifie quels coups sont possibles à partir de la première colonne d'une grille pour un jeton donné
%Cas ou on peut placer le jeton
coupsPossibles(Grille, Jeton, [RetourPlaceJeton|RetourCoupPoss]) :-
    place_jeton(Jeton,0, Grille, RetourPlaceJeton),
    coupsPossibles(Grille, Jeton, RetourCoupPoss,1).

%Cas ou on ne peut pas placer le jeton
coupsPossibles(Grille, Jeton, RetourCoupPoss) :-
    not(place_jeton(Jeton,0, Grille, _)),
    coupsPossibles(Grille, Jeton, RetourCoupPoss,1).

%coupsPossibles\4
%Vérifie quels coups sont possibles à partir d'une colonne spécifié d'une grille pour un jeton donné.
%Cas de base: La 7eme colonne est la dernière (et les indexs sont décalés)
coupsPossibles(_,_,[],7).
%Cas ou on peut placer le jeton
coupsPossibles(Grille, Jeton, [RetourPlaceJeton|RetourCoupPoss], NoCol) :-
    NoCol < 7,
    place_jeton(Jeton,NoCol, Grille, RetourPlaceJeton),
    C1 is NoCol + 1,
    coupsPossibles(Grille, Jeton, RetourCoupPoss, C1).
%Cas ou on ne peut pas placer le jeton
coupsPossibles(Grille, Jeton, RetourCoupPoss, NoCol) :-
    NoCol < 7,
    not(place_jeton(Jeton,NoCol, Grille, _)),
    C1 is NoCol + 1,
    coupsPossibles(Grille, Jeton, RetourCoupPoss, C1).

%%%%%valeurHeuristique%%%%
%valeurPourJoueur\3
%Retourne la valeure d'une grille selon les alignements pour un certain joueur
valeurPourJoueur(Grille,Joueur,1000) :-
    gagne(Grille,Joueur).
valeurPourJoueur(Grille,Joueur,Valeur) :-
    not(gagne(Grille,Joueur)),
    valeurPourJoueurRec(Grille,Joueur,3,Valeur).

valeurPourJoueurRec(Grille,Joueur,1,1) :-
    alignementExiste(Grille,Joueur,1).
valeurPourJoueurRec(Grille,Joueur,1,0) :-
    not(alignementExiste(Grille,Joueur,1)).
%Si un alignement existe d'un certain nombre de jetons, on retourne la valeur approprié
%Sinon, on vérifie si un alignement de un jeton de moins existe
valeurPourJoueurRec(Grille,Joueur,Nb,Valeur) :-
    alignementExiste(Grille,Joueur,Nb),
    Exposant is Nb-2,
    pow(10,Exposant,Puissance),
    Valeur is 5*Puissance.
valeurPourJoueurRec(Grille,Joueur,Nb,Valeur) :-
    not(alignementExiste(Grille,Joueur,Nb)),
    Nb1 is Nb-1,
    valeurPourJoueurRec(Grille,Joueur,Nb1,Valeur). 

%valeurGrille\2
%Retourne la valeur heuristique d'une grille en prenant en compte les deux joueur, j étant l'IA
valeurGrille(Grille,Valeur) :-
    valeurPourJoueur(Grille,r,ValeurR),
    valeurPourJoueur(Grille,j,ValeurJ),
    Valeur is ValeurJ-ValeurR.
