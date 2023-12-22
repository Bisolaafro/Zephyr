open Tsdl.Sdl
open Tsdl_image.Image
open Player
open Tilemap
open Yojson.Basic.Util
open Consts
open Animations
open Spritesheet
open Vector

let collision_boundary_x = 15.
let collision_boundary_y = 50.
let bg_rect = Rect.create ~x:0 ~y:0 ~w:width ~h:height

type level_state =
  | Previous
  | This
  | Next

type t = {
  mutable player : Player.t option;
  tilemap : Tilemap.t;
  mutable background : texture option;
  mutable prev_level : string option;
  mutable next_level : string option;
  mutable state : level_state;
  respawn_pos : Vector.t;
}

let new_level () =
  {
    player = None;
    tilemap = new_tilemap ();
    background = None;
    prev_level = None;
    next_level = None;
    state = This;
    respawn_pos = zero ();
  }

let init_level file player r t =
  let lvl_json = "level/" ^ file |> Yojson.Basic.from_file in
  let tilemap_file = "level/" ^ (lvl_json |> member "tilemap" |> to_string) in
  let next = lvl_json |> member "next_lvl" |> to_string in
  let prev = lvl_json |> member "prev_lvl" |> to_string in
  let bg = lvl_json |> member "background" |> to_string in
  let player_x = lvl_json |> member "player_pos" |> member "x" |> to_int in
  let player_y = lvl_json |> member "player_pos" |> member "y" |> to_int in
  init_tilemap tilemap_file r t.tilemap;
  t.player <- Some player;
  t.next_level <- (if next = "" then None else Some next);
  t.prev_level <- (if prev = "" then None else Some prev);
  t.background <- Some (load_texture r bg |> Result.get_ok);
  t.respawn_pos.x <- float_of_int (player_x * t.tilemap.tile_side);
  t.respawn_pos.y <-
    float_of_int
      (height - ((t.tilemap.tilemap_rows - player_y) * t.tilemap.tile_side))

let check_collision i t =
  let player = Option.get t.player in
  let tiles = Option.get t.tilemap.tiles in
  if tiles.(i) <> None then begin
    let obj, _ = Option.get tiles.(i) in
    if has_intersection (Option.get player.objy.rect) (Option.get obj.rect) then begin
      if
        player.obj.pos.y > obj.pos.y +. obj.height -. collision_boundary_y
        && player.obj.vel.y < 0.
      then (
        player.obj.pos.y <- obj.pos.y +. obj.height;
        player.obj.on_ground <- true;
        player.obj.vel.y <- 0.)
      else if
        player.obj.pos.y +. player.obj.height
        < obj.pos.y +. collision_boundary_y
        && player.obj.vel.y > 0.
      then (
        player.obj.pos.y <- obj.pos.y -. player.obj.height;
        player.obj.vel.y <- 0.)
    end;
    if has_intersection (Option.get player.objx.rect) (Option.get obj.rect) then begin
      if
        player.obj.pos.x +. player.obj.width < obj.pos.x +. collision_boundary_x
        && player.obj.vel.x > 0.
      then player.obj.pos.x <- obj.pos.x -. player.obj.width
      else if
        player.obj.pos.x > obj.pos.x +. obj.width -. collision_boundary_x
        && player.obj.vel.x < 0.
      then player.obj.pos.x <- obj.pos.x +. obj.width
    end
  end;
  update_player_rects player

let handle_player_collisions t =
  let player = Option.get t.player in
  let left_tile = int_of_float player.obj.pos.x / t.tilemap.tile_side in
  let right_tile =
    int_of_float (player.obj.pos.x +. player.obj.width) / t.tilemap.tile_side
  in
  let top_tile =
    int_of_float
      (float_of_int Consts.height -. (player.obj.pos.y +. player.obj.height))
    / t.tilemap.tile_side
  in
  let bottom_tile =
    int_of_float (float_of_int Consts.height -. player.obj.pos.y)
    / t.tilemap.tile_side
  in
  try
    begin
      for i = left_tile - 1 to right_tile do
        for j = bottom_tile + 1 downto top_tile do
          let tile_index = (j * t.tilemap.tilemap_cols) + i in
          check_collision tile_index t
        done
      done
    end
  with _ -> ()

let update_level_state keyboard dt t =
  let player = Option.get t.player in
  handle_player_collisions t;
  update_player_state keyboard dt t.respawn_pos player;
  if player.obj.pos.x +. (player.obj.width /. 2.) > float_of_int width then (
    match t.next_level with
    | None ->
        player.obj.pos.x <- float_of_int width -. (player.obj.width /. 2.);
        update_player_rects player
    | Some _ ->
        player.obj.pos.x <- -.player.obj.width /. 2.;
        update_player_rects player;
        t.state <- Next)
  else if player.obj.pos.x +. (player.obj.width /. 2.) < 0. then
    match t.prev_level with
    | None ->
        player.obj.pos.x <- -.(player.obj.width /. 2.);
        update_player_rects player
    | Some _ ->
        player.obj.pos.x <- float_of_int width -. (player.obj.width /. 2.);
        update_player_rects player;
        t.state <- Previous

let sprite_width = 24
let sprite_height = 48
let sprite_speed = 2.0
let row_space = 0
let col_space = 24
let old_anim = ref ""

let draw_level_animated r t dt =
  render_copy ~src:bg_rect ~dst:bg_rect r (Option.get t.background)
  |> Result.get_ok;
  let player = Option.get t.player in
  let anim, name = get_anim player in
  if anim then (
    let check =
      if !old_anim <> name then (
        old_anim := name;
        true)
      else false
    in
    update_animations player_spritesheet
      (Hashtbl.find animation_table name)
      check;
    let row, col = update_sprite_index player_spritesheet dt anim in
    draw_animated_player row col sprite_width sprite_height row_space col_space
      r player);
  if anim = false then
    draw_animated_player 0 0 sprite_width sprite_height row_space col_space r
      player;
  draw_tilemap r t.tilemap
