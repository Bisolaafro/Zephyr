(** NEOCAML Interactive's game engine. This game engine utilizes the Sdl
    bindings provided by the [OCamlSDL2 SDL] bindings. This module handles
    rendering, in-game events, updating, and SDL subsystem initialization. *)

type t
(** Type representing this game engine *)

val init :
  string ->
  Sdl.Window.window_pos * Sdl.Window.window_pos ->
  int * int ->
  Sdlwindow.window_flags list ->
  t
(** [init title (xpos,ypos) (w,h) flags ] initializes the game engine. [title]
    is the title of the engine instance. [(xpos,ypos)] are the x and y positions
    of the Window location. [(w,h)] are the width and height of the window.
    [flags] is a list of [SDL_WindowFlags], as defined in the API. (when true).*)

val handle_events : unit -> unit
(** [handle_events ()] handles SDL events. As of now, this function can only
    handle keyboard events that make SDL quit.*)

(* [update ()] updates the behavior of any SDL objects in the engine instance.
   For example, it handles physics, collisions, etc. In other words, [update]
   updates the state of any initialized objects so that they can be drawn to the
   screen.*)
val update : unit -> unit

(* [render ()] draws all objects to the screen. #TODO: figure out quirks. *)
val render : unit -> unit

val clean : t -> unit
(** [clean ()] clears memory of any SDL objects previously initialized. *)

val running : unit -> bool
(** [running ()] is true if the current game is running. False otherwise. *)
