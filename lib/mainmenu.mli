type t

val new_main_menu : unit -> t
val init_main_menu : Sdlrender.t -> t -> unit
val update_main_menu_state : Keyboard.t -> int -> Sdlrender.t -> t -> unit
val draw_main_menu : Sdlrender.t -> t -> unit
