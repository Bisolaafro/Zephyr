(** Keyboard module. This module utilizes the [Sdlevent] and [Sdlscancode]
    bindings to detect input from the keyboard. *)

open Tsdl.Sdl

(** Represents the status of a key in a keyboard. *)
type status =
  | Pressed
  | Down
  | Released
  | Up

(** Represents a keyboard state. *)
type t

(** Returns a new keyboard state. *)
val new_keyboard : unit -> t

(** [update_keyboard k] updates keyboard [k]. *)
val update_keyboard : t -> unit

(** [query_key key k] returns whether a key [key] is pressed in a keyboard [k]. *)
val query_key : scancode -> t -> status
