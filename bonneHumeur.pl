bonne_humeur(X) :- (a_argent(X), vacance(X), soleil); (reussir_travail(X), reussir_famille(X)).
a_argent(jean).
a_argent(alain).
vacance(jean) :- mois(aout).
vacance(alain) :- mois(juillet).
mois(juillet).
soleil :- mois(aout).
reussir_travail(jean).
reussir_travail(alain).
reussir_famille(alain).
