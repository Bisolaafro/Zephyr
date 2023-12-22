(** Player module. Includes functions to initialize, update state and draw a
    player. *)

open Tsdl.Sdl
open Mixer

(** Represents a player. *)
type t = {
  objx : Gameobject.t;
  objy : Gameobject.t;
  obj : Gameobject.t;
  mutable sched_jump : bool;
  fx : Container.t;
  sounds : (string, Chunk.t) Hashtbl.t;
}

(** [new_player ()] returns a new player. *)
val new_player : unit -> t

(** [init_player tx p fx] initializes a player [p] with texture [tx] and sound
    effects [fx]. *)
val init_player :
  texture -> float * float -> float * float -> t -> Mixer.Chunk.t list -> unit

(** [update_player_state k dt rc p] updates the state of player [p] given the
    time [dt] elapsed since the last frame and the keyboard state [k] and
    respawn coordinates [rc]. *)
val update_player_state : Keyboard.t -> int -> Vector.t -> t -> unit

(** [update_player_rects p] is a high-performing function that updates the
    positions of the rectangles representing the player's collision logic
    without updating the player's position or velocity. *)
val update_player_rects : t -> unit

(** [get_anim p] returns a tuple representing whether player [p] is animated and
    if so, the name of its animation. If [p] is not animated, the name of its
    animation is an empty string. *)
val get_anim : t -> bool * string

(** [draw_animated_player r c w h r p] draws an animated player [p] to renderer
    [r] with the sprite at [r], [c] of width [w] and height [h]. *)
val draw_animated_player :
  int -> int -> int -> int -> int -> int -> renderer -> t -> unit
