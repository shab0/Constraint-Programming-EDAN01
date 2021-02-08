include "data_3.dzn";
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

% ------------------- Main -----------------------

array[1..n_dests, 1..graph_size] of var 1..graph_size: paths;

% Sum of costs. For every edge -> if used by any path -> add cost
var int: totcost = sum(i in 1..n_edges) (
  if sum(j in 1..n_dests) (edgeused(j, i)) > 0 then cost[i] else 0 endif
);

% Check if no edge between nodes x and y
predicate noedge(var 1..graph_size: x, var 1..graph_size: y) =
  sum(i in 1..n_edges) (
    bool2int((from[i] == x /\ to[i] == y) \/ (from[i] == y /\ to[i] == x))
  ) = 0;

% Check if edge from[ei] to[ei] is used in row(paths, pr)
predicate edgeused(int: pr, int: ei) =
  sum(i in 1..graph_size) (
    bool2int(
      (
        (from[ei] == i /\ to[ei] == paths[pr, i]) \/
        (from[ei] == paths[pr, i] /\ to[ei] == i)
      ) /\
      % Edge back to start is ignored
      paths[pr, i] != start
    )
  ) > 0;
  
% ---------------- Constraints --------------------

% Set domain for all nodes in all paths
constraint
  forall(j in 1..n_dests, i in 1..graph_size where i != dest[j]) (
    forall(n in 1..graph_size where i != n) (
      noedge(i, n) -> paths[j, i] != n
    )
  );
  
% Destination nodes must point to start
constraint
  forall(i in 1..n_dests) (
    paths[i, dest[i]] == start
  );

% Subcircuit for all rows in paths
constraint
  forall(i in 1..n_dests) (
    subcircuit(row(paths, i))  
  );
  
solve minimize totcost;
  
output["Paths:\n", show(paths), "\nTotal Cost = ", show(totcost)];