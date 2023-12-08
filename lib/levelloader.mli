(** Levelloader module. Provides a type to represent a level loader, as well as
    functions to create, initialize, update, and draw one. A level loader loads
    levels onto the screen in sequence as the player completes them. *)

(** Represents a level loader. *)
type t

(** [new_level_loader l] returns a new level loader. *)
val new_level_loader : unit -> t

(** [init_level_loader fl rndr l fx] initializes a level loader [l] with initial
    level file [fl] to be drawn on renderer [rndr] and with sound effects list
    [fx]. *)
val init_level_loader : string -> Sdlrender.t -> t -> Mixer.Chunk.t list -> unit

(** [init_level_loader fl rndr l fx] initializes a level loader with animations
    [l] with initial level file [fl] to be drawn on renderer [rndr] and with
    sound effects list [fx]. *)
val init_animated_level_loader :
  string -> Sdlrender.t -> t -> Mixer.Chunk.t list -> unit

(** [update_level_loader_state k dt rndr l] updates level loader [l] with
    keyboard state [k] and time [dt] elapsed since the last frame, to be drawn
    on renderer [rndr]. *)
val update_level_loader_state : Keyboard.t -> int -> Sdlrender.t -> t -> unit

(** [draw_level_loader rndr l] draws level loader [l] to renderer [rndr]. *)
val draw_level_loader : Sdlrender.t -> t -> unit

(** [draw_animated_level_loader rndr l dt] draws a level loader [l] which
    contains animations to renderer [rndr], with [dt] as the time elapsed since
    the last frame. *)
val draw_animated_level_loader : Sdltype.renderer -> t -> int -> unit
