carre :-  write('donner un entier '), nl, read(X), (X > 0), nl, write('votre entier est '),write(X),nl, nl, Y is X * X, write('le carr� de '), write(X), write(' est '),write(Y), nl,nl, carre.

factoriel(0, 1).
factoriel(N, Y) :- N > 0, N1 is N-1, factoriel(N1, Y1), Y is N*Y1.