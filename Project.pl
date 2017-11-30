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

generate_board_row(Parity, SoldierSign, BlockedSign, Row):-
	get_game_board_size(BoardSize),
	generate_board_row(Parity, SoldierSign, BlockedSign, 1, BoardSize, Row).
	
generate_board_row(odd, SoldierSign, BlockedSign, RowIndex, RowIndex, [LastElement]):-
	(even_or_odd(RowIndex, even), LastElement=SoldierSign,!)
	;
	(even_or_odd(RowIndex, odd), LastElement=BlockedSign,!).

generate_board_row(even, SoldierSign, BlockedSign, RowIndex, RowIndex, [LastElement]):-
	(even_or_odd(RowIndex, odd), LastElement=SoldierSign,!)
	;
	(even_or_odd(RowIndex, even), LastElement=BlockedSign,!).
	
generate_board_row(odd, SoldierSign, BlockedSign, RowIndex, BoardSize, [Res1|Res]):-
	RowIndex =< BoardSize,
	Index1 is RowIndex + 1,
	((even_or_odd(RowIndex, even), Res1=SoldierSign,!)
	;
	(even_or_odd(RowIndex, odd), Res1=BlockedSign,!)),
	generate_board_row(odd, SoldierSign, BlockedSign, Index1, BoardSize, Res).

generate_board_row(even, SoldierSign, BlockedSign, RowIndex, BoardSize, [Res1|Res]):-
	RowIndex =< BoardSize,
	Index1 is RowIndex + 1,
	((even_or_odd(RowIndex, odd), Res1=SoldierSign,!)
	;
	(even_or_odd(RowIndex, even), Res1=BlockedSign,!)),
	generate_board_row(even, SoldierSign, BlockedSign, Index1, BoardSize, Res).

even_or_odd(Num, Parity):-
	((Num mod 2 =:= 0, Parity=even,!);(Num mod 2 =:= 1, Parity=odd,!)).
	
add_to_end(SrcList, Item, Res):-
	append(SrcList, [Item], Res).


