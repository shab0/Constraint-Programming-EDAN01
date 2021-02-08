include "data_1.dzn";
include "all_different.mzn";
include "globals.mzn";

% Provided values
int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of var 1..n: prefs;

% Placement array
array[1..n] of var 1..n: placement;

% Number of satisfied prefs
var 0..n_prefs: score;

predicate satisfies(int: i, int: j) =
  (prefs[i,1] == placement[j] /\ prefs[i,2] == placement[j+1]) \/
  (prefs[i,2] == placement[j] /\ prefs[i,1] == placement[j+1]);

score = sum(i in 1..n_prefs, j in 1..n-1) (
  bool2int(satisfies(i, j))
);

constraint
  all_different(placement);

solve maximize score;

output[show(placement), show(score)];