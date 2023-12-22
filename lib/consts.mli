(** Consts module. Provides some constants that are used game-wide. *)

(** Width of the window. *)
val width : int

(** Height of the window. *)
val height : int

(** Acceleration due to gravity. *)
val accel : float

(** Player width *)
val player_width : float

(** Player height *)
val player_height : float

(** Player spritesheet. *)
val player_spritesheet : Spritesheet.t

(** Horizontal walk velocity. *)
val vx : float

(** Initial vertical jump velocity. *)
val dvy : float

(** Hash table of animations that are used in the current game. *)
val animation_table : (string, Animations.t) Hashtbl.t

(** Run animation for our character. *)
val anim_1 : Animations.t

(** Run animation (backwards) for our character. *)
val anim_2 : Animations.t

(** Idle animation for our character *)
val anim_3 : Animations.t
