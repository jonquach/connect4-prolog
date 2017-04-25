%go/0
%prédicat de début de l'exécution de l'analyseur
go :- readln(P),
        p(P,[]),
        nl,
        go.

%Phrases de forme A
p --> [Sujet],etre,[Qualificatif], 
        {SEM =.. [Qualificatif,Sujet],write(SEM),assert(SEM)}.

%Phrases de forme B
p --> t,[Sujet],etre,[Qualificatif],
    {Consequence =..[Qualificatif,X],Condition =..[Sujet,X],assert(Consequence :- Condition),write(Consequence :- Condition)}.

%Phrases de forme C
p--> question, [Sujet],etre,[Qualificatif],
    {SEM =.. [Qualificatif,Sujet],valide(SEM)}.

%valide/1
%Valide si X est valide. Si oui, on écrit oui. Sinon, on écrit non.
valide(X) :- X,write("oui").
valide(X) :- not(X),write("non").


etre --> [est],[un].
etre --> [est],[une].
etre --> [est].

t --> [tout].
t --> [toutes].

question --> [est],[ce],[que].