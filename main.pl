% Programmer: Aharon Shenvald - 200532521
% File Name: main.pl
% Date: 23/11/2017
% Description: Artificial Intellegence Checkers Game
% Synopsys: To play the game, enter the following command:
%			start_game.

:-  ensure_loaded([modules/basic_game_relations]).
:-  ensure_loaded([modules/useful_predicates]).
:-  ensure_loaded([modules/board]).
:-  ensure_loaded([modules/game_moves]).
:-  ensure_loaded([modules/tui]).
:-  ensure_loaded([modules/alpha_beta]).

%The Predicate checks the desired settings and starts the game
start_game:-
	get_who_play_first(UserChoice),
	generate_game_board(w, b, e, x, GameBoard),
	(  UserChoice=x
    -> human_start(GameBoard)
    ;  computer_start(GameBoard)  
     ).

%If the opposing player can not make a move, the opponent loses.
goal(GameBoard, WinPlayer) :-
	next_turn(WinPlayer, LoosPlayer),
	findall(NewBoard, (get_player_sign(LoosPlayer,LoosPlayerSign),get_legit_move(GameBoard, LoosPlayerSign, NewBoard)), []),!.

computer_start(GameBoard):-
	assert(min_to_move(b/_)),assert(max_to_move(w/_)),
    play(computer, w, GameBoard).

human_start(GameBoard):-
	assert(min_to_move(w/_)),assert(max_to_move(b/_)),
    play(human, w, GameBoard).

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
		check_user_move(PlayerSign, SrcLine, SrcCol, DstLine, DstCol, GameBoard),!
	)
	;
	(
		%The player has entered an invalid move
		write('Illegal move.'),nl,
		play(human, PlayerSign, GameBoard)
	).

% Get the computer's next move using alphabeta algorithm(The level of difficulty depending on the depth of the search).
play(computer, ComputerSign, GameBoard) :-
	get_difficulty(Difficult),
	alphabeta(ComputerSign/GameBoard, -100, 100, NextPlayer/NewGameBoard, _, Difficult),
	play(human, NextPlayer, NewGameBoard).

check_user_move(PlayerSign, SrcLine, SrcCol, DstLine, DstCol, GameBoard) :-
	commit_move(GameBoard, SrcLine, SrcCol, DstLine, DstCol, ResGameBoard),
	next_turn(PlayerSign, Next),
	play(computer, Next, ResGameBoard).
