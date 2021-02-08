include "data_1.dzn";
include "all_different.mzn";
include "globals.mzn";

% Provided values
int: n;
int: n_prefs;
array[1..n_prefs, 1..2] of var 1..n: prefs;

% Placement array
array[1..n] of var 1..n: placement;

% Maximum distance
var int: maxdist;

function var int: get_index(var int: element, array[1..n] of var 1..n: arr) = arr[element];
  %sum([ if element = arr[i] then i else 0 endif | i in 1..n ]);

function var int: distance(var int: x, var int: y, array[1..n] of var 1..n: arr) =
  abs(get_index(x, arr) - get_index(y, arr));

maxdist = max(i in 1..n_prefs) (
  distance(prefs[i, 1], prefs[i, 2], placement)
);

constraint
  all_different(placement);

solve minimize maxdist;

output[show(placement), show(maxdist)];