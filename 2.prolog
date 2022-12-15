:- initialization(main).
my_points(X, Y) :-
 X == 'X' -> Y is 1
 ; X == 'Y' -> Y is 2
 ; X == 'Z' -> Y is 3.

his_points(X, Y) :-
 X == 'A' -> Y is 1
 ; X == 'B' -> Y is 2
 ; X == 'C' -> Y is 3.

read_a_line(X, Y) :- 
  get_char(A),
  get_char(C),
  his_points(A, X),
  get_char(B),
  my_points(B, Y),
  get_char(D).

winner(1, 2, 2).
winner(2, 3, 2).
winner(3, 1, 2).
winner(2, 1, 0).
winner(3, 2, 0).
winner(1, 3, 0).
winner(X, X, 1).
reverse(X, 1, C) :- winner(X, C, 0).
reverse(X, 2, C) :- winner(X, C, 1).
reverse(X, 3, C) :- winner(X, C, 2).

solve2(T, 0) :- print(T).
solve(T, 0) :- print(T).

  
solve(D, DY) :-
  read_a_line(X, Y),
  winner(X, Y, C),
  T is D + Y + C * 3,
  DP is DY - 1,
  solve(T, DP).

solve2(D, DY) :-
  read_a_line(X, Y),
  reverse(X, Y, Z),
  winner(X, Z, C),
  T is D + Z + C * 3,
  DP is DY - 1,
  solve2(T, DP).

main :- 
   %solve(0, 2500),
   solve2(0, 2500).
