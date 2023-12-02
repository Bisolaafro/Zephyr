open Level
open Player
open Textureloader
open Consts

type t = {
  level : Level.t;
  player : Player.t;
}

let new_level_loader () = { level = new_level (); player = new_player () }

let init_level_loader file r t =
  let caml = load_texture "assets/caml-export.png" PNG r in
  let x, y = (300., 300.) in
  init_player caml (x, y) (x +. 132., y +. 87.) t.player;
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
