get_oposite_player_sign(w, b).
get_oposite_player_sign(w, kb).
get_oposite_player_sign(kw, b).
get_oposite_player_sign(kw, kb).
get_oposite_player_sign(b, w).
get_oposite_player_sign(b, kw).
get_oposite_player_sign(kb, w).
get_oposite_player_sign(kb, kw).

get_player_sign(b, b).
get_player_sign(b, kb).
get_player_sign(w, w).
get_player_sign(w, kw).

next_turn(b, w).
next_turn(w, b).

soldier_to_king(b, kb).
soldier_to_king(w, kw).

player_to_sign(b, 'O').
player_to_sign(kb, 'OO').
player_to_sign(w, 'X').
player_to_sign(kw, 'XX').
player_to_sign(e, ' ').
player_to_sign(x, '##').
