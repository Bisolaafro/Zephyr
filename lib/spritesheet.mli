open TextureLoader

(** Creates a Spritesheet that can be used on a player/object for animation*)

(**Represents a Spritesheet*)
type t

(**Returns the image format corresponding to the given string
   - Parameter [str] - the str to be converted*)
val get_image_format : string -> image_format

(** Returns a new Spritesheet
    - Parameter [filename] : path of the image file
    - Parameter [rows] : rows in the spritesheet
    - Parameter [cols] : columns in the spritesheet
    - Parameter [width] : width of a sprite
    - Parameter [height] : height of a sprite*)
val new_spritesheet : string -> int -> int -> int -> int -> t

(*Loads the image file as a texture - Paramter [renderer] : the renderer to draw
  on - Parameter [sheet] : the spritesheet*)
val load_image : Sdltype.renderer -> t -> Sdltexture.t

(** Gets the row and col of the current sprite in the sheet
    - Parameter [sheet] : the spritesheet
    - Parameter [dt] : time elapsed since initialization of the game*)
val update_sprite_index : t -> int -> int * int

(** Updates the current sprite index
    - Parameter [sheet] : the spritesheet
    - Parameter [dt] : time elapsed since initialization of the game*)
val update_index_in_sheet : t -> int -> unit
