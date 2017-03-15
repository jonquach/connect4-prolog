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



%how_to_play/0
%Prédicat d'affichage des règles
how_to_play :-
  write('Vous êtes le joueur rouge (r). Vous devez aligner 4 jetons horizontalement, verticalement ou diagonalement.'),
  nl,
  write('Choisissez la colonne ou vous voulez placer votre jeton (0-6)'),
  nl.

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