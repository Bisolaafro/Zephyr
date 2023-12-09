(** Level module. Includes a type to represent a level, as well as complementary
    functions to create, initialize, update, and draw a level. *)

(** Represents the state of a level: either it should switch to the previous or
    next one, or it should stay in the current one. *)
type level_state =
  | Previous
  | This
  | Next

(** Represents a level. *)
type t = {
  mutable player : Player.t option;
  tilemap : Tilemap.t;
  mutable background : Sdltexture.t option;
  mutable prev_level : string option;
  mutable next_level : string option;
  mutable state : level_state;
  respawn_pos : Vector.t;
}

(** [new_level ()] returns a new level. *)
val new_level : unit -> t

(** [init_level fl p rndr l] initializes level [l] to load the JSON file [fl] on
    a renderer [rndr] with a player [p]. *)
val init_level : string -> Player.t -> Sdlrender.t -> t -> unit

(** [update_level_state k dt l] updates level [l] with keyboard state [k] and
    time [dt] elapsed since the last frame, to be drawn on renderer [rndr]. *)
val update_level_state : Keyboard.t -> int -> t -> unit

(** [draw_animated_level rndr l dt] draws a level [l] which contains animations
    to renderer [rndr], with [dt] as the time elapsed since the last frame. *)
val draw_level_animated : Sdlrender.t -> t -> int -> unit
