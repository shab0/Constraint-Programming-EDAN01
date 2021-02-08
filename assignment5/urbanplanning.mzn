include "urban_1.dzn";
include "globals.mzn";

int: n;
int: n_commercial;
int: n_residential;
array[1..n+1] of -n..n: point_distribution;

% ------------- MAIN -------------------

% Placemenent matrix where 1 = residential, 2 = commercial
array[1..n, 1..n] of var 1..2: placement;
  
% Constrain the amount of residential lots to exactly = n_residential
constraint
  sum(i in 1..n, j in 1..n)(
    bool2int(placement[i, j] == 1)
  ) == n_residential;

% Require adjacent rows and adjacent columns in "placement" to be
% lexicographically ordered to further constrain the values
constraint
  lex2(placement);

% Points = sum of point_distribution[number of residential lots + 1]
% for every row and column in placement
var int: points = sum(i in 1..n)(
  point_distribution[count(row(placement, i), 1) + 1] + point_distribution[count(col(placement, i), 1) + 1]
);
  
solve maximize points;

output(["Points: ", show(points), "\n"]);
output([show(row(placement, i)) ++ "\n" | i in 1..n]);
 