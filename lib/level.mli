type level_state =
  | Previous
  | This
  | Next

type t = {
  mutable player : Player.t option;
  tilemap : Tilemap.t;
  mutable background : Sdltexture.t option;
  mutable prev_level : string option;
  mutable next_level : string option;
  mutable state : level_state;
}

val new_level : unit -> t
val init_level : string -> Player.t -> Sdlrender.t -> t -> unit
val update_level_state : Keyboard.t -> int -> t -> unit
val draw_level : Sdlrender.t -> t -> unit
