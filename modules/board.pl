% Programmer: Aharon Shenvald - 200532521
% File Name: board.pl
% Date: 23/11/2017
% Description: Artificial Intellegence Checkers Game

:-  ensure_loaded([basic_game_relations]).
:-  ensure_loaded([useful_predicates]).
:-  ensure_loaded([game_moves]).
:-  ensure_loaded([tui]).
:-  ensure_loaded([alpha_beta]).

%Always remember initiate this!
init_game_board_size(Size):-
	Size >= 8, %minimum board size
	retractall(board_size(_)),
	assert(board_size(Size)),!.

get_game_board_size(BoardSize):-
	board_size(BoardSize),!.

is_valid_position(SrcLine, SrcColumn, DstLine, DstColumn):-
	is_valid_position(SrcLine, SrcColumn),
	is_valid_position(DstLine, DstColumn).
is_valid_position(Line, Column):-
	is_valid_position(Line),
	is_valid_position(Column).
is_valid_position(Pos):-
	get_game_board_size(BoardSize),
	Pos >= 1, Pos =< BoardSize.
	
board_list_switch(GameBoard, List):-
	GameBoard =.. [board|List].

position_to_index(Line, Column, Position):-
	get_game_board_size(BoardSize),
	Position is (Line-1)*BoardSize + Column.

index_to_position(Position, Line, Column):-
	get_game_board_size(BoardSize),
	Line is Position//BoardSize+1,
	Column is Position mod BoardSize.


generate_board_row(Parity, PlayerSign, BlockedSign, BoardSize, Row):-
	generate_board_row(Parity, PlayerSign, BlockedSign, 1, BoardSize, Row).
	
generate_board_row(odd, PlayerSign, BlockedSign, RowIndex, RowIndex, [LastElement]):-
	(even_or_odd(RowIndex, even), LastElement=PlayerSign,!)
	;
	(even_or_odd(RowIndex, odd), LastElement=BlockedSign,!).

generate_board_row(even, PlayerSign, BlockedSign, RowIndex, RowIndex, [LastElement]):-
	(even_or_odd(RowIndex, odd), LastElement=PlayerSign,!)
	;
	(even_or_odd(RowIndex, even), LastElement=BlockedSign,!).
	
generate_board_row(odd, PlayerSign, BlockedSign, RowIndex, BoardSize, [Res1|Res]):-
	RowIndex =< BoardSize,
	Index1 is RowIndex + 1,
	((even_or_odd(RowIndex, even), Res1=PlayerSign,!)
	;
	(even_or_odd(RowIndex, odd), Res1=BlockedSign,!)),
	generate_board_row(odd, PlayerSign, BlockedSign, Index1, BoardSize, Res).

generate_board_row(even, PlayerSign, BlockedSign, RowIndex, BoardSize, [Res1|Res]):-
	RowIndex =< BoardSize,
	Index1 is RowIndex + 1,
	((even_or_odd(RowIndex, odd), Res1=PlayerSign,!)
	;
	(even_or_odd(RowIndex, even), Res1=BlockedSign,!)),
	generate_board_row(even, PlayerSign, BlockedSign, Index1, BoardSize, Res).

even_or_odd(Num, Parity):-
	((Num mod 2 =:= 0, Parity=even,!);(Num mod 2 =:= 1, Parity=odd,!)).

generate_game_board(PlayerSign, OpposingPlayerSign, EmptySign, BlockedSign, Res):-
	get_game_board_size(BoardSize),
	generate_game_board(1, 3, BoardSize, PlayerSign, BlockedSign, [], Res1), 
	EmptyIndex is BoardSize - 3,
	generate_game_board(4, EmptyIndex, BoardSize, EmptySign, BlockedSign, [], Res2),
	NextSection is EmptyIndex + 1,
	generate_game_board(NextSection, BoardSize, BoardSize, OpposingPlayerSign, BlockedSign, [], Res3), 
	append(Res1, Res2, TmpRes),
	append(TmpRes, Res3, ResList),!,
	board_list_switch(Res, ResList).
	

generate_game_board(UpperLimitNumer, UpperLimitNumer, BoardSize, PlayerSign, BlockedSign, TmpRes, Res):-
	even_or_odd(UpperLimitNumer, Parity), 
	generate_board_row(Parity, PlayerSign, BlockedSign, BoardSize, RowRes),!,append(TmpRes, RowRes, Res).

generate_game_board(RowNumber, UpperLimitNumer, BoardSize, PlayerSign, BlockedSign, TmpRes, Res):-
	NextRowNumber is RowNumber + 1,
	even_or_odd(RowNumber, Parity),
	generate_board_row(Parity, PlayerSign, BlockedSign, BoardSize, RowRes),
	!,append(TmpRes, RowRes, Tmp),
	generate_game_board(NextRowNumber, UpperLimitNumer, BoardSize, PlayerSign, BlockedSign, Tmp, Res).

count_sign_on_board(GameBoard, PlayerSign, ResCount):-
	board_list_switch(GameBoard, GameBoardList),
	count_sign_in_list(GameBoardList, PlayerSign, ResCount, 0).

get_soldier_or_king(GameBoard, Line, Col, PlayerSign):-
	get_element_with_sign(GameBoard, PlayerSign, Line, Col),
	(PlayerSign=b ; PlayerSign=kb ; PlayerSign=w ; PlayerSign=kw).
	
	
	
	
	

	