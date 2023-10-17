(** Player module. Contains a player type as well as functions to modify or read
    fields from a player *)

open Keyboard

(* Redefine mod operator because it has strange behavior in OCaml *)
let ( mod ) x y =
  let result = x mod y in
  if result >= 0 then result else result + y

(* Simple vector type *)
type vector = {
  mutable x : float;
  mutable y : float;
}

type t = {
  pos : vector;
  vel : vector;
  src_rect : Sdlrect.t;
  mutable texture : Sdltexture.t option;
  mutable rect : Sdlrect.t;
  mutable on_ground : bool;
}

let ground_level = 256.

let new_player =
  {
    pos = { x = 0.; y = ground_level };
    vel = { x = 0.; y = 0. };
    src_rect = Sdlrect.make4 ~x:0 ~y:0 ~w:256 ~h:256;
    texture = None;
    rect = Sdlrect.make4 ~x:0 ~y:0 ~w:256 ~h:256;
    on_ground = true;
  }

let init_player texture t = t.texture <- Some texture

let update_player_state k dt t =
  let float_dt = float_of_int dt in
  t.on_ground <- t.pos.y <= ground_level;
  let accel = 0.005 in
  if query_key W k then t.pos.y <- t.pos.y +. 0.;
  if query_key S k then t.pos.y <- t.pos.y -. 0.;
  if query_key A k then (
    t.pos.x <- t.pos.x -. 4.;
    t.vel.x <- -0.1);
  if query_key D k then (
    t.pos.x <- t.pos.x +. 4.;
    t.vel.x <- 0.1);
  if query_key Space k && t.on_ground then (
    t.vel.x <- 0.;
    t.vel.y <- 1.;
    t.on_ground <- false);
  if t.on_ground then (
    t.vel.y <- 0.;
    t.vel.x <- 0.;
    t.pos.y <- ground_level)
  else (
    t.pos.y <- t.pos.y +. (t.vel.y *. float_dt) -. (accel *. (float_dt ** 2.));
    t.vel.y <- t.vel.y -. (accel *. float_dt));
  t.pos.x <- t.pos.x +. (t.vel.x *. float_dt)

let draw_player r t =
  t.rect <-
    {
      t.rect with
      x = int_of_float t.pos.x mod 1920;
      y = int_of_float (float_of_int 1080 -. t.pos.y);
    };
  Sdlrender.copy r ~texture:(Option.get t.texture) ~src_rect:t.src_rect
    ~dst_rect:t.rect ()
