open Keyboard
open Vector

type t = {
  pos : Vector.t;
  vel : Vector.t;
  src_rect : Sdlrect.t option;
  mutable texture : Sdltexture.t option;
  mutable rect : Sdlrect.t option;
  mutable on_ground : bool;
  mutable time_on_ground : int;
}

let ground_level = 245.
let accel = 0.005
let dx = 4.
let dvx = 0.2
let dvy = 2.
let jump_cooldown = 7
let width, height = (1920, 1080)

let new_player =
  {
    pos = { x = 0.; y = ground_level };
    vel = { x = 0.; y = 0. };
    src_rect = Some (Sdlrect.make4 ~x:0 ~y:0 ~w:264 ~h:174);
    texture = None;
    rect = Some (Sdlrect.make4 ~x:0 ~y:0 ~w:264 ~h:174);
    on_ground = true;
    time_on_ground = 0;
  }

let init_player texture t = t.texture <- Some texture

let update_player_state k dt t =
  let float_dt = float_of_int dt in
  let accel = accel in
  t.pos.y <- t.pos.y +. (t.vel.y *. float_dt) -. (accel *. (float_dt ** 2.));
  t.vel.y <- t.vel.y -. (accel *. float_dt);
  t.pos.x <- t.pos.x +. (t.vel.x *. float_dt);
  if t.pos.y <= ground_level then (
    t.on_ground <- true;
    t.pos.y <- ground_level);
  if query_key A k then (
    t.pos.x <- t.pos.x -. dx;
    t.vel.x <- -.dvx);
  if query_key D k then (
    t.pos.x <- t.pos.x +. dx;
    t.vel.x <- dvx);
  if query_key Space k && t.on_ground && t.time_on_ground >= jump_cooldown then (
    t.vel.x <- 0.;
    t.vel.y <- dvy;
    t.on_ground <- false;
    t.time_on_ground <- 0);
  if t.on_ground then (
    t.vel.x <- 0.;
    t.time_on_ground <- t.time_on_ground + 1);
  t.rect <-
    Some
      {
        (Option.get t.rect) with
        x = int_of_float t.pos.x;
        y = int_of_float (float_of_int height -. t.pos.y);
      }

let draw_player r t =
  Sdlrender.copy r ~texture:(Option.get t.texture)
    ~src_rect:(Option.get t.src_rect) ~dst_rect:(Option.get t.rect) ()
