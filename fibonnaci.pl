fib(0, F) :-  F is 1.
fib(1, F) :-  F is 1.
fib(X, F) :-  X >= 0, X1 is X - 1, X2 is X - 2, fib(X1, F1), fib(X2, F2), F is F1+F2.

