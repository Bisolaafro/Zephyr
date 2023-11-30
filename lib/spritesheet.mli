open Textureloader

(** Creates a Spritesheet that can be used on a player/object for animation*)

(**Represents a Spritesheet*)
type t

(**Returns the image format corresponding to the given string
   - Parameter [str] - the str to be converted*)
val get_image_format : string -> image_format

(** Returns a new Spritesheet
    - Parameter [filename] : path of the image file
    - Parameter [rows] : number of rows to animate in the spritesheet
    - Parameter [cols] : number of columns in the spritesheet
    - Parameter [width] : width of a sprite
    - Parameter [height] : height of a sprite
    - Parameter [row_start] : starting row of the animation
    - Parameter [col_start] : starting column of the animation
    - Parameter [col_end] : ending column of the animation
    - Parameter [speed] : speed to animate at, increasing speed results in less
      frames per second*)
val new_spritesheet :
  string -> int -> int -> int -> int -> int -> int -> int -> int -> t

(**Returns the string format of the file type given
   - Parameter [file] - the file path given*)
val file_type : string -> string

(*Loads the image file as a texture - Paramter [renderer] : the renderer to draw
  on - Parameter [sheet] : the spritesheet*)
val load_image : Sdltype.renderer -> t -> Sdltexture.t

(** Gets the row and col of the current sprite in the sheet
    - Parameter [sheet] : the spritesheet
    - Parameter [dt] : time elapsed since initialization of the game
    - Parameter [anim] : whether or not to change frames*)
val update_sprite_index : t -> int -> bool -> int * int

(** takes in the animation specified and updates the spritesheet to animate with
    the animation's rows, cols, row_start, col_start, col_end, and speed
    - Parameter [t] : the spritesheet
    - Parameter [animation] : the current animation
    - Parameter [check] : whether to update the animation*)
val update_animations : t -> Animations.t -> bool -> unit
