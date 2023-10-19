(** Simple vector module. *)

(** Represents a vector. *)
type t = {
  mutable x : float;
  mutable y : float;
}

(** Returns the zero vector. *)
val zero : t
