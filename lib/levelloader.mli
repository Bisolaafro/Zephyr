type t

val new_level_loader : unit -> t
val init_level_loader : string -> Sdlrender.t -> t -> unit
val update_level_loader_state : Keyboard.t -> int -> Sdlrender.t -> t -> unit
val draw_level_loader : Sdlrender.t -> t -> unit
