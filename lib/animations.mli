type t

(** takes in an animation and returns the starting row of that animation*)
val get_row_start : t -> int

(** takes in an animation and returns the starting column of that animation*)
val get_col_start : t -> int

(** takes in an animation and returns the ending column of that animation*)
val get_col_end : t -> int

(** takes in an animation and returns the number of rows to be animated*)
val get_rows : t -> int

(** takes in an animation and returns the number of columns. The number of
    columns in an animation should be the number of columns in the spritesheet
    to be animated.*)
val get_cols : t -> int

(** takes in an animation and returns the speed of that animation. increasing
    speed results in less frames per second*)
val get_speed : t -> int

(** takes in an animation and returns its name*)
val get_name : t -> string

val animation_table : (string, t) Hashtbl.t
val animation : string -> int -> int -> int -> int -> int -> int -> t
val anim_1 : t
val anim_2 : t
