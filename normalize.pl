:- use_module(library(chr)).

:- chr_constraint normalize/2.
:- chr_constraint normalize/3.
:- chr_constraint build/2.
:- chr_constraint mult_vars/3.
:- chr_constraint merge_var_abs/3.
:- chr_constraint simplify/2.
:- chr_constraint simplify/3.
:- chr_constraint remove_from_list/3.
:- chr_constraint remove_from_list/4.

% normalize/2: normalizes a linear combination of linear terms and brings it in the form a*X+b*Y+...+c.
%   example: normalize(X, R).   -->   R = 1*X+0.
%   example: normalize(2*(X+12-Y*2)/4, R).   -->   R = 0.5*X-1.0*Y+6.0.
%   example: normalize(2*(X+12-Y*2)/4-X/2, R).   -->   R = -1.0*Y+6.0.

normalize(X, R) <=> normalize(X, Vars, Abs), simplify(Vars, Vars2), build(Vars2, Rv), merge_var_abs(Rv, Abs, R).

normalize(-A, Vars, Abs) <=> normalize((-1)*A, Vars, Abs).
normalize(A-C, Vars, Abs) <=> normalize(A+(-1)*C, Vars, Abs).

normalize(A+C, Vars, Abs) <=> number(C) | normalize(A, Vars, Abs2), Abs is Abs2+C.
normalize(C+A, Vars, Abs) <=> number(C) | normalize(A, Vars, Abs2), Abs is Abs2+C.
normalize(C1*C2, Vars, Abs) <=> number(C1), number(C2) | Vars = [], Abs is C1*C2.

normalize(A+B, Vars, Abs) <=> normalize(A, Vars1, Abs1), normalize(B, Vars2, Abs2), merge(Vars1, Vars2, Vars), Abs is Abs1+Abs2.

normalize(A/C, Vars, Abs) <=> number(C) | Cn is 1/C, normalize(Cn*A, Vars, Abs).
normalize(C*(A+B), Vars, Abs) <=> normalize(C*A+C*B, Vars, Abs).
normalize((A+B)*C, Vars, Abs) <=> normalize(C*A+C*B, Vars, Abs).
normalize(C*A, Vars, Abs) <=> number(C) | normalize(A, Vars2, Abs2), mult_vars(Vars2, C, Vars), Abs is C*Abs2.
normalize(A*C, Vars, Abs) <=> number(C) | normalize(A, Vars2, Abs2), mult_vars(Vars2, C, Vars), Abs is C*Abs2.

% end of recursion
normalize(X, Vars, Abs) <=> number(X) | Abs is X, Vars = [].
normalize(X, Vars, Abs) <=> var(X) | Vars = [[X, 1]], Abs = 0.

% build
build([], R) <=> R is 0.
build([[V, C]], R) <=> R = C*V.
build([[V, C]|Rest], R) <=> C<0 | build(Rest, R2), abs(C, Ca), R = R2-Ca*V.
build([[V, C]|Rest], R) <=> build(Rest, R2), R = R2+C*V.

% merge variables and absolute value
merge_var_abs(0, A, R) <=> R = A.
merge_var_abs(V, A, R) <=> A<0 | abs(A, Aa), R = V-Aa.
merge_var_abs(V, A, R) <=> R = V+A.

% mult_vars
%   example: mult_vars([[A, 1], [B, 2]], 5, R).  -->   R = [[A, 5], [B, 10]].
mult_vars([], _, R) <=> R = [].
mult_vars([[V, C]|Rest], M, R) <=> mult_vars(Rest, M, R2), CM is C*M, merge([[V, CM]], R2, R).

% simplify
%   example: simplify([[A, 1], [A, 2]], R).   -->   R = [[A, 3]].
%   example: simplify([[A, 1], [A, -1]], R).   -->   R = [].
%   example: simplify([[A, 1], [A, 3], [C, -1], [B, 0.5], [C, 2], [A, -4]], R).   -->   R = [[B, 0.5], [C, 1]].
simplify(A, R) <=> simplify(A, [], R).

simplify([], L, R) <=> R = L.

simplify([[_, 0]|Rest], L, R) <=> simplify(Rest, L, R). % remove this and the following line to keep variables with coefficient 0.
simplify([[_, 0.0]|Rest], L, R) <=> simplify(Rest, L, R).

simplify([[Var, Coeff]], L, R) <=> R = [[Var, Coeff]|L].
simplify([[Var, Coeff]|Rest], L, R) <=> member([Var1, Coeff2], Rest), Var1 == Var | remove_from_list(Rest, [Var, Coeff2], Rest2), CoeffN is Coeff + Coeff2, simplify([[Var, CoeffN]|Rest2], L, R).
simplify([[Var, Coeff]|Rest], L, R) <=> simplify(Rest, [[Var, Coeff]|L], R).
simplify(_, _, _) <=> false.

% remove_from_list
%   example: remove_from_list([[A, 1], [A, 3], [C, -1]], [A, 3], R).   -->   R = [[C, -1], [A, 1]].
%   example: remove_from_list([[A, 0], [B, 1], [C, 2]], [B, 4], R).   -->   R = [[C, 2], [B, 1], [A, 0]].
remove_from_list(L, [Var, Coeff], R) <=> remove_from_list(L, [Var, Coeff], [], R).
remove_from_list([[Var1, Coeff]|Rest], [Var2, Coeff], RL, R) <=> Var1 == Var2 | append(Rest, RL, R).
remove_from_list([[Var1, Coeff1]|Rest], [Var2, Coeff2], RL, R) <=> remove_from_list(Rest, [Var2, Coeff2], [[Var1, Coeff1]|RL], R).
remove_from_list([], _, RL, R) <=> R = RL.

