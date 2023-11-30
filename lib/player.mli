(** Player module. Includes functions to initialize, update state and draw a
    player. *)

(** Represents a player. *)
type t = {
  objx : Gameobject.GameObject.t;
  objy : Gameobject.GameObject.t;
  obj : Gameobject.GameObject.t;
  mutable jumped : bool;
}

(** Returns new player. *)
val new_player : unit -> t

(** Initializes player with given texture.
    - Parameter [texture]: initial texture for the player.
    - Parameter [player]: player. *)
val init_player : Sdltexture.t -> float * float -> float * float -> t -> unit

(** Updates player state.
    - Parameter [keyboard]: keyboard to read state from.
    - Parameter [dt]: time elapsed since last update.
    - Parameter [player]: player. *)
val update_player_state : Keyboard.t -> int -> t -> unit

val update_player_rects : t -> unit

(** Draws player to renderer.
    - Parameter [renderer]: renderer to draw on.
    - Parameter [player]: player. *)
val get_anim : t -> bool * string

val draw_player : Sdlrender.t -> t -> unit

(** draws an animated player by changing frames
    - Parameter [row] : current row of the sprite in the spritesheet
    - Parameter [col] : current column of the sprite in the spritesheet
    - Parameter [width] : width of the sprite
    - Parameter [height] : height of the sprite
    - Parameter [renderer] : renderer to draw on
    - Parameter [player] : player*)
val draw_animated_player :
  int -> int -> int -> int -> int -> int -> Sdltype.renderer -> t -> unit
