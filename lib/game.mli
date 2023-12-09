(** NEOCAML Interactive's Zephyr game engine. This game engine utilizes the Sdl
    bindings provided by the [OCamlSDL2 SDL] bindings. This module handles
    rendering, in-game events, updating, and SDL subsystem initialization. *)

(** [run ()] executes the game. *)
val run : unit -> unit
