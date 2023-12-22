(** Game Object module. Includes a type to represent a game object and functions
    to initialize them, update their state, and draw them. *)

open Tsdl.Sdl

(** Represents a game object. *)
type t = {
  pos : Vector.t;
  vel : Vector.t;
  mutable width : float;
  mutable height : float;
  mutable texture : texture option;
  mutable src_rect : rect option;
  mutable rect : rect option;
  mutable affected_by_gravity : bool;
  mutable on_ground : bool;
  mutable facing_back : bool;
  mutable animated : bool;
  mutable anim_name : string;
}

val new_object : unit -> t

(** Initializes obstacle with given texture.
    - Parameter [texture]: initial texture for the object.
    - Parameter [bottom_left]: initial bottom-left corner.
    - Parameter [top_right]: initial top-right corner.
    - Parameter [gravity]: whether the game object is affected by gravity.
    - Parameter [obj] game object. *)
val init_object : texture -> float * float -> float * float -> bool -> t -> unit

(** Updates object state.
    - Parameter [dt]: time elapsed since last update.
    - Parameter [obj]: game object. *)
val update_object_state : int -> t -> unit

(** Draws game object to renderer.
    - Parameter [renderer]: renderer to draw on.
    - Parameter [obj]: game object. *)
val draw_object : ?src:rect -> ?flip:flip -> renderer -> t -> unit

(** Changes the src rectangle of the gameobject.
    - Parameter [row] : current row of the sprite in the spritesheet
    - Parameter [col] : current column of the sprite in the spritesheet
    - Parameter [width] : width of the sprite
    - Parameter [height] : height of the sprite
    - Parameter [renderer] : renderer to draw on
    - Parameter [obj] : game object*)
val get_object : int -> int -> int -> int -> int -> int -> renderer -> t -> unit

(** draws an animated object
    - Parameter [row] : current row of the sprite in the spritesheet
    - Parameter [col] : current column of the sprite in the spritesheet
    - Parameter [width] : width of the sprite
    - Parameter [height] : height of the sprite
    - Parameter [renderer] : renderer to draw on
    - Parameter [obj] : game object*)
val draw_animated_object :
  int -> int -> int -> int -> int -> int -> renderer -> t -> unit
