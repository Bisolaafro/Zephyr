type t

val new_level_loader : unit -> t

(** Now has an extra parameter (last one) to take in [Mixer.Chunk.t] objects
    that can be played by the player. Still need to document this file!!! *)
val init_level_loader : string -> Sdlrender.t -> t -> Mixer.Chunk.t list -> unit

val update_level_loader_state : Keyboard.t -> int -> Sdlrender.t -> t -> unit
val draw_level_loader : Sdlrender.t -> t -> unit
val draw_animated_level_loader : Sdltype.renderer -> t -> int -> unit

(** Now has an extra parameter (last one) to take in [Mixer.Chunk.t] objects
    that can be played by the player. Still need to document this file!!! *)
val init_animated_level_loader :
  string -> Sdltype.renderer -> t -> Mixer.Chunk.t list -> unit
