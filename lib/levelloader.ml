open Level
open Player
open Textureloader
open Consts
open Spritesheet

type t = {
  level : Level.t;
  player : Player.t;
}

let sprite_rows = 12
let sprite_cols = 8
let sprite_width = 24
let sprite_height = 48
let sprite_speed = 2.0
let row_space = 0
let col_space = 24

let spritesheet =
  new_spritesheet "assets/punkgirly.png" sprite_rows sprite_cols sprite_width
    sprite_height 0 0 (sprite_cols - 1) 5

let new_level_loader () = { level = new_level (); player = new_player () }

let init_level_loader file r t fx =
  let caml = load_texture "assets/caml-export.png" PNG r in
  let x, y = (300., 300.) in
  init_player caml (x, y) (x +. 132., y +. 87.) t.player fx;
  init_level file t.player r t.level

let init_animated_level_loader file r t fx =
  let boy = load_image r spritesheet in
  let x, y = (100., 600.) in
  init_player boy (x, y) (x +. 90., y +. 110.) t.player fx;
  init_level file t.player r t.level

let update_level_loader_state k dt r t =
  update_level_state k dt t.level;
  let lvl_opt =
    match t.level.state with
    | Previous -> t.level.prev_level
    | This -> None
    | Next -> t.level.next_level
  in
  match lvl_opt with
  | None -> ()
  | Some lvl ->
      t.level.state <- This;
      init_level lvl t.player r t.level

let draw_level_loader r t = draw_level r t.level
let draw_animated_level_loader r t dt = draw_level_animated r t.level dt
