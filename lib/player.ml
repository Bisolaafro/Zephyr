open Keyboard
open Gameobject
open Consts

type t = {
  obj : Gameobject.t;
  mutable time_on_ground : int;
}

let dx = 4.
let dvx = 0.2
let dvy = 2.
let jump_cooldown = 4
let new_player () = { obj = new_object (); time_on_ground = 0 }

let init_player texture t =
  init_object texture (100., 100.) (364., 274.) true t.obj

let update_player_state k dt t =
  update_object_state dt t.obj;
  if t.obj.on_ground then t.time_on_ground <- t.time_on_ground + 1;
  if query_key A k then (
    t.obj.pos.x <- t.obj.pos.x -. dx;
    t.obj.vel.x <- -.dvx);
  if query_key D k then (
    t.obj.pos.x <- t.obj.pos.x +. dx;
    t.obj.vel.x <- dvx);
  if query_key Space k && t.obj.on_ground && t.time_on_ground >= jump_cooldown
  then (
    t.obj.vel.x <- 0.;
    t.obj.vel.y <- dvy;
    t.obj.on_ground <- false;
    t.time_on_ground <- 0)

let draw_player r t = draw_object r t.obj
