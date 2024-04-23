%Exercice 1 :

% 1.
:- dynamic arbre/2.
:- dynamic rocher/2.

% 2.
:- dynamic vache/4.

% 3.
:- dynamic dimitri/2.

% 4.
largeur(15).
hauteur(7).

% 5.
nombre_rochers(2).
nombre_arbres(3).
nombre_vaches(brune, 2).
nombre_vaches(simmental, 4).
nombre_vaches(alpine_herens, 5).

%Exercice 2:

% 1.
occupe(X, Y) :- arbre(X, Y); rocher(X, Y); vache(X, Y, _, _); dimitri(X, Y).

% 2.
libre(X, Y):- repeat, random(0, 5, X), random(0, 5, Y), not(occupe(X, Y)), !.

% 3.
placer_rochers(N) :- N1 is N - 1, N1 >= 0, libre(X, Y), assert(rocher(X, Y)).
placer_arbres(N) :- N1 is N - 1, N1 >= 0, libre(X, Y), assert(arbre(X, Y)).
placer_vaches(Race, N) :- N1 is N - 1, N1 >= 0, libre(X, Y), assert(vache(X, Y, Race, vivante)).
placer_dimitri :- libre(X, Y), assert(dimitri(X, Y)).
vaches(L) :- findall([X,Y], vache(X, Y, _, _), L).
creer_zombie :- vaches(L), random_member(V, L), [X | R] = V, [Y | _] = R, retract(vache(X, Y, _, _)), assert(vache(X, Y, brune, zombie)).

%Exercice 3:

% 1.
question(R) :- write('Dans quelle direction souhaitez vous deplacer Dimitri? (reste/nord/sud/est/ouest)'), nl, read(R).

% 2.
zombification :-
    findall((X,Y), vache(X, Y, _, zombie), Zombies),
    maplist(zombifier_voisins, Zombies).

zombifier_voisins((X, Y)) :-
    zombifier(X-1, Y),
    zombifier(X+1, Y),
    zombifier(X, Y-1),
    zombifier(X, Y+1).

zombifier(X, Y) :-
    retract(vache(X, Y, _, _)),
    assert(vache(X, Y, brune, zombie)).
zombifier(_, _).


% 3.
deplacement_vache(X, Y, Direction) :-
    nouvelle_position(X, Y, Direction, X1, Y1),
    inside_bounds(X1, Y1),
    not(occupe(X1, Y1)),
    vache(X, Y, Race, Etat),
    retract(vache(X, Y, Race, Etat)),
    assert(vache(X1, Y1, Race, Etat)).

nouvelle_position(X, Y, reste, X, Y).
nouvelle_position(X, Y, nord, X, Y+1).
nouvelle_position(X, Y, sud, X, Y-1).
nouvelle_position(X, Y, est, X+1, Y).
nouvelle_position(X, Y, ouest, X-1, Y).

inside_bounds(X, Y) :-
    largeur(L),
    hauteur(H),
    X >= 0, X < L,
    Y >= 0, Y < H.

deplacement_vaches:- vaches(L), maplist(tenter_deplacer, L).

tenter_deplacer((X, Y)) :-
    direction_aleatoire(D),
    deplacement_vache(X, Y, D).

direction_aleatoire(Direction) :-
    random_member(Direction, [reste, nord, sud, est, ouest]).

% 4.
deplacement_joueur(Direction) :-
    dimitri(X, Y),
    nouvelle_position(X, Y, Direction, X1, Y1),
    inside_bounds(X1, Y1),
    not(occupe(X1, Y1)),
    retract(dimitri(X, Y)),
    assert(dimitri(X1, Y1)).

% 5.
verification :-
    dimitri(X, Y),
    not(voisin_zombie(X, Y)).

voisin_zombie(X, Y) :-
    (   vache(X-1, Y, _, zombie) ;
        vache(X+1, Y, _, zombie) ;
        vache(X, Y-1, _, zombie) ;
        vache(X, Y+1, _, zombie) ).


% le reste est le code prédéfini du jeu

initialisation :-
  nombre_rochers(NR),
  placer_rochers(NR),
  nombre_arbres(NA),
  placer_arbres(NA),
  nombre_vaches(brune, NVB),
  placer_vaches(brune, NVB),
  nombre_vaches(simmental, NVS),
  placer_vaches(simmental, NVS),
  nombre_vaches(alpine_herens, NVH),
  placer_vaches(alpine_herens, NVH),
  placer_dimitri,
  creer_zombie,
  !.

affichage(L, _) :-
  largeur(L),
  nl.

affichage(L, H) :-
  rocher(L, H),
  print('O'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  arbre(L, H),
  print('T'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  dimitri(L, H),
  print('D'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, brune, vivante),
  print('B'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, brune, zombie),
  print('b'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, simmental, vivante),
  print('S'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, simmental, zombie),
  print('s'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, alpine_herens, vivante),
  print('H'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, alpine_herens, zombie),
  print('h'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  \+ occupe(L, H),
  print('.'),
  L_ is L + 1,
  affichage(L_, H).

affichage(H) :-
  hauteur(H).

affichage(H) :-
  hauteur(HMax),
  H < HMax,
  affichage(0, H),
  H_ is H + 1,
  affichage(H_).

affichage :-
  affichage(0),!.



jouer :-
  initialisation,
  tour(0, _).

tour_(_, _) :-
  \+ verification,
  write('Dimitri s\'est fait mordre'),!.
tour_(N, R) :-
  verification,
  M is N + 1,
  tour(M, R).

tour(N, R) :-
  affichage,
  question(R),
  deplacement_joueur(R),
  deplacement_vaches,
  zombification,
  tour_(N, R).