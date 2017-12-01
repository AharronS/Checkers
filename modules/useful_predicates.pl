% Programmer: Aharon Shenvald - 200532521
% File Name: useful_predicates.pl
% Date: 23/11/2017
% Description: Artificial Intellegence Checkers Game


:-  ensure_loaded([basic_game_relations]).
:-  ensure_loaded([board]).
:-  ensure_loaded([game_moves]).
:-  ensure_loaded([tui]).
:-  ensure_loaded([alpha_beta]).

%with index 0!!!!
replace([_|T], 0, X, [X|T]):-!.
replace([H|T], I, X, [H|R]):- 
	I > -1, NI is I-1,!, replace(T, NI, X, R), !.
replace(L, _, _, L).

count_sign_in_list([], _, Res, Res) :- !.
count_sign_in_list([Sign|Xs], Sign, Res, Counter) :-
        !, Counter1 is Counter + 1,
        count_sign_in_list(Xs, Sign, Res, Counter1).
count_sign_in_list([_|Xs], Sign, Res, Counter) :-
        count_sign_in_list(Xs, Sign, Res, Counter).

%TODO: use this for append all list	
long_conc([],[]).
long_conc([[]|Others],L):-
	long_conc(Others,L).
long_conc([[X|L1]|Others],[X|L2]):-
	long_conc([L1|Others],L2).

%TODO: for debugging
print_board([], _, _).
print_board([X|BoardList], BoardSize, Index):-
	((Index mod BoardSize =:= 0,
	write(X), nl, !)
	;
	write(X),!),
	Index1 is Index + 1,
	print_board(BoardList, BoardSize, Index1).


take_sublist([], _, [], []):-!.
take_sublist([X|Xs], 1, [X], Xs):-!.
take_sublist([X|Xs], Counter, [X|Res], RestList):-
	NextCounter is Counter - 1,
	take_sublist(Xs, NextCounter, Res, RestList).

split_list_into_lists([], _, []):-!.
split_list_into_lists(List, InnerListLength, [Inner|Res]):-
	take_sublist(List, InnerListLength, Inner, Rest),
	split_list_into_lists(Rest, InnerListLength, Res).
	