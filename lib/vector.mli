(** Simple vector module.
    @author Pedro Pontes García *)

(** Represents a vector. *)
type t = {
  mutable x : float;
  mutable y : float;
}

(** Returns the zero vector. *)
val zero : t
