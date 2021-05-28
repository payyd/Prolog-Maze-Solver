

%MAze 1 Patrick Whelan C17478104

row_num(5).
col_num(5).

%tile where we start from
startPos(maze(3,3)).
%goal tile i.e end
goalPos(maze(5,1)).

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
go(left, maze(X,Y), maze(X, YAdjacent)) :-
    YAdjacent is Y-1.

go(down, maze(X,Y), maze(XUp,Y)) :-
    XUp is X-1.

go(up, maze(X,Y), maze(XDown,Y)) :-
    XDown is X+1.

go(right, maze(X,Y), maze(X, YAdjacent)) :-
    YAdjacent is Y+1.


maxDepth(D) :-
    row_num(R),
    col_num(L),
    D is R * L.

start:-
    id(S).

  id(Sol):-
    maxDepth(D),
    startPos(S),
    length(_, L),
    L =< D,
    id_search(S, Sol, [S], L),
    write(Sol).

  id_search(S, [], _, _):-
    goalPos(S).
  id_search(S, [Action|OtherActions], VisitedNodes, N):-
    N>0,
    check(Action, S),
    go(Action, S, NewS),
    \+member(NewS, VisitedNodes),
    N1 is N-1,
    id_search(NewS, OtherActions, [NewS|VisitedNodes], N1).
