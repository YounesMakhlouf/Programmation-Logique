%Exercice 1 :
% Déclarer les faits dynamiques pour les arbres, les rochers, les vaches et Dimitri
% 1.
:- dynamic arbre/2.
:- dynamic rocher/2.

% 2.
:- dynamic vache/4.

% 3.
:- dynamic dimitri/2.

% 4. Définir la largeur et la hauteur de lenvironnement
largeur(15).
hauteur(7).

% 5. Définir le nombre de rochers, arbres et vaches par race
nombre_rochers(2).
nombre_arbres(3).
nombre_vaches(brune, 2).
nombre_vaches(simmental, 4).
nombre_vaches(alpine_herens, 5).

%Exercice 2:
% 1. Vérifier si une case est occupée
occupe(X, Y) :- arbre(X, Y); rocher(X, Y); vache(X, Y, _, _); dimitri(X, Y).

% 2. Vérifier si une case est libre
libre(X, Y):- largeur(L), hauteur(H), repeat, random(0, L, X), random(0, H, Y), not(occupe(X, Y)), !.

% 3. Placer aléatoirement un certain nombre de rochers, arbres, vaches et Dimitri sur des cases libres
placer_rochers(N) :- N1 is N - 1, N1 >= 0, libre(X, Y), assert(rocher(X, Y)).
placer_arbres(N) :- N1 is N - 1, N1 >= 0, libre(X, Y), assert(arbre(X, Y)).
placer_vaches(Race, N) :- N1 is N - 1, N1 >= 0, libre(X, Y), assert(vache(X, Y, Race, vivante)).
placer_dimitri :- libre(X, Y), assert(dimitri(X, Y)).

% 4. Trouver toutes les vaches vivantes et les vaches zombies
vaches(L):-findall((X,Y),vache(X,Y,_,_),L).
vaches_zombies(L):-findall((X,Y),vache(X,Y,_,zombie),L).

% 5. Choisir une vache au hasard pour la transformer en zombie
vache_alea([], []).
vache_alea(L, [X,Y]):-length(L, S),
                      I is random(S),
                      nth0(I, L, (X,Y)).
creer_zombie:-vaches(L),
              vache_alea(L,[X,Y]),
              retract(vache(X,Y,Race,vivante)),
              assert(vache(X,Y,Race,zombie)).

%Exercice 3:
% 1. Demander à lutilisateur dans quelle direction déplacer Dimitri
question(R) :- write('Dans quelle direction souhaitez vous deplacer Dimitri? (reste/nord/sud/est/ouest)'), nl, read(R).

% 2. Vérifier si une vache est morte et la transformer en zombie si cest le cas
morte(X,Y):-vache(X,Y,_,zombie).
zombification(X,Y):-X1 is X-1,
                  morte(X1,Y),
                  retract(vache(X,Y,Race,vivante)),
                  assert(vache(X,Y,Race,zombie)),
                  !.
zombification(X,Y):-X1 is X+1,
                  morte(X1,Y),
                  retract(vache(X,Y,Race,vivante)),
                  assert(vache(X,Y,Race,zombie)),
                  !.
zombification(X,Y):-Y1 is Y-1,
                  morte(X,Y1),
                  retract(vache(X,Y,Race,vivante)),
                  assert(vache(X,Y,Race,zombie)),
                  !.
zombification(X,Y):-Y1 is Y+1,
                  morte(X,Y1),
                  retract(vache(X,Y,Race,vivante)),
                  assert(vache(X,Y,Race,zombie)),
                  !.
zombification(_,_).
zombification([]).
zombification([(X,Y)|L]):-zombification(X,Y),
                          zombification(L).
zombification:-vaches(L),zombification(L).

% 3. Déplacer aléatoirement les vaches dans différentes directions
deplacement_alea(L,M):-length(L, S),
                      I is random(S),
                      nth0(I,L,M).
deplacement_vache([]).
deplacement_vache([(X,Y)|L]):-deplacement_alea([reste,east,est,nord,sud],M),
                              deplacement_vache(X,Y,M),
                              deplacement_vache(L).
deplacement_vaches:-vaches(L),
                    deplacement_vache(L).
deplacement_vache(X,Y, nord):-Y>0,
                              Y1 is Y-1,
                              not(occupe(X,Y1)),
                              retract(vache(X,Y,Race,Etat)),
                              assert(vache(X,Y1,Race,Etat)),
                              !.
deplacement_vache(X,Y, sud):-hauteur(H),
                            Y<H-1,Y1 is Y+1,
                            not(occupe(X,Y1)),
                            retract(vache(X,Y,Race,Etat)),
                            assert(vache(X,Y1,Race,Etat)),
                            !.
deplacement_vache(X,Y, ouest):-X>0,
                              X1 is X-1,
                              not(occupe(X1,Y)),
                              retract(vache(X,Y,Race,Etat)),
                              assert(vache(X1,Y,Race,Etat)),
                              !.
deplacement_vache(X,Y,est):-largeur(L),
                            X<L-1,
                            X1 is X+1,
                            not(occupe(X1,Y)),
                            retract(vache(X,Y,Race,Etat)),
                            assert(vache(X1,Y,Race,Etat)),
                            !.
deplacement_vache(_,_,_).

% 4. Déplacer le joueur Dimitri dans les différentes directions
deplacement_joueur(nord):-dimitri(X,Y),
                          Y>0,
                          Y1 is Y-1,
                          not(occupe(X,Y1)),
                          retract(dimitri(X,Y)),
                          assert(dimitri(X,Y1)),
                          !.
deplacement_joueur(sud):-dimitri(X,Y),
                        hauteur(H),
                        Y<H-1,
                        Y1 is Y+1,
                        not(occupe(X,Y1)),
                        retract(dimitri(X,Y)),
                        assert(dimitri(X,Y1)),
                        !.
deplacement_joueur(ouest):-dimitri(X,Y),
                          X>0,
                          X1 is X-1,
                          not(occupe(X1,Y)),
                          retract(dimitri(X,Y)),
                          assert(dimitri(X1,Y)),
                          !.
deplacement_joueur(est):-dimitri(X,Y),
                        largeur(L),
                        X<L-1,
                        X1 is X+1,
                        not(occupe(X1,Y)),
                        retract(dimitri(X,Y)),
                        assert(dimitri(X1,Y)),
                        !.
deplacement_joueur(_).

% 5. Vérifier les positions autour de Dimitri pour les vaches non-zombies
verification(X,Y):-dimitri(X,Y),
              X1 is X+1,
              not(vache(X1,Y,_,zombie)),
              X2 is X-1,
              not(vache(X2,Y,_,zombie)),
              Y1 is Y+1,
              not(vache(X,Y1,_,zombie)),
              Y2 is Y-1,
              not(vache(X,Y2,_,zombie)).
verification:-verification(_,_).

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