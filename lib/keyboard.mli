(** Keyboard module. This module utilizes the [Sdlevent] and [Sdlscancode]
    bindings to detect input from the keyboard. *)

open Sdl
open Sdlevent
open Key

(** Represents a keyboard state. *)
type t

(** Represents a key. See the {{!module: final.Key} key module} for more
    information. *)
type key = Key.key

(** Returns new keyboard state with all keys initialized to false. *)
val new_keyboard : t

(** [update_keyboard e k] updates keyboard [k] with SDL event [e]. *)
val update_keyboard : Sdlevent.t -> t -> unit

(** [query_key key k] returns whether a key [key] is pressed in a keyboard [k]. *)
val query_key : key -> t -> bool
