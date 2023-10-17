(** Keyboard module. This module utilizes the Sdlkey bindings to detect input
    from the keyboard. *)

open Sdl
open Sdlevent

(** Represents a keyboard state *)
type t

(** Represents a key *)
type key =
  | Q
  | W
  | S
  | A
  | D
  | Space
  | Esc

(** Returns new keyboard state with all keys initialized to false *)
val new_keyboard : t

(** Updates keyboard with keyboard event *)
val update_keyboard : Sdlevent.t -> t -> unit

(** Returns whether a key is pressed in a keyboard *)
val query_key : key -> t -> bool
