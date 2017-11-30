get_oposite_player_sign(w, b).
get_oposite_player_sign(w, bb).
get_oposite_player_sign(ww, b).
get_oposite_player_sign(ww, bb).
get_oposite_player_sign(b, w).
get_oposite_player_sign(b, ww).
get_oposite_player_sign(bb, w).
get_oposite_player_sign(bb, ww).

get_player_sign(b, b).
get_player_sign(b, kb).
get_player_sign(w, w).
get_player_sign(w, kw).

next_turn(b, w).
next_turn(o, x).

soldier_to_king(b, kb).
soldier_to_king(w, kw).

player_to_sign(b, 'O').
player_to_sign(kb, 'OO').
player_to_sign(w, 'X').
player_to_sign(kw, 'XX').
player_to_sign(e, ' ').
player_to_sign(x, '##').
