adjacent(c, a).
adjacent(c, b).
adjacent(c, d).
adjacent(c, e).
adjacent(a, b).
adjacent(a, d).
adjacent(e, b).
adjacent(e, d).
adjacentTo(X, Y) :- adjacent(X, Y); adjacent(Y, X).
color(a, rouge, coloriage1).
color(b, bleu, coloriage1).
color(d, bleu, coloriage1).
color(e, rouge, coloriage1).
color(c, vert, coloriage1).
color(a, rouge, coloriage2).
color(b, rouge, coloriage2).
color(d, rouge, coloriage2).
color(e, rouge, coloriage2).
color(c, rouge, coloriage2).
conflit(X, Y, Coloriage) :- adjacentTo(X, Y), color(X, C1, Coloriage),  color(Y, C2, Coloriage), C1==C2.
conflit(Coloriage) :- conflit(_, _, Coloriage).



















