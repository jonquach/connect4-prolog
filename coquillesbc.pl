% Definition des operateurs
:- op( 800, fx, si ),
   op( 700, xfx, alors ),
   op( 300, xfy, ou ),
   op( 200, xfy, et ).
:- dynamic(fait/1).

% données du problème : fait( X ) - à ajouter

% Règles de la base de connaissances : si ... alors ... - à ajouter


% ch_arriere/1 : moteur d inference fonctionnant en chainage arriere
ch_arriere( But ) :- est_vrai( But ).
est_vrai( Proposition ) :- fait( Proposition ).
est_vrai( Proposition ) :- si Condition alors Proposition, est_vrai( Condition ).
est_vrai( Cond1 et Cond2 ) :- est_vrai( Cond1 ), est_vrai( Cond2 ).
est_vrai( Cond1 ou Cond2 ) :- est_vrai( Cond1 ) ; est_vrai( Cond2 ).

% ch_avant/0 : moteur d inference fonctionnant en chainage avant
ch_avant :-
 nouveau_fait( Nouveau ), !,
 write( 'Nouveau fait : ' ), write( Nouveau ), nl,
 assert( fait( Nouveau ) ), ch_avant.
ch_avant :-
 write( 'Plus de nouveaux faits déduits, la BC est saturée.'), nl.
nouveau_fait( NouvFait ) :-
 si Condition alors NouvFait, not( fait(NouvFait) ),
 recherche_fait( Condition ).
recherche_fait( Condition ) :-
 fait( Condition ).
recherche_fait( Cond1 et Cond2 ) :-
 recherche_fait( Cond1 ), recherche_fait( Cond2 ).
recherche_fait( Cond1 ou Cond2 ) :-
 recherche_fait( Cond1 ) ; recherche_fait( Cond2 ).

