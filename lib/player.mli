(** Player module. Includes functions to initialize, update state and draw a
    player. *)

(** Represents a player. *)
type t = {
  obj : Gameobject.GameObject.t;
  mutable time_on_ground : int;
}

(** Returns new player. *)
val new_player : unit -> t

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
