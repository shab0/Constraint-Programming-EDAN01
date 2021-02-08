include "urban_1.dzn";
include "globals.mzn";

int: n;
int: n_residential;
int: n_commercial;
array[1..n+1] of int: point_distribution;

array[1..n, 1..n] of var 0..1: layout;
array[1..n] of var -n..n: r_points;
array[1..n] of var -n..n: c_points;
array[1..n] of var 0..n: r_residentials;
array[1..n] of var 0..n: c_residentials;
var -n*n*5..n*n*5: total_points;
var 0..n_residential: total_residentials;

constraint forall(i in 1..n)(r_residentials[i] = sum(layout[i, 1..n]) /\ c_residentials[i] = sum(layout[1..n, i]));
constraint total_residentials = sum(r_residentials);
constraint total_residentials = n_residential;

constraint layout[1, 1] = 1; % Symmetry break
%constraint lex_lesseq([ layout[i,j] | i,j in 1..n ], [ layout[j,i] | i,j in 1..n ]) % Slower symmetry break. But more proper(?)

constraint forall(i in 1..n)(r_points[i] = point_distribution[r_residentials[i] + 1] 
                            /\ c_points[i] = point_distribution[c_residentials[i] + 1]);
constraint total_points = sum(r_points) + sum(c_points);

solve :: int_search([layout[i, j] | i, j in 1..n], first_fail, indomain_max, complete) maximize total_points;