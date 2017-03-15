go :- how_to_play,
    strt(
    [[v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v],
    [v,v,v,v,v,v]]).

how_to_play :-
  write('Vous êtes le joueur rouge (r). Vous devez aligner 4 jetons horizontalement, verticalement ou diagonalement.'),
  nl,
  write('Choisissez la colonne ou vous voulez placer votre jeton (1-7)'),
  nl.

strt(Grid).