open Level
open Player
open Consts
open Spritesheet
open Tsdl_image.Image

type t = {
  level : Level.t;
  player : Player.t;
}

let new_level_loader () = { level = new_level (); player = new_player () }

let init_animated_level_loader file r t fx =
  let boy = load_image r player_spritesheet in
  init_level file t.player r t.level;
  init_player boy (0., -1000.)
    ( 0. +. (player_width *. float_of_int t.level.tilemap.tile_side),
      -1000. +. (player_height *. float_of_int t.level.tilemap.tile_side) )
    t.player fx

let update_level_loader_state k dt r t =
  update_level_state k dt t.level;
  let lvl_opt =
    match t.level.state with
    | Previous -> t.level.prev_level
    | This -> None
    | Next -> t.level.next_level
  in
  begin
    match lvl_opt with
    | None -> ()
    | Some lvl ->
        t.level.state <- This;
        init_level lvl t.player r t.level
  end

let draw_animated_level_loader r t dt = draw_level_animated r t.level dt
