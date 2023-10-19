(** Obstacle module. Includes a type to represent an obstacle and functions to
    initialize them, draw them and check collisions. *)

(** Represents an obstacle. *)
type t = {
  bottom_left : Vector.t;
  top_right : Vector.t;
  center : Vector.t;
  mutable width : float;
  mutable height : float;
  mutable texture : Sdltexture.t option;
  src_rect : Sdlrect.t option;
  mutable rect : Sdlrect.t option;
}

(** Returns new obstacle. *)
val new_obstacle : t

(** Initializes obstacle with given texture.
    - Parameter [texture] initial texture for the obstacle.
    - Parameter [bottom_left] initial bottom-left corner.
    - Parameter [top_right] initial top-right corner.
    - Parameter [obstacle] obstacle. *)
val init_obstacle : Sdltexture.t -> int * int -> int * int -> t -> unit

(** Updates player state.
    - Parameter [keyboard] keyboard to read state from.
    - Parameter [dt] time elapsed since last update.
    - Parameter [obstacle] obstacle. *)
val update_obstacle_state : Keyboard.t -> int -> t -> unit

(** Draws obstacle to renderer.
    - Parameter [renderer] renderer to draw on.
    - Parameter [obstacle] obstacle. *)
val draw_obstacle : Sdlrender.t -> t -> unit
