(** Keyboard module. This module utilizes the [Sdlevent] and [Sdlscancode]
    bindings to detect input from the keyboard.

    Authors: Luis Hernández Rocha, Pedro Pontes García, Tawakalt Bisola Okunola. *)

open Sdl
open Sdlevent

(** Represents a keyboard state. *)
type t

(** Represents a key. See the {{!module: final.Key} key module} for more
    information. *)
type key =
  | Q
  | W
  | S
  | A
  | D
  | Space
  | Esc

(** Returns new keyboard state with all keys initialized to false. *)
val new_keyboard : t

(** Updates keyboard.
    - Parameter [event]: event to update keyboard with.
    - Parameter [keyboard]: keyboard. *)
val update_keyboard : Sdlevent.t -> t -> unit

(** Returns whether a key is pressed in a keyboard.
    - Parameter [key]: key to query.
    - Parameter [keyboard]: keyboard. *)
val query_key : key -> t -> bool
