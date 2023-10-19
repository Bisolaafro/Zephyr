(** Keyboard module. This module utilizes the Sdlevent and Sdlscancode bindings
    to detect input from the keyboard. *)

open Sdl
open Sdlevent
open Key

(** Represents my keyboard state *)
type t

(** Represents a key. See the {{!module: final.Key} key module} for more
    information. *)
type key = Key.key

(** Returns new keyboard state with all keys initialized to false *)
val new_keyboard : t

(** Updates keyboard with keyboard event *)
val update_keyboard : Sdlevent.t -> t -> unit

(** Returns whether a key is pressed in a keyboard *)
val query_key : key -> t -> bool
