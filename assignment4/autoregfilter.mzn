include "ar_1_3.dzn";
include "cumulative.mzn";
include "globals.mzn";
include "jacop.mzn";

% Duration of operations
int : del_add;
int : del_mul;

% How many consecutive operations
int : number_add;
int : number_mul;

int : n;
set of int : last;
set of int : add;
set of int : mul;

array[1..n] of set of int : dependencies;

% -------------------- Main ------------------------

% Duration of the longest operation
int: maxdel = max([del_add, del_mul]);
% Total possible number of cycles
int: cycles = maxdel * n;

% Start time for each of the operations
array[1..n] of var 0..cycles: start_time;
% Duration of each operation
array[1..n] of var 1..maxdel: duration = [ if i in mul then del_mul else del_add endif | i in 1..n ];

% Start time per operation type
array[1..card(add)] of var 0..cycles: add_start;
array[1..card(mul)] of var 0..cycles: mul_start;

% Map from global start_time to operation type start time
constraint
  add_start = [start_time[i] | i in 1..n where i in add];
constraint
  mul_start = [start_time[i] | i in 1..n where i in mul];

% Dependency constraints
constraint
  forall(oper in 1..n)(
  	  forall(dep in dependencies[oper]) (
  		  start_time[oper] + duration[oper] <= start_time[dep]
    )
  );
	
%                    Start time            Duration              Resource requirement      Limit
constraint cumulative(add_start, [del_add | i in 1..card(add)], [1 | i in 1..card(add)], number_add);
constraint cumulative(mul_start, [del_mul | i in 1..card(mul)], [1 | i in 1..card(mul)], number_mul);
	
var int: cost = max([start_time[l] + duration[l] | l in last]);

% Addition of diff2
array[1..card(add)] of var 1..number_add: choosen_add;
array[1..card(mul)] of var 1..number_mul: choosen_mul;
                
constraint diff2(add_start, choosen_add, [del_add | i in 1..card(add)], [1 | i in 1..card(add)]);
constraint diff2(mul_start, choosen_mul, [del_mul | i in 1..card(mul)], [1 | i in 1..card(mul)]);

solve::int_search(start_time, smallest_max, indomain_min, complete) minimize cost;

output([
  "Strt: ", show(start_time),
  "\nMulti1: ", show([mul_start[i] | i in 1..card(mul) where choosen_mul[i] == 2]),
  "\nAdder1: ", show([add_start[i] | i in 1..card(add) where choosen_add[i] == 1]),
  "\nCost: ", show(cost),
]);