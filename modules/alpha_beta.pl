:-  ensure_loaded([basic_game_relations]).
:-  ensure_loaded([useful_predicates]).
:-  ensure_loaded([board]).
:-  ensure_loaded([game_moves]).
:-  ensure_loaded([tui]).

%
% Alpha-Beta implementation
%

% alphabeta algorithm
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

%
% Alpha-Beta satellite relations
%

% Get a list of the valid moves that can be on the board
moves(Turn/Board, [X|Xs]) :-
       next_turn(Turn, NextTurn),
       findall(NextTurn/NewBoard, get_legit_move(Board, Turn, NewBoard), [X|Xs]).

	  
% The hueristic function
% The amount of the computers pawns minus the amount of the human pawns
% a king is worth two standard pawns
staticval( _/Board, Res) :-
           max_to_move(Comp/_),
           min_to_move(Human/_),
           %next_player(Comp, Human),
           count( Board, Comp, Res1),
           count( Board, Human, Res2),
           soldier_to_king(Comp, CompK),
           soldier_to_king(Human, HumanK),
           count(Board, CompK, Res1k),
           count(Board, HumanK, Res2k),
           king_bonus(Board, CompK, Bonus),
           Res is (Res1 + (Res1k * 1.4)) - (Res2 + (Res2k * 1.4)) + Bonus.

king_bonus(Board, Sign, Bonus) :-
            findall(L/C, findPawn(Board, Sign, L, C), List),!,
            king_bonusL( List, Bonus, 0).

king_bonusL( [], Bonus, Bonus).
king_bonusL( [L/C|Xs], Bonus, Agg) :-
             ((L > 2, L < 7, B1 is 0.4,!) ;
             B1 is 0),
             ((C > 2, C < 7, B2 is 0.2,!) ;
             B2 is 0),
             Agg1 is Agg + B1 + B2,
             king_bonusL(Xs, Bonus, Agg1).