

%C17478104 Patrick Whelan

row_num(10).
col_num(10).

%tile where we start from
startPos(maze(1,1)).

%goal tile i.e end
goalPos(maze(6,8)).

%creating blockades
block(maze(4,2)).
block(maze(4,3)).
block(maze(4,4)).
block(maze(4,5)).
block(maze(4,6)).
block(maze(4,7)).
block(maze(4,8)).
block(maze(4,9)).
block(maze(4,10)).

block(maze(5,6)).
block(maze(6,6)).
block(maze(7,6)).
block(maze(8,6)).
block(maze(9,6)).

block(maze(7,7)).
block(maze(7,8)).
block(maze(7,9)).

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

go(left, maze(X,Y), maze(X, YAdjacent)) :-
    YAdjacent is Y-1.

go(down, maze(X,Y), maze(XUp,Y)) :-
    XUp is X-1.

go(up, maze(X,Y), maze(XDown,Y)) :-
    XDown is X+1.

go(right, maze(X,Y), maze(X, YAdjacent)) :-
    YAdjacent is Y+1.

start:-
    depthFirst(S).

%solve(N, [N] ) :-  goal(N).solve(N, [N1 | S1) :- successor(N, N1), solve(N1,S1) 

depthFirst(Sol) :-
  startPos(S),
  depthSearch(S, Sol, [S]),
  write(Sol).


depthSearch(S, _, _) :- goalPos(S), !.
depthSearch(S, [Action|OtherActions], VisitedNodes) :-
  check(Action, S),
  go(Action, S, NewS),
  %\+member(NewS, VisitedNodes), 
  not(member(NewS, VisitedNodes)),
  depthSearch(NewS, OtherActions, [NewS|VisitedNodes]).