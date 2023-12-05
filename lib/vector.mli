(** Simple vector module that provides functionalty for mutable, two-dimensional
    vector operations. *)

(** Represents a vector. *)
type t = {
  mutable x : float;
  mutable y : float;
}

(** Returns the zero vector. *)
val zero : unit -> t

(** [add v1 v2] is the point-wise addition of vectors [v1] and [v2]. This
    function does not modify either of the original vectors. *)
val add : t -> t -> t

(** [scale n v] scales each component of [v] by [n]. *)
val scale : float -> t -> unit

(** [normalize v] modifies [v] so that it points in the same direction but with
    unit length. That is, if [v] has components [v1] and [v2], then
    [normalize v] is the vector with components [[v1/sqrt(v1^2 + v2^2)]] and
    [[v2/sqrt(v1^2 + v2^2)]]. Requires: [v] cannot be the zero vector. *)
val normalize : t -> unit

(** [normalize v] is the square root of the sum of the squared components of
    [v]. *)
val length : t -> float
