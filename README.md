# Linear Equation Solving using Constraint Handling Rules

This project implements a constraint solver written in [Constraint Handling Rules](https://dtai.cs.kuleuven.be/CHR/) (CHR). It supports two solving strategies:

* `gaussian.pl`: Gaussian Elimination
* `variable_elimination.pl`: Variable Elimination

## Requirements

The constraint solvers are implemented as Prolog modules. They have been tested with SWI-Prolog.

## Usage

The modules can be directly loaded by SWI-Prolog using the following command:

```
swipl -s gaussian.pl
```

or

```
swipl -s variable_elimination.pl
```

Equations are specified by `eq/2` constraints using Prolog's logical variables. To specify _a + b = 2_, the constraint `eq(A+B,2)` should be added.

## Examples

```
?- eq(A+B, 2), eq(A-B, 0).
% A = 1, B = 1 .

?- eq(3*A-B, C), eq(A+2*C, 4-4*B), eq(2*B+C, 1).
% A = 2.0, B = -5.0, C = 11.0 .

?- eq(10*A+12*B, 38), eq(15*A+2*B, 19.4).
% A = 0.98, B = 2.35 .

?- eq(A + 2*B + 3*C, 3), eq(3*A - B + 2*C, 1), eq(2*A + 3*B - C, 1).
% A = 0.0714286, B = 0.5, C = 0.642857 .

?- eq(A-B, 2*B-5), eq(B-4*A+C, 6), eq(2*A+3*B, 3-C).
% A = -0.95, B = 1.35, C = 0.85 .

?- eq(6*A-B+C, 12*D-5), eq(-2*B-8, -6*A+8*D-2*C), eq(2*C, 4*D-3*A+5), eq(3*A, 9+4*D+B).
% A = 13.0, B = 6.0, C = -5.0, D = 6.0 .

?- eq(A+B, 0), eq(A+B, 1).
% false.
```
