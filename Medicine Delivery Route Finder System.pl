:- initialization(start).
:- use_module(library(lists)).

% locations

place(0, 'Medicine Warehouse (Malkaduwawa)').
place(1, 'Kurunegala Pharmacy').
place(2, 'Dambadeniya Pharmacy').
place(3, 'Kuliyapitiya Pharmacy').
place(4, 'Nikaweratiya Pharmacy').
place(5, 'Galgamuwa Pharmacy').
place(6, 'Wariyapola Pharmacy').
place(7, 'Melsiripura Pharmacy').
place(8, 'Mawathagama Pharmacy').
place(9, 'Polgahawela Pharmacy').
place(10, 'Yapahuwa Pharmacy').


% roads

road(0, 1, 5).
road(0, 8, 12).
road(0, 6, 20).
road(0, 10, 45).

road(1, 2, 30).
road(1, 8, 10).
road(1, 9, 20).
road(1, 7, 25).

road(2, 9, 15).
road(2, 6, 40).

road(9, 3, 35).

road(3, 2, 25).
road(3, 4, 45).
road(3, 6, 35).

road(6, 4, 20).

road(4, 5, 30).

road(5, 10, 25).
road(5, 7, 40).

road(10, 7, 35).


% blocked roads

blocked(0, 10).
blocked(9, 3).

is_blocked(X, Y) :-
    blocked(X, Y).

is_blocked(X, Y) :-
    blocked(Y, X).


valid_road(X, Y, Distance) :-
    road(X, Y, Distance),
    \+ is_blocked(X, Y).

valid_road(X, Y, Distance) :-
    road(Y, X, Distance),
    \+ is_blocked(X, Y).


% DFS

go_dfs(Start, Goal, Path, Cost) :-
    dfs(Start, Goal, [Start], ReversePath, 0, Cost),
    reverse(ReversePath, Path).

dfs(Goal, Goal, Visited, Visited, Cost, Cost).

dfs(Current, Goal, Visited, Path, CurrentCost, Cost) :-
    valid_road(Current, Next, Distance),
    \+ member(Next, Visited),
    NewCost is CurrentCost + Distance,
    dfs(Next, Goal, [Next|Visited], Path, NewCost, Cost).


% BFS

go_bfs(Start, Goal, Path, Cost) :-
    bfs([[Start, [Start], 0]], Goal, ReversePath, Cost),
    reverse(ReversePath, Path).

bfs([[Goal, Path, Cost]|_], Goal, Path, Cost).

bfs([[Current, Path, Cost]|Queue], Goal, FinalPath, FinalCost) :-
    findall(
        [Next, [Next|Path], NewCost],
        (
            valid_road(Current, Next, Distance),
            \+ member(Next, Path),
            NewCost is Cost + Distance
        ),
        NextStates
    ),
    append(Queue, NextStates, NewQueue),
    bfs(NewQueue, Goal, FinalPath, FinalCost).


% A* search

go_astar(Start, Goal, Path, Cost) :-
    heuristic(Start, Goal, H),
    astar([node(H, 0, Start, [Start])],
          Goal,
          ReversePath,
          Cost),
    reverse(ReversePath, Path).

astar([node(_, Cost, Goal, Path)|_],
      Goal,
      Path,
      Cost).

astar([node(_, Cost, Current, Path)|OpenList],
      Goal,
      FinalPath,
      FinalCost) :-

    findall(
        node(F, NewCost, Next, [Next|Path]),
        (
            valid_road(Current, Next, Distance),
            \+ member(Next, Path),
            NewCost is Cost + Distance,
            heuristic(Next, Goal, H),
            F is NewCost + H
        ),
        NewNodes
    ),
    append(OpenList, NewNodes, CombinedList),
    sort_open_list(CombinedList, SortedList),
    astar(SortedList, Goal, FinalPath, FinalCost).


% approximate coordinates used for A*

location_coordinate(0, 0, 0).
location_coordinate(1, 1, 0).
location_coordinate(2, 3, 0).
location_coordinate(3, 5, 1).
location_coordinate(4, 6, 0).
location_coordinate(5, 6, -2).
location_coordinate(6, 0, -1).
location_coordinate(7, 3, -2).
location_coordinate(8, 0, 1).
location_coordinate(9, 4, 1).
location_coordinate(10, 0, -2).

heuristic(Node, Goal, H) :-
    location_coordinate(Node, X1, Y1),
    location_coordinate(Goal, X2, Y2),
    DX is abs(X1 - X2),
    DY is abs(Y1 - Y2),
    H is DX + DY.

sort_open_list(Nodes, Sorted) :-
    sort(1, @=<, Nodes, Sorted).


% main program

start :-
    nl,
    writeln('MEDICINE DELIVERY ROUTE FINDER'),
    writeln('--------------------------------'),
    nl,
    show_menu,

    ask_location(
        'Enter starting location number (0-10): ',
        Start
    ),

    ask_location(
        'Enter destination location number (0-10): ',
        Goal
    ),

    (
        Start =:= Goal
    ->
        writeln('Starting location and destination cannot be the same.'),
        nl,
        start
    ;
        run_searches(Start, Goal)
    ).


% show locations

show_menu :-
    writeln('Available Locations:'),
    writeln('0. Medicine Warehouse (Malkaduwawa)'),
    writeln('1. Kurunegala Pharmacy'),
    writeln('2. Dambadeniya Pharmacy'),
    writeln('3. Kuliyapitiya Pharmacy'),
    writeln('4. Nikaweratiya Pharmacy'),
    writeln('5. Galgamuwa Pharmacy'),
    writeln('6. Wariyapola Pharmacy'),
    writeln('7. Melsiripura Pharmacy'),
    writeln('8. Mawathagama Pharmacy'),
    writeln('9. Polgahawela Pharmacy'),
    writeln('10. Yapahuwa Pharmacy'),
    nl.


% get user input

ask_location(Message, Location) :-
    write(Message),
    read(X),

    (
        integer(X),
        X >= 0,
        X =< 10
    ->
        Location = X
    ;
        writeln('Invalid location. Enter a number from 0 to 10.'),
        ask_location(Message, Location)
    ).


% run the three searches

run_searches(Start, Goal) :-

    place(Start, StartName),
    place(Goal, GoalName),

    nl,
    write('Starting Location: '),
    writeln(StartName),

    write('Destination: '),
    writeln(GoalName),

    nl,
    writeln('SEARCH RESULTS'),
    writeln('--------------'),
    nl,

    run_algorithm(
        'Depth First Search (DFS)',
        go_dfs(Start, Goal, Path1, Cost1),
        Path1,
        Cost1,
        Result1
    ),

    run_algorithm(
        'Breadth First Search (BFS)',
        go_bfs(Start, Goal, Path2, Cost2),
        Path2,
        Cost2,
        Result2
    ),

    run_algorithm(
        'A* Search',
        go_astar(Start, Goal, Path3, Cost3),
        Path3,
        Cost3,
        Result3
    ),

    compare_results(
        Path1, Cost1, Result1,
        Path2, Cost2, Result2,
        Path3, Cost3, Result3
    ),

    ask_again.


run_algorithm(Name, GoalQuery, Path, Cost, Result) :-

    write('Algorithm: '),
    writeln(Name),

    (
        call(GoalQuery)
    ->
        Result = yes,

        write('Path: '),
        print_path(Path),

        write('Total Distance: '),
        write(Cost),
        writeln(' km')
    ;
        Result = no,
        writeln('No valid route found.')
    ),

    nl.


print_path([]).

print_path([Node]) :-
    place(Node, Name),
    write('['),
    write(Name),
    writeln(']').

print_path([Node|Rest]) :-
    place(Node, Name),
    write('['),
    write(Name),
    write('] -> '),
    print_path(Rest).


% compare results

compare_results(
    Path1, Cost1, Result1,
    Path2, Cost2, Result2,
    Path3, Cost3, Result3
) :-

    nl,
    writeln('ALGORITHM COMPARISON'),
    writeln('--------------------'),
    nl,

    print_cost_result('DFS', Cost1, Result1),
    print_cost_result('BFS', Cost2, Result2),
    print_cost_result('A*', Cost3, Result3),

    nl,

    get_valid_costs(
        Cost1, Result1,
        Cost2, Result2,
        Cost3, Result3,
        ValidCosts
    ),

    (
        ValidCosts = []
    ->
        writeln('No routes were found by any algorithm.')
    ;
        compare_valid_costs(
            Cost1, Result1,
            Cost2, Result2,
            Cost3, Result3
        ),

        nl,
        writeln('Path Length Comparison:'),

        compare_valid_lengths(
            Path1, Result1,
            Path2, Result2,
            Path3, Result3
        )
    ),

    nl.


print_cost_result(Name, Cost, yes) :-
    write(Name),
    write(' Cost: '),
    write(Cost),
    writeln(' km').

print_cost_result(Name, _, no) :-
    write(Name),
    writeln(' Cost: No route').


get_valid_costs(
    Cost1, yes,
    Cost2, yes,
    Cost3, yes,
    [Cost1, Cost2, Cost3]
).

get_valid_costs(
    Cost1, yes,
    Cost2, yes,
    _, no,
    [Cost1, Cost2]
).

get_valid_costs(
    Cost1, yes,
    _, no,
    Cost3, yes,
    [Cost1, Cost3]
).

get_valid_costs(
    _, no,
    Cost2, yes,
    Cost3, yes,
    [Cost2, Cost3]
).

get_valid_costs(
    Cost1, yes,
    _, no,
    _, no,
    [Cost1]
).

get_valid_costs(
    _, no,
    Cost2, yes,
    _, no,
    [Cost2]
).

get_valid_costs(
    _, no,
    _, no,
    Cost3, yes,
    [Cost3]
).

get_valid_costs(
    _, no,
    _, no,
    _, no,
    []
).


compare_valid_costs(
    Cost1, Result1,
    Cost2, Result2,
    Cost3, Result3
) :-

    get_valid_costs(
        Cost1, Result1,
        Cost2, Result2,
        Cost3, Result3,
        ValidCosts
    ),

    min_list(ValidCosts, Minimum),

    write('Lowest returned route cost: '),
    write(Minimum),
    writeln(' km'),

    show_lowest_cost('DFS', Cost1, Result1, Minimum),
    show_lowest_cost('BFS', Cost2, Result2, Minimum),
    show_lowest_cost('A*', Cost3, Result3, Minimum).


show_lowest_cost(Name, Cost, yes, Minimum) :-
    Cost =:= Minimum,
    write(Name),
    writeln(' returned the lowest route cost.').

show_lowest_cost(_, _, _, _).


% path length comparison

compare_valid_lengths(
    Path1, Result1,
    Path2, Result2,
    Path3, Result3
) :-

    path_length(Path1, Result1, Length1),
    path_length(Path2, Result2, Length2),
    path_length(Path3, Result3, Length3),

    get_minimum_length(
        Length1,
        Length2,
        Length3,
        Minimum
    ),

    write('Minimum path length: '),
    write(Minimum),
    writeln(' locations'),

    show_minimum_length('DFS', Length1, Minimum),
    show_minimum_length('BFS', Length2, Minimum),
    show_minimum_length('A*', Length3, Minimum).


path_length(Path, yes, Length) :-
    length(Path, Length).

path_length(_, no, none).


get_minimum_length(
    Length1,
    Length2,
    Length3,
    Minimum
) :-

    get_length_value(Length1, Values1),
    get_length_value(Length2, Values2),
    get_length_value(Length3, Values3),

    append(Values1, Values2, TempValues),
    append(TempValues, Values3, ValidLengths),

    min_list(ValidLengths, Minimum).


get_length_value(Length, [Length]) :-
    Length \= none.

get_length_value(none, []).


show_minimum_length(Name, Length, Minimum) :-
    Length \= none,
    Length =:= Minimum,
    write(Name),
    writeln(' uses the minimum number of path locations.').

show_minimum_length(_, _, _).


% run again

ask_again :-

    write('Do you want to run another query? (y/n): '),
    read(Answer),

    (
        Answer == y
    ->
        start

    ;
        Answer == n
    ->
        writeln('Program terminated. Goodbye!')

    ;
        writeln('Please enter y or n.'),
        ask_again
    ).