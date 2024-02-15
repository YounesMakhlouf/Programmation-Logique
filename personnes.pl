personne(k,f,85,tunis).
personne(c,m,63,nabeul).
personne(d,f,60,nabeul).
personne(e,m,35,tunis).
personne(g,f,27,sousse).
personne(h,f,39,nabeul).
personne(i,m,40,nabeul).
personne(j,m,17,sousse).
personne(1,f,9,sousse).
personne(m,f,19,tunis).
personne(n,m,1,tunis).
individu(X) :- personne(X, _, _, _).
masculin(X) :- personne(X, m, _, _).
feminin(X) :- personne(X, f, _, _).
est_ag�_de(X, Y) :-  personne(X, _, Y, _).
habite_�(X, Y) :- personne(X, _, _, Y).
majeur(X) :- est_ag�_de(X, A), A >= 18.
mineur(X) :- est_ag�_de(X, A), A < 18.
m�me_age(X, Y) :- est_ag�_de(X, A), est_ag�_de(Y, B), A==B. % J'ai pens� ici ainsi que dans tout les predicats de la forms m�me_X a ajouter la condition que X soit different de Y, mais ma reflexion a abouti au fait qu'il vaut mieux ne pas l'ajouter car il serait tres contre-intuitif que X n'ait pas le meme salaire que lui meme, propri�t� de reflexivit� tr�s importante pour la correction de notre base.
habite_la_m�me_ville(X, Y) :- habite_�(X, A), habite_�(Y, B), A==B.
�poux_possible(X, Y) :-  majeur(X), majeur(Y),  personne(X, m,  A, _), personne(Y, f, B, _), abs(A - B) < 20. %On compare la valeur absolue de la difference d'age avec 20
profession(k, mafia, 99999999).
profession(m, coiffeur, 500).
profession(l, je_travaille_pas_je_suis_une_princesse, 450).
profession(n, taxiste, 1000).
m�me_profession(X, Y) :- profession(X, A, _), profession(Y, B, _), A == B.
gagne_plus(X, Y) :- profession(X, _, A), profession(Y, _, B), A > B.
m�me_ordre(X, Y) :- profession(X, _, A), profession(Y, _, B), (A - B >= 0 -> (A-B)=< 0.2*A ; (B-A) =< 0.2*B). % Si A>=B, on doit verifier que (A-B) inferieur ou egal � 20% de A, sinon on doit verifier que (B-A) inferieur ou egal � 20% de B.



















