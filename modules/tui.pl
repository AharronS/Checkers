:-  ensure_loaded([basic_game_relations]).
:-  ensure_loaded([useful_predicates]).
:-  ensure_loaded([board]).


print_game_board(GameBoard):-
	board_list_switch(GameBoard, GameList),
	get_game_board_size(BoardSize),
	split_list_into_lists(GameList, BoardSize, SplittedGameList),
	print_game_board(BoardSize, BoardSize, SplittedGameList),!.
	
print_game_board(_, _, []):-!.
print_game_board(LineNum, LineNum, [H|Tail]):-
	print_game_row_start(LineNum, H),
	NextLine is LineNum - 1,!,
	print_game_board(LineNum, NextLine, Tail).
	
print_game_board(BoardSize, LineNum, [H|Tail]):-
	print_game_row(BoardSize, H),
	NextLine is LineNum - 1,
	print_game_board(BoardSize, NextLine, Tail).

print_game_row_start(BoardSize, BoardList):-
	print_frame_row(BoardSize),
	print_middle_row(BoardSize),
	print_soldier_row(BoardSize, BoardList)	,
	print_middle_row(BoardSize),
	print_frame_row(BoardSize).

print_game_row(BoardSize, BoardList):-
	print_middle_row(BoardSize),
	print_soldier_row(BoardSize, BoardList)	,
	print_middle_row(BoardSize),
	print_frame_row(BoardSize).
	
print_frame_row(BoardSize):-
	print_frame_row(BoardSize, BoardSize, Row),
	write(Row),nl,!.
print_frame_row(_, 1, '+-----+'):-!.
print_frame_row(BoardSize, Counter, Res):-
	NextCounter is Counter - 1,
	print_frame_row(BoardSize, NextCounter, Res1),
	atom_concat('+-----', Res1, Res).

print_middle_row(BoardSize):-
	print_middle_row(BoardSize, BoardSize, Row),
	write(Row),nl,!.
print_middle_row(_, 1, '|     |'):-!.
print_middle_row(BoardSize, Counter, Res):-
	NextCounter is Counter - 1,
	print_middle_row(BoardSize, NextCounter, Res1),
	atom_concat('|     ', Res1, Res).
	
print_soldier_square(Player, RowRes):-
	player_to_sign(Player, Sign),
	atom_concat('|  ', Sign, TmpRow),
	(
		((Sign='XX'; Sign='OO'; Sign='##' ), atom_concat(TmpRow, ' ', RowRes))
		;
		((Sign='X'; Sign='O'; Sign=' '), atom_concat(TmpRow, '  ', RowRes))
		
	).

print_soldier_row(BoardSize, BoardList):-
	print_soldier_row(BoardSize, BoardSize, BoardList, Res),
	write(Res),nl,!.
	
print_soldier_row(_, 1, [Player], RowRes):-
	print_soldier_square(Player, RowRes1),
	atom_concat(RowRes1, '|', RowRes).
	
print_soldier_row(BoardSize, Counter, [X|Xs], Res):-
	NextCounter is Counter - 1,
	print_soldier_row(BoardSize, NextCounter, Xs, Res1),
	print_soldier_square(X, TmpRow),
	atom_concat(TmpRow, Res1, Res).

get_who_play_first(Choice):-
	%o for computer start, x for user start.
	write('Who plays first? computer(o) or player(x):'),
	read(TmpChoice),
	((TmpChoice=x; TmpChoice=o), Choice=TmpChoice,!)
	;
	(write('Ilegal answer'),nl, get_who_play_first(Choice)).
	
get_user_next_move(SrcLine, SrcCol, DstLine, DstCol):-
	write('Insert your Move. Source Line:'), read(SrcLine), !, nl, 
	write('Source Column:'), read(SrcCol), !, nl, 
	write('Destination Line:'), read(DstLine), !, nl, 
	write('Destination Column:'), read(DstCol), !, nl, 
	(
		is_valid_position(SrcLine, SrcCol, DstLine, DstCol),!
		;
		(write('Ilegal answer'),!, nl, get_user_next_move(SrcLine, SrcCol, DstLine, DstCol))
	).
	
	
	
	


