(** Mainmenu module. Includes a type to represent the game's main menu as well
    as functions to create one, initialize it, update it, draw it, dismiss it,
    check if it is dismissed, and check if it is finished. *)

(** Represents a main menu. *)
type t

(** [new_main_menu ()] returns a new main menu. *)
val new_main_menu : unit -> t

(** [init_main_menu rndr m] initializes main menu [m] to be drawn on renderer
    [rndr]. *)
val init_main_menu : Sdlrender.t -> t -> unit

(** [update_main_menu_state k dt rndr m] updates main menu [m] with keyboard
    state [k], time [dt] elapsed since last frame, drawn on renderer [rndr]. *)
val update_main_menu_state : Keyboard.t -> int -> Sdlrender.t -> t -> unit

(** [draw_main_menu rndr m] draws main menu [m] to renderer [rndr]. *)
val draw_main_menu : Sdlrender.t -> t -> unit

(** [dismiss m] sends the dismiss signal to main menu [m]. *)
val dismiss : t -> unit

(** [is_dismissed m] is true if main menu [m] has been dismissed. *)
val is_dismissed : t -> bool

(** [is_finished m] is true if main menu [m] is completely finished. *)
val is_finished : t -> bool
