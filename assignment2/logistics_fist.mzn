include "data_1.dzn";
include "globals.mzn";
include "subcircuit.mzn";

int: graph_size;
int: start;
int: n_dests;
int: n_edges;
array[1..n_dests] of 1..graph_size: dest;
array[1..n_edges] of 1..graph_size: from;
array[1..n_edges] of 1..graph_size: to;
array[1..n_edges] of int: cost;

% ----------------- From Data ---------------------

array[1..graph_size] of var 1..graph_size: path;
%array[1..n_edges] of var bool: used_edges;

var int: totcost = sum(i in 1..n_edges) (
  if (path[from[i]] == to[i] \/ path[to[i]] == from[i])
    then cost[i]
  else
    0
  endif
);

% Check if no edge between x and y
predicate noedge(var 1..graph_size: x, var 1..graph_size: y) =
  sum(i in 1..n_edges) (
    bool2int((from[i] == x /\ to[i] == y) \/ (from[i] == y /\ to[i] == x))
  ) = 0;

% Set domain for all vars in path
constraint
  forall(j in 1..n_dests, i in 1..graph_size where i != dest[j]) (
    forall(n in 1..graph_size where i != n) (
      noedge(i, n) -> path[i] != n
    )
  );
  
% Destination node must point to start
constraint
  path[dest[1]] == start;
  
constraint
  subcircuit(path);
  
solve minimize totcost;
  
output[show(path), show(totcost)];