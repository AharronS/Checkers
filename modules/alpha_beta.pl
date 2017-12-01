% Programmer: Aharon Shenvald - 200532521
% File Name: alpha_beta.pl
% Date: 23/11/2017
% Description: Artificial Intellegence Checkers Game

:-  ensure_loaded([basic_game_relations]).
:-  ensure_loaded([useful_predicates]).
:-  ensure_loaded([board]).
:-  ensure_loaded([game_moves]).
:-  ensure_loaded([tui]).

init_level_of_difficulty(Difficulty):-
	Difficulty >= 2,
	Difficulty =< 5,
	retractall(difficult(_)),
	assert(difficult(Difficulty)),!.
get_difficulty(Difficulty):-
	difficult(Difficulty).

% alphabeta algorithm(from book - http://media.pearsoncmg.com/intl/ema/ema_uk_he_bratko_prolog_3/prolog/ch22/fig22_5.txt)

alphabeta( Pos, Alpha, Beta, GoodPos, Val, Depth) :-
           Depth > 0, moves( Pos, PosList), !,
           boundedbest( PosList, Alpha, Beta, GoodPos, Val, Depth);
           staticval( Pos, Val).        % Static value of Pos

boundedbest( [Pos|PosList], Alpha, Beta, GoodPos, GoodVal, Depth) :-
             Depth1 is Depth - 1,
             alphabeta( Pos, Alpha, Beta, _, Val, Depth1),
             goodenough( PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Depth).

goodenough( [], _, _, Pos, Val, Pos, Val, _) :- !.     % No other candidate

goodenough( _, Alpha, Beta, Pos, Val, Pos, Val, _) :-
            min_to_move( Pos), Val > Beta, !;       % Maximizer attained upper bound
            max_to_move( Pos), Val < Alpha, !.      % Minimizer attained lower bound

goodenough( PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Depth) :-
            newbounds( Alpha, Beta, Pos, Val, NewAlpha, NewBeta),        % Refine bounds
            boundedbest( PosList, NewAlpha, NewBeta, Pos1, Val1, Depth),
            betterof( Pos, Val, Pos1, Val1, GoodPos, GoodVal).

newbounds( Alpha, Beta, Pos, Val, Val, Beta) :-
           min_to_move( Pos), Val > Alpha, !.        % Maximizer increased lower bound

newbounds( Alpha, Beta, Pos, Val, Alpha, Val) :-
           max_to_move( Pos), Val < Beta, !.         % Minimizer decreased upper bound

newbounds( Alpha, Beta, _, _, Alpha, Beta).          % Otherwise bounds unchanged

betterof( Pos, Val, _, Val1, Pos, Val) :-         % Pos better then Pos1
          min_to_move( Pos), Val > Val1, !;
          max_to_move( Pos), Val < Val1, !.

betterof( _, _, Pos1, Val1, Pos1, Val1).             % Otherwise Pos1 better


% Get a list of the valid moves that can be on the board
moves(Turn/Board, [X|Xs]) :-
       next_turn(Turn, NextTurn),
       findall(NextTurn/NewBoard, get_legit_move(Board, Turn, NewBoard), [X|Xs]).

	  
% hueristic function- The amount of the computers soldiers - the amount of the human pawns
% a king is worth two standard pawns
staticval( _/Board, Res) :-
           max_to_move(Comp/_),
           min_to_move(Human/_),
           count_sign_on_board( Board, Comp, Res1),
           count_sign_on_board( Board, Human, Res2),
           soldier_to_king(Comp, CompK),
           soldier_to_king(Human, HumanK),
           count_sign_on_board(Board, CompK, Res1k),
           count_sign_on_board(Board, HumanK, Res2k),
           compensation_function(Board, CompK, Bonus),
           Res is (Res1 + (Res1k * 1.4)) - (Res2 + (Res2k * 1.4)) + Bonus.

compensation_function(Board, Sign, Bonus) :-
            findall(L/C, get_line_and_col_by_sign(Board, Sign, L, C), List),!,
            compensation_function_list( List, Bonus, 0).

compensation_function_list( [], Bonus, Bonus).
compensation_function_list( [L/C|Xs], Bonus, Agg) :-
             ((L > 2, L < 7, B1 is 0.3,!) ;
             B1 is 0),
             ((C > 2, C < 7, B2 is 0.3,!) ;
             B2 is 0),
             Agg1 is Agg + B1 + B2,
             compensation_function_list(Xs, Bonus, Agg1).