(** Tilemap module. Includes a type for a tileset, which represents the set of
    tiles that can be used in a tilemap, as well as a type for a tilemap, which
    maps tiles to Gameobjects with positions on the screen. Includes functions
    to create, initialize and draw a tilemap.*)

open Gameobject
open Tsdl.Sdl

(** Represents a tileset. *)
type tileset_t = {
  mutable texture : texture option;
  mutable cols : int;
  mutable tile_side : int;
}

(** Represents a tilemap. *)
type t = {
  mutable tiles : (Gameobject.t * rect) option array option;
  mutable tilemap_cols : int;
  mutable tilemap_rows : int;
  mutable tile_side : int;
  tileset : tileset_t;
}

(** [new_tilemap ()] returns a new tilemap.*)
val new_tilemap : unit -> t

(** [init_tilemap fl r tmp] initializes the tilemap [tmp] with the JSON file
    [fl] to be drawn on renderer [r]. *)
val init_tilemap : string -> renderer -> t -> unit

(** [draw_tilemap r tmp] draws the tilemap [tmp] on renderer [r]. The optional
    int argument is meant for internal recursion and should not be used
    externally. *)
val draw_tilemap : renderer -> ?i:int -> t -> unit
