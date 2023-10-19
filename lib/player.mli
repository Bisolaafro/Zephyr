(** Player module. Includes functions to initialize, update state and draw a
    player. *)

(** Represents a player. *)
type t = {
  pos : Vector.t;
  vel : Vector.t;
  src_rect : Sdlrect.t option;
  mutable texture : Sdltexture.t option;
  mutable rect : Sdlrect.t option;
  mutable on_ground : bool;
  mutable time_on_ground : int;
}

(** Returns new player. *)
val new_player : t

(** Initializes player with given texture.
    - Parameter [texture]: initial texture for the player.
    - Parameter [player]: player. *)
val init_player : Sdltexture.t -> t -> unit

(** Updates player state.
    - Parameter [keyboard]: keyboard to read state from.
    - Parameter [dt]: time elapsed since last update.
    - Parameter [player]: player. *)
val update_player_state : Keyboard.t -> int -> t -> unit

(** Draws player to renderer.
    - Parameter [renderer]: renderer to draw on.
    - Parameter [player]: player. *)
val draw_player : Sdlrender.t -> t -> unit
