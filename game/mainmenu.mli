(** Mainmenu module. Includes a type to represent the game's main menu as well
    as functions to create one, initialize it, update it, draw it, dismiss it,
    check if it is dismissed, and check if it is finished. *)

open Tsdl.Sdl
open Final.Keyboard

(** Represents a main menu. *)
type t

(** [new_main_menu ()] returns a new main menu. *)
val new_main_menu : unit -> t

(** [init_main_menu r m] initializes main menu [m] to be drawn on renderer [r]. *)
val init_main_menu : renderer -> t -> unit

(** [update_main_menu_state k dt r m] updates main menu [m] with keyboard state
    [k], time [dt] elapsed since last frame, drawn on renderer [r]. *)
val update_main_menu_state : Final.Keyboard.t -> int -> renderer -> t -> unit

(** [draw_main_menu r m] draws main menu [m] to renderer [r]. *)
val draw_main_menu : renderer -> t -> unit

(** [dismiss m] sends the dismiss signal to main menu [m]. *)
val dismiss : t -> unit

(** [is_dismissed m] is true if main menu [m] has been dismissed. *)
val is_dismissed : t -> bool

(** [is_finished m] is true if main menu [m] is completely finished. *)
val is_finished : t -> bool
