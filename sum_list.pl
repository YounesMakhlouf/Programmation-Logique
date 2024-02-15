somme([N], N) :- number(N).
somme([N|L], S) :- number(N), somme(L, S1), S is S1 + N.

max([N], N) :- number(N).
max([A, B], M) :- (A > B -> M is A, !; M is B, !).
max([N|L], M) :- number(N), max(L, M1), max([N, M1], M).



