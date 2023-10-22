(** Game object module. Includes a type to represent a game object and functions
    to initialize them, update their state, and draw them. *)

(** Represents a game object. *)
type t = {
  pos : Vector.t;
  vel : Vector.t;
  mutable width : float;
  mutable height : float;
  mutable texture : Sdltexture.t option;
  mutable src_rect : Sdlrect.t option;
  mutable rect : Sdlrect.t option;
  mutable affected_by_gravity : bool;
  mutable on_ground : bool;
  mutable facing_back : bool;
}

(** Returns new game object. *)
val new_object : unit -> t

(** Initializes obstacle with given texture.
    - Parameter [texture]: initial texture for the object.
    - Parameter [bottom_left]: initial bottom-left corner.
    - Parameter [top_right]: initial top-right corner.
    - Parameter [gravity]: whether the game object is affected by gravity.
    - Parameter [obj] game object. *)
val init_object :
  Sdltexture.t -> float * float -> float * float -> bool -> t -> unit

(** Updates object state.
    - Parameter [dt]: time elapsed since last update.
    - Parameter [obj]: game object. *)
val update_object_state : int -> t -> unit

(** Draws game object to renderer.
    - Parameter [renderer]: renderer to draw on.
    - Parameter [obj]: game object. *)
val draw_object : Sdlrender.t -> t -> unit

(**Changes the src rectangle of the gameobject*)
val get_object : int -> int -> int -> int -> 'a -> t -> unit
