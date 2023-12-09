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

(** Starting x position. *)
val x0 : float

(** Starting y position. *)
val y0 : float

(** Player spritesheet. *)
val player_spritesheet : Spritesheet.t

(** Hash table of animations that are used in the current game. *)
val animation_table : (string, Animations.t) Hashtbl.t

(** Run animation for our character. *)
val anim_1 : Animations.t

(** Run animation (backwards) for our character. *)
val anim_2 : Animations.t

(** Idle animation for our character *)
val anim_3 : Animations.t

(** Whether the main menu should be enabled. *)
val main_enabled : bool
