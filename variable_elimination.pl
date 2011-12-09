:- use_module(library(chr)).
:- use_module(helpers).

:- chr_constraint 
				eq/2,
				eqz/2,
				var_is/3.


% eq/2
eq(X, 0) <=> normalize(X, VarsT, Abs), simplify(VarsT, Vars), eqz(Vars, Abs).
eq(X, A) <=> number(A) | XA = X-A, eq(XA, 0).
eq(X, Y) <=> normalize(X-(Y), XY), eq(XY, 0).


% var_is/3
var_is(X, [], C) <=> X is C.
var_is(X, Vars, C) <=> member([C1, C2], Vars), number(C1), number(C2) | stringify(Vars, C, R), normalize(R, VarsN, AbsN), var_is(X, VarsN, AbsN).

var_is(X, XVars, XAbs) \ eqz(Vars, Abs)  <=> member([X2, _], Vars), X2 == X | stringify(XVars, XAbs, Replaced), replace_var(Vars, Abs, X, Replaced, [], R), normalize(R, VarsN, AbsN), simplify(VarsN, VarsNs), eqz(VarsNs, AbsN).


% eqz/2.
eqz([[Var, Coeff]], Abs) <=> Var is -1*(Abs/Coeff).

eqz([[Var, Coeff]|Rest], Abs1), eqz(Vars2, Abs2) <=> stringify(Rest, Abs1, Term1WoFirst), XrepN = -1*(Term1WoFirst)/Coeff, normalize(XrepN, Xrep), replace_var(Vars2, Abs2, Var, Xrep, [], R), normalize(R, VarsN, AbsN), simplify(VarsN, VarsNs), eqz(VarsNs, AbsN), normalize(Xrep, XVars, XAbs), var_is(Var, XVars, XAbs).

eqz(Vars, Abs) <=> member([V, C], Vars), number(V), number(C) | stringify(Vars, Abs, R), eq(R, 0).


% example: eq(A + 2*B + 3*C, 3), eq(3*A - B + 2*C, 1), eq(2*A + 3*B - C, 1).   -->   A = 0.0714286, B = 0.5, C = 0.642857.
