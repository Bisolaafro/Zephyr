open Gameobject

type tileset_t = {
  mutable texture : Sdltexture.t option;
  mutable cols : int;
  mutable tile_side : int;
}

type t = {
  mutable tiles : (GameObject.t * Sdlrect.t) option array option;
  mutable tilemap_cols : int;
  mutable tile_side : int;
  tileset : tileset_t;
}

val new_tilemap : unit -> t
val init_tilemap : string -> Sdlrender.t -> t -> unit
val draw_tilemap : Sdlrender.t -> ?i:int -> t -> unit
