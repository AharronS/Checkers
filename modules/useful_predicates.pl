%%swap element in list(from exam preparation lesson)
%swap(L,Count1,Count2,Res):-
%	swap(L,Count1,Count2,Data1,Data2,Res).
%swap([Data2|Tail],0,1,Data1,Data2,[Data1|Tail]):-!.
%swap([X|Tail],0,Count2,Data1,Data2,[X|Res]):-!,
%	Next_Count2 is Count2 -1,
%	swap(Tail,0,Next_Count2,Data1,Data2,Res).
%swap([X|Tail],1,Count2,X,Data2,[Data2|Res]):-!,
%	Next_Count2 is Count2 -1,
%	swap(Tail,0,Next_Count2,X,Data2,Res).
%swap([X|Tail],Count1,Count2,Data1,Data2,[X|Res]):-
%	Next_Count2 is Count2 -1,
%	Next_Count1 is Count1 -1,
%	swap(Tail,Next_Count1,Next_Count2,Data1,Data2,Res).
%

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
	