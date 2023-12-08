(** Spritesheet module. Provides a type and functions to manage and draw
    animated textures from spritesheets. *)

open Textureloader

(** Represents a spritesheet. *)
type t

(** [get_image_format ext] returns the image format corresponding to the file
    extension [ext]. *)
val get_image_format : string -> image_format

(** [new_spritesheet fl r c w h rs cs ce sp] returns a new spritesheet from the
    file [fl], with rows [r], columns [c], sprite width [w], height [h], whose
    first sprite is the one at row [rs], column [cs], and whose last sprite is
    the one at column [cs], with sprites changing every [sp] milliseconds. *)
val new_spritesheet :
  string -> int -> int -> int -> int -> int -> int -> int -> int -> t

(** [file_type fl] returns the file extension of the file [fl]. *)
val file_type : string -> string

(*Loads the image file as a texture - Paramter [renderer] : the renderer to draw
  on - Parameter [sheet] : the spritesheet*)
val load_image : Sdltype.renderer -> t -> Sdltexture.t

(** [update_sprite_index sheet dt check] updates the sprite of the spritesheet
    [sheet] considering the time [dt] elapsed since the last frame if [check] is
    true, and returns a tuple indicating the row and column of the current
    sprite. *)
val update_sprite_index : t -> int -> bool -> int * int

(** [update_animations sheet anim check] updates the spritesheet [sheet] with
    the properties of animation [anim] if [check] is true. *)
val update_animations : t -> Animations.t -> bool -> unit
