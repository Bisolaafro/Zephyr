(** Animations module. Provides a type and associated functions to represent
    animations for Gameobjects. *)

(** Represents an animation. *)
type t

(** Takes in an animation and returns the starting row of that animation. *)
val get_row_start : t -> int

(** Takes in an animation and returns the starting column of that animation. *)
val get_col_start : t -> int

(** Takes in an animation and returns the ending column of that animation. *)
val get_col_end : t -> int

(** Takes in an animation and returns the number of rows to be animated. *)
val get_rows : t -> int

(** Takes in an animation and returns the number of columns. The number of
    columns in an animation should be the number of columns in the spritesheet
    to be animated. *)
val get_cols : t -> int

(** Takes in an animation and returns the speed of that animation. increasing
    speed results in less frames per second. *)
val get_speed : t -> int

(** Takes in an animation and returns its name. *)
val get_name : t -> string

(** [animation name rs cs cf r c s] creates an animation with name [name],
    initial sprite [rs], [cs], final column [cf], number of rows [r], number of
    columns [c], and speed [s]. *)
val animation : string -> int -> int -> int -> int -> int -> int -> t
