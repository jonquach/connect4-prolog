go :- readln(P),
        p(P,[]),
        go.


p --> [Sujet],etre,[Qualificatif], 
        {SEM =.. [Qualificatif,Sujet],write(SEM),assert(SEM)}.

p --> t,[Sujet],etre,[Qualificatif],
    {Consequence =..[Qualificatif,X],Condition =..[Sujet,X],assert(Consequence :- Condition),write(Consequence :- Condition)}.

p--> question, [Sujet],etre,[Qualificatif],
    {SEM =.. [Qualificatif,Sujet],valide(SEM)}.

valide(X) :- X,write("oui").
valide(X) :- not(X),write("non").


etre --> [est],[un].
etre --> [est],[une].
etre --> [est].

t --> [tout].
t --> [toutes].

question --> [est],[ce],[que].