type t

val new_player : t
val init_player : Sdltexture.t -> t -> unit
val update_player_state : Keyboard.t -> int -> t -> unit
val draw_player : Sdlrender.t -> t -> unit
