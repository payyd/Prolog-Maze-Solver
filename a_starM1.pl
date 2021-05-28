
%Patrick Whelan C17478104 

row_num(5).
col_num(5).

%tile where we start from
startPos(maze(3,3)).

%goal tile i.e end
goalpos(maze(5,1)).

%creating blockades
block(maze(3,4)).
block(maze(4,4)).
block(maze(4,3)).
block(maze(3,2)).
block(maze(2,2)).
block(maze(4,2)).

%function which checks if we are able to move into a certain tile, i.e is it blocked or not

check(down, maze(X,Y)) :-
    X>1,
    X1 is X-1,
    \+block(maze(X1,Y)).
  
check(up, maze(X,Y)) :-
    \+row_num(X),
    X1 is X+1,
    \+block(maze(X1,Y)).
  
check(left, maze(X,Y)) :-
    Y>1,
    Y1 is Y-1,
    \+block(maze(X,Y1)).
  
check(right, maze(X,Y)) :-
    \+col_num(Y),
    Y1 is Y+1,
    \+block(maze(X,Y1)).

%function for moving tile either left right up or down
go(right, maze(X,Y), maze(X, YAdjacent)) :-
    YAdjacent is Y+1.
go(left, maze(X,Y), maze(X, YAdjacent)) :-
    YAdjacent is Y-1.
go(down, maze(X,Y), maze(XUp,Y)) :-
    XUp is X-1.
go(up, maze(X,Y), maze(XDown,Y)) :-
    XDown is X+1.
  
maxDepth(D) :-
    row_num(X),
    col_num(L),
    D is X * L.
  

cost(maze(_,_), maze(_, _), Cost) :-
    Cost is 1.


heuristic(maze(X1, Y1), [], L) :-
    goalpos(maze(X2, Y2)),
    L is abs(X1-X2) + abs(Y1-Y2).



a_star_comparator(R, node(_, _, G_Cost_1, H_Cost_1), node(_, _, G_Cost_2, H_Cost_2)) :-
    F1 is G_Cost_1 + H_Cost_1,
    F2 is G_Cost_2 + H_Cost_2,
    F1 >= F2 -> X = > ; X = < .


start:-
    astar(S),
    write(S).
  
astar(Solution) :-
    startPos(S),
    heuristic(S, _, HeuristicS),
    astar_search([node(S, [], 0, HeuristicS)], [], Solution),
    write(Solution).
  

astar_search([node(S, ActionsListForS, _, _)|_], _, ActionsListForS):-
    goalpos(S).

astar_search([node(S, ActionsListForS, ActualPathCost, HeuristicCost)|Frontier], ExpandedNodes, Solution):-
    findall(Az, check(Az, S), checkActionsList),
    createSons(node(S, ActionsListForS, ActualPathCost, HeuristicCost), checkActionsList, ExpandedNodes, SChilderenList),
    append(SChilderenList, Frontier, NewFrontier),
    predsort(a_star_comparator, NewFrontier, OrderedResult),
    astar_search(OrderedResult, [S|ExpandedNodes], Solution).


createSons(_, [], _, []).
createSons(node(S, ActionsListForS, PathCostForS, HeuristicOfS),
               [Action|OtherActions],
               ExpandedNodes,
               [node(NewS, ActionsListForNewS, PathCostForNewS, HeuristicCostForNewS)|OtherChildren]):-
    go(Action, S, NewS),
    \+member(NewS, ExpandedNodes),
    cost(S, NewS, Cost),
    PathCostForNewS is PathCostForS + Cost,
    heuristic(NewS, _, HeuristicCostForNewS),
    append(ActionsListForS, [Action], ActionsListForNewS),
    createSons(node(S, ActionsListForS, PathCostForS, HeuristicOfS), OtherActions, ExpandedNodes, OtherChildren),
    !.

createSons(Node, [_|OtherActions], ExpandedNodes, ChildNodesList) :-
    createSons(Node, OtherActions, ExpandedNodes, ChildNodesList),
    !.