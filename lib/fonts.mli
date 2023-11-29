(** Represents a font object*)
type t

(** Shuts down the SDL_ttf library and frees any resources allocated by it.*)
val quit_font : unit -> unit

(** creates a new text with font
    - Parameter [filename] : the file path of the font to be used
    - Parameter [text] - the text to be rendered to the screen
    - Parameter [font_size] : the size of the text
    - Parameter [color] : the color of the text. *)
val new_font_object : string -> string -> int -> Sdlttf.color -> t

(**creates a surface to render the font/text on *)
val load_font : t -> unit

(** renders the text using the font to the screen *)
val static_render : Sdltype.renderer -> t -> unit -> unit

(** updates the position of the text on the screen
    - Parameter [x] - the starting x position of the text
    - Parameter [y] - the starting y position of the text
    - Parameter [t] - the font/text to be update *)
val update_position : int -> int -> t -> unit

(** returns the speed of the moving text in tuple format, with the first element
    being the velocity in the x direction and the second element being the
    velocity in the y direction.*)
val get_speed : t -> int option * int option

(** returns the color of the text*)
val get_color : t -> Sdlttf.color

(** returns the text being used*)
val get_text : t -> string

(** updates the speed of the moving text
    - Parameter [vel_x] - the x velocity of the moving text
    - Parameter [vel_y] - the y velocity of the moving text
    - Parameter [t] : the font/text to be updated *)
val font_speed : int option -> int option -> t -> unit

(** renders the moving text.
    - Parameter [renderer] - the renderer to draw on
    - Parameter [t] - the font/text to be rendered
    - Parameter [x_max] - maximum x position of the font/text
    - Parameter [y_max] - maximum y position of the font/text
    - Parameter [dt] - the timer for changing the text position *)
val mobile_render : Sdltype.renderer -> t -> int -> int -> int -> unit -> unit
