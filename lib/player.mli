(** Player module. Includes functions to initialize, update state and draw a
    player. *)

open Mixer

(** Represents a player. *)
type t = {
  objx : Gameobject.GameObject.t;
  objy : Gameobject.GameObject.t;
  obj : Gameobject.GameObject.t;
  mutable jumped : bool;
  fx : Container.t;
  sounds : (string, Chunk.t) Hashtbl.t;
}

(** [new_player ()] returns a new player. *)
val new_player : unit -> t

(** [init_player tx p fx] initializes a player [p] with texture [tx] and sound
    effects [fx]. *)
val init_player :
  Sdltexture.t ->
  float * float ->
  float * float ->
  t ->
  Mixer.Chunk.t list ->
  unit

(** [update_player_state k dt p] updates the state of player [p] given the time
    [dt] elapsed since the last frame and the keyboard state [k]. *)
val update_player_state : Keyboard.t -> int -> t -> unit

(** [update_player_rects p] is a high-performing function that updates the
    positions of the rectangles representing the player's collision logic
    without updating the player's position or velocity. *)
val update_player_rects : t -> unit

(** [get_anim p] returns a tuple representing whether player [p] is animated and
    if so, the name of its animation. If [p] is not animated, the name of its
    animation is an empty string. *)
val get_anim : t -> bool * string

(** [draw_player rndr p] draws a player [p] to renderer [rndr]. *)
val draw_player : Sdlrender.t -> t -> unit

(** [draw_animated_player r c w h rndr p] draws an animated player [p] to
    renderer [rndr] with the sprite at [r], [c] of width [w] and height [h]. *)
val draw_animated_player :
  int -> int -> int -> int -> int -> int -> Sdltype.renderer -> t -> unit
