(** Player module. Includes functions to initialize, update state and draw a
    player. *)
type t

(** Returns new player *)
val new_player : t

(** Initializes player with given texture *)
val init_player : Sdltexture.t -> t -> unit

(** Updates player state from keyboard state and time difference *)
val update_player_state : Keyboard.t -> int -> t -> unit

(** Draws player to renderer *)
val draw_player : Sdlrender.t -> t -> unit
