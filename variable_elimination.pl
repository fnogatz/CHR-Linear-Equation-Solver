:- use_module(library(chr)).
:- use_module(helpers).

% This solving strategy uses the intuitive way to eliminate variables
% by making variables explicit in the form of X = -(b*Y+c*Z+...+u)/a
% and replacing all occurences of this variable in the other equations.

:- chr_constraint
				eqz/2,
				var_is/3.


% var_is/3
var_is(X, [], C) <=> X is C.
var_is(X, Vars, C) <=> member([C1, C2], Vars), number(C1), number(C2) | stringify(Vars, C, R), normalize(R, VarsN, AbsN), var_is(X, VarsN, AbsN).

var_is(X, XVars, XAbs) \ eqz(Vars, Abs)  <=> member([X2, _], Vars), X2 == X | stringify(XVars, XAbs, Replaced), replace_var(Vars, Abs, X, Replaced, [], R), normalize(R, VarsN, AbsN), simplify(VarsN, VarsNs), eqz(VarsNs, AbsN).


% eqz/2.
eqz([[Var, Coeff]], Abs) <=> Var is -1*(Abs/Coeff).
eqz(Vars, Abs) <=> member([V, C], Vars), number(V), number(C) | stringify(Vars, Abs, R), eq(R, 0).
eqz([], C) <=> C =\= 0 | false.

eqz([[Var, Coeff]|Rest], Abs) <=> Cinv is -1/Coeff, mult_vars(Rest, Cinv, VarsN), AbsN is -1*Abs/Coeff, var_is(Var, VarsN, AbsN).
