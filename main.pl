:-  ensure_loaded([modules/basic_game_relations]).
:-  ensure_loaded([modules/useful_predicates]).
:-  ensure_loaded([modules/board]).
:-  ensure_loaded([modules/game_moves]).


goal(GameBoard, WinPlayer) :-
	next_turn(WinPlayer, LoosPlayer),
	findall(NewBoard, (get_player_sign(LoosPlayer,LoosPlayerSign),get_legit_move(GameBoard, LoosPlayerSign, NewBoard)), []),!.

%TODO: add init GameBoard.
computer_start(GameBoard):-
	assert(min_to_move(o/_)),assert(max_to_move(x/_)),
    play(computer, x, GameBoard).

%TODO: add init GameBoard.
human_start(GameBoard):-
	assert(min_to_move(x/_)),assert(max_to_move(o/_)),
    play(human, x, GameBoard).

%check if someone won
play(_, _, GameBoard) :-
           goal(GameBoard, WinPlayer),
           print_game_board(GameBoard),
           clear, atom_concat('We have Winner! Congrats ', WinPlayer, Res),
           write(Res),nl,!.

% Get the user's next move.
play(human, PlayerSign, GameBoard) :-
	(
		print_game_board(GameBoard),
		get_user_next_move(SrcLine, SrcCol, DstLine, DstCol),
		process(PlayerSign, SrcLine, SrcCol, DstLine, DstCol, GameBoard),!
	)
	;
	(
		write('Illegal move.'),nl,
		play(human, PlayerSign, GameBoard)
	).

% Get the computer's next move using alphabeta algorithm.
play(computer, ComputerSign, GameBoard) :-
     alphabeta(ComputerSign/GameBoard, -100, 100, NextPlayer/NewGameBoard, _, 2),
     play(human, NextPlayer, NewGameBoard).

%quit if the user enter "stop"
process(_, stop, _, _, _, _) :- clear.
process(_, _, stop, _, _, _) :- clear.
process(_, _, _, stop, _, _) :- clear.
process(_, _, _, _, stop, _) :- clear.

% check for a valid move,
% process the user's move,
% and get the next move.
process(PlayerSign, SrcLine, SrcCol, DstLine, DstCol, GameBoard) :-
              commit_move(GameBoard, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard),
              next_turn(PlayerSign, Next),
              play(computer, Next, NewBoard).
			  
clear :-
      retractall(max_to_move(_)),
      retractall(min_to_move(_)),!.