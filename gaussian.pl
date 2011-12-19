:- use_module(library(chr)).
:- use_module(helpers).

% This solving strategy uses the Gaussian Algorithm to bring an equation
% system in solved form. It keeps one original equation and eliminates
% variable by variable by 

:- chr_constraint
				eqz/2.

% eqz/2
eqz([[Var, Coeff]], Abs) <=> Var is -1*(Abs/Coeff).
eqz(Vars, Abs) <=> member([V, C], Vars), number(V), number(C) | stringify(Vars, Abs, R), eq(R, 0).
eqz([], C) <=> C =\= 0 | false.

eqz([[Var, Coeff]|Rest], Abs1) \ eqz(Vars2, Abs2) <=> member([Var2, Coeff2], Vars2), Var2 == Var | stringify(Vars2, Abs2, S2), stringify([[Var, Coeff]|Rest], Abs1, S1), C is Coeff2/Coeff, normalize(S2-C*S1, R), eq(R, 0).
