open Keyboard
open Gameobject
open Consts
open Animations

type t = {
  objx : GameObject.t;
  objy : GameObject.t;
  obj : GameObject.t;
  mutable jumped : bool;
}

let dx = 4.
let dvx = 0.2
let dvy = 2.
let jump_cooldown = 2
let player_width = 200.
let player_height = 200.

let new_player () =
  {
    objx = GameObject.new_object ();
    objy = GameObject.new_object ();
    obj = GameObject.new_object ();
    jumped = false;
  }

let init_player texture (x0, y0) (x1, y1) t =
  GameObject.init_object texture (x0, y0 +. 10.) (x1, y1 -. 10.) true t.objx;
  GameObject.init_object texture (x0 +. 10., y0) (x1 -. 10., y1) true t.objy;
  GameObject.init_object texture (x0, y0) (x1, y1) true t.obj

let update_player_rects t =
  t.obj.rect <-
    Some
      {
        (Option.get t.obj.rect) with
        x = int_of_float t.obj.pos.x;
        y = int_of_float (float_of_int height -. (t.obj.pos.y +. t.obj.height));
      };
  t.objx.rect <-
    Some
      {
        (Option.get t.objx.rect) with
        x = int_of_float t.obj.pos.x;
        y =
          int_of_float
            (float_of_int height -. (t.obj.pos.y +. t.obj.height -. 10.));
      };
  t.objy.rect <-
    Some
      {
        (Option.get t.objy.rect) with
        x = int_of_float (t.obj.pos.x +. 10.);
        y = int_of_float (float_of_int height -. (t.obj.pos.y +. t.obj.height));
      }

let update_player_state k dt t =
  GameObject.update_object_state dt t.obj;
  if query_key A k && not (query_key D k) then (
    t.obj.pos.x <- t.obj.pos.x -. dx;
    t.obj.animated <- true;
    t.obj.anim_name <- get_name anim_1;
    t.obj.vel.x <- -.dvx);
  if query_key D k && not (query_key A k) then (
    t.obj.pos.x <- t.obj.pos.x +. dx;
    t.obj.animated <- true;
    t.obj.anim_name <- get_name anim_2;
    t.obj.vel.x <- dvx);
  if query_key Space k = false then (
    t.jumped <- false;
    t.obj.animated <- false);
  if query_key Space k && t.obj.on_ground && t.jumped = false then (
    t.obj.animated <- false;
    t.obj.vel.x <- 0.;
    t.obj.vel.y <- dvy;
    t.obj.on_ground <- false;
    t.jumped <- true);
  if query_key A k = false && query_key D k = false then t.obj.animated <- false;
  t.objx.pos.x <- t.obj.pos.x;
  t.objx.pos.y <- t.obj.pos.y +. 10.;
  t.objy.pos.x <- t.obj.pos.x +. 10.;
  t.objy.pos.y <- t.obj.pos.y;
  t.obj.on_ground <- false

let get_anim t = (t.obj.animated, t.obj.anim_name)
let draw_player r t = GameObject.draw_object r t.obj

let draw_animated_player row col width height row_space col_space r t =
  let _ =
    GameObject.get_object row col width height row_space col_space r t.obj
  in
  GameObject.draw_object r t.obj
