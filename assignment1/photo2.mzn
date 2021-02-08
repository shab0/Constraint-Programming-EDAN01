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

function var int: get_index(var int: element, array[1..n] of var 1..n: arr) = 
  sum([ if element = arr[i] then i else 0 endif | i in 1..n ]);

predicate satisfies(array[1..2] of var 1..n: row, array[1..n] of var 1..n: arr) =
  abs(get_index(row[1], arr) - get_index(row[2], arr)) == 1;

score = sum(i in 1..n_prefs) (
  bool2int(satisfies(row(prefs, i), placement))
);

constraint
  all_different(placement);

solve maximize score;

output[show(placement), show(score)];