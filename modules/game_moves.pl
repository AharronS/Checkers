% Programmer: Aharon Shenvald - 200532521
% File Name: game_moves.pl
% Date: 23/11/2017
% Description: Artificial Intellegence Checkers Game

:-  ensure_loaded([basic_game_relations]).
:-  ensure_loaded([useful_predicates]).
:-  ensure_loaded([board]).
:-  ensure_loaded([tui]).
:-  ensure_loaded([alpha_beta]).

%Check whether it is possible to make a eat move, otherwise check whether there is regular move.
get_legit_move(GameBoard, CurrentPlayer, ResGameBoard):-
	get_player_sign(CurrentPlayer, CurrentPlayerSign),
	get_legit_eat_movement(GameBoard, CurrentPlayerSign, ResGameBoard).
get_legit_move(GameBoard, CurrentPlayer, ResGameBoard):-
	not((get_player_sign(CurrentPlayer, CurrentPlayerSign),			
		get_legit_eat_movement(GameBoard, CurrentPlayerSign, ResGameBoard))),
	get_player_sign(CurrentPlayer, CurrentPlayerSign2),
	get_legit_regular_movement(GameBoard, CurrentPlayerSign2, ResGameBoard).

get_legit_regular_movement(GameBoard, CurrentPlayerSign, ResGameBoard):-
	get_line_and_col_by_sign(GameBoard, CurrentPlayerSign, PlayerLine, PlayerCol), 
	get_line_and_col_by_sign(GameBoard, e, EmptyLine, EmptyCol),
	is_legit_movement(GameBoard, CurrentPlayerSign, PlayerLine, PlayerCol, EmptyLine, EmptyCol, ResGameBoard).
	
is_legit_movement(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard):-
	check_desire_move_position(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol),
	insert_element_to_pos_in_board(GameBoard, SrcLine, SrcCol, e, TmpGameBoard1),
	insert_element_to_pos_in_board(TmpGameBoard1, DstLine, DstCol, CurrentPlayerSign, ResGameBoard).
	

get_legit_eat_movement(GameBoard, CurrentPlayerSign, ResGameBoard):-
	get_line_and_col_by_sign(GameBoard, CurrentPlayerSign, PlayerLine, PlayerCol), 
	get_line_and_col_by_sign(GameBoard, e, EmptyLine, EmptyCol),
	is_legit_recursive_eat_move(GameBoard, CurrentPlayerSign, PlayerLine, PlayerCol, EmptyLine, EmptyCol, ResGameBoard).

%try to generate regular eat move
is_legit_eat_move(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard):-
	check_desire_eat_move_position(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol),
	get_element_with_sign(GameBoard, e, DstLine, DstCol),
	get_middle_element(SrcLine, SrcCol, DstLine, DstCol, MiddleLine, MiddleCol),
	abs(MiddleLine, AbsMiddleLine), abs(MiddleCol, AbsMiddleCol),
	insert_element_to_pos_in_board(GameBoard, SrcLine, SrcCol, e, TmpGameBoard1),
	insert_element_to_pos_in_board(TmpGameBoard1, AbsMiddleLine, AbsMiddleCol, e, TmpGameBoard2),
	insert_element_to_pos_in_board(TmpGameBoard2, DstLine, DstCol, CurrentPlayerSign, ResGameBoard).

%try to generate recursive eat move
is_legit_recursive_eat_move(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard):-
	is_legit_eat_move(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard)
	;
	(
		((CurrentPlayerSign=w; CurrentPlayerSign=kw; CurrentPlayerSign=kb),
		NextSrcLine is SrcLine + 2)
		;
		((CurrentPlayerSign=w; CurrentPlayerSign=kw; CurrentPlayerSign=kb),
		NextSrcLine is SrcLine - 2)
	),
	NextSrcCol1 is SrcCol + 2,
	NextSrcCol2 is SrcCol - 2,
	(
		(is_legit_eat_move(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, NextSrcLine, NextSrcCol1, ResGameBoard1),
		is_legit_recursive_eat_move(ResGameBoard1, CurrentPlayerSign, NextSrcLine, NextSrcCol1, DstLine, DstCol, ResGameBoard))
		;
		(is_legit_eat_move(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, NextSrcLine, NextSrcCol2, ResGameBoard1), 
		is_legit_recursive_eat_move(ResGameBoard1, CurrentPlayerSign, NextSrcLine, NextSrcCol2, DstLine, DstCol, ResGameBoard))
	).
	
	

%Given a game board, return all positions of a desired cell
get_element_with_sign(GameBoard, Sign, Line, Column):-
	(  atomic(Sign)
    -> (arg(Index, GameBoard, Sign), index_to_position(Index, Line, Column))
    ;  (position_to_index(Line, Column, Index), arg(Index, GameBoard, Sign))  
     ).
	 
get_line_and_col_by_sign( GameBoard, S, Line, Col) :-
          arg(Num, GameBoard, S),
		  get_game_board_size(BoardSize),
          Temp is Num / BoardSize,
          ceiling(Temp, Line),
          Col is Num - ((Line - 1) * BoardSize).
	

%The eating move is valid only if there is an counter-soldier in the direction of the movement (affects the positive lines), whereas the positives of the columns change as needed

check_desire_eat_move_position(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol):-
	is_valid_position(SrcLine, SrcCol, DstLine, DstCol),
	(
		(CurrentPlayerSign=kw; CurrentPlayerSign=kb), 
		two_steps_distance(DstLine, SrcLine), 
		two_steps_distance(DstCol, SrcCol),
		get_middle_element(SrcLine, SrcCol, DstLine, DstCol, MiddleLine, MiddleCol),
		get_oposite_player_sign(CurrentPlayerSign, Oposite),
		get_element_with_sign(GameBoard, Oposite, MiddleLine, MiddleCol)
	)
	;
	(
		CurrentPlayerSign=w, 
		DstLine is SrcLine + 2, two_steps_distance(DstCol, SrcCol),
		get_middle_element(SrcLine, SrcCol, DstLine, DstCol, MiddleLine, MiddleCol),
		get_oposite_player_sign(CurrentPlayerSign, Oposite),
		get_element_with_sign(GameBoard, Oposite, MiddleLine, MiddleCol)
	)
	;
	(
		CurrentPlayerSign=b, 
		DstLine is SrcLine - 2, two_steps_distance(DstCol, SrcCol),
		get_middle_element(SrcLine, SrcCol, DstLine, DstCol, MiddleLine, MiddleCol),
		get_oposite_player_sign(CurrentPlayerSign, Oposite),
		get_element_with_sign(GameBoard, Oposite, MiddleLine, MiddleCol)
	).

%The move is legitimate only if there is a counter-soldier in the direction of the movement (affects the positive lines), whereas the page charges change as necessary

check_desire_move_position(GameBoard, CurrentPlayerSign, SrcLine, SrcCol, DstLine, DstCol):-
	is_valid_position(SrcLine, SrcCol, DstLine, DstCol),
	(
		(CurrentPlayerSign=kw; CurrentPlayerSign=kb), 
		one_steps_distance(DstLine, SrcLine), 
		one_steps_distance(DstCol, SrcCol),
		get_element_with_sign(GameBoard, e, DstLine, DstCol)
	)
	;
	(
		CurrentPlayerSign=w, 
		DstLine is SrcLine + 1, 
		one_steps_distance(DstCol, SrcCol),
		get_element_with_sign(GameBoard, e, DstLine, DstCol)
	)
	;
	(
		CurrentPlayerSign=b, 
		DstLine is SrcLine - 1, 
		one_steps_distance(DstCol, SrcCol),
		get_element_with_sign(GameBoard, e, DstLine, DstCol)
	).


%Checking eating distance
two_steps_distance(Dst, Src):-	
	(Dst is Src - 2,!) ; (Dst is Src + 2,!).

%Checking move distance
one_steps_distance(Dst, Src):-
	(Dst is Src - 1,!) ; (Dst is Src + 1,!).
	
	
get_middle_element(SrcLine, SrcCol, DstLine, DstCol, MiddleLine, MiddleCol):-
	MiddleLine is (SrcLine + DstLine) / 2,
	MiddleCol is (SrcCol + DstCol) / 2.

insert_element_to_pos_in_board(GameBoard, 1, DstCol, b, ResGameBoard):-
	insert_element_to_pos_in_board(GameBoard, 1, DstCol, kb, ResGameBoard),!.
	
insert_element_to_pos_in_board(GameBoard, 8, DstCol, w, ResGameBoard):-
	get_game_board_size(BoardSize),
	insert_element_to_pos_in_board(GameBoard, BoardSize, DstCol, kw, ResGameBoard),!.

insert_element_to_pos_in_board(GameBoard, DstLine, DstCol, Element, ResGameBoard):-
	position_to_index(DstLine, DstCol, Pos),
	board_list_switch(GameBoard, GameBoardList),
	PosInList is Pos-1, %replace function list with index 0
	replace(GameBoardList, PosInList, Element, NewGameList),
	board_list_switch(ResGameBoard, NewGameList).
	
commit_move(GameBoard, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard):-
	get_soldier_or_king(GameBoard, SrcLine, SrcCol, Player),
	get_player_sign(PlayerSign, Player), !,
	get_legit_move(GameBoard, PlayerSign, ResGameBoard),
	(
		is_legit_recursive_eat_move(GameBoard, Player, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard)
		; 
		is_legit_movement(GameBoard, Player, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard)
	).
	
