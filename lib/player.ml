open Keyboard
open Gameobject
open Consts
open Animations
open Mixer
open Tsdl.Sdl

let margin = 10.

type t = {
  objx : Gameobject.t;
  objy : Gameobject.t;
  obj : Gameobject.t;
  mutable sched_jump : bool;
  fx : Container.t;
  sounds : (string, Chunk.t) Hashtbl.t;
}

let new_player () =
  {
    objx = Gameobject.new_object ();
    objy = Gameobject.new_object ();
    obj = Gameobject.new_object ();
    sched_jump = false;
    fx = Container.empty ();
    sounds = Hashtbl.create 2;
  }

let init_player texture (x0, y0) (x1, y1) t ch =
  Gameobject.init_object texture
    (x0, y0 +. margin)
    (x1, y1 -. margin)
    true t.objx;
  Gameobject.init_object texture
    (x0 +. margin, y0)
    (x1 -. margin, y1)
    true t.objy;
  Container.add_from_list ch t.fx;
  Gameobject.init_object texture (x0, y0) (x1, y1) true t.obj;
  Hashtbl.add t.sounds "jump" (Chunk.load_wav "assets/jump2.wav");
  Hashtbl.add t.sounds "death" (Chunk.load_wav "assets/death.wav")

let update_player_rects t =
  let x, y =
    ( int_of_float t.obj.pos.x,
      int_of_float (float_of_int height -. (t.obj.pos.y +. t.obj.height)) )
  in
  let rect, rectx, recty =
    (Option.get t.obj.rect, Option.get t.objx.rect, Option.get t.objy.rect)
  in
  Rect.set_x rect x;
  Rect.set_y rect y;
  Rect.set_x rectx x;
  Rect.set_y rectx (y + int_of_float margin);
  Rect.set_x recty (x + int_of_float margin);
  Rect.set_y recty y

let update_player_state k dt (rc : Vector.t) t =
  let float_dt = float_of_int dt in
  let down key =
    match query_key key k with
    | Pressed | Down -> true
    | Released | Up -> false
  in
  let a_down, d_down, sp_pressed =
    (down Scancode.a, down Scancode.d, query_key Scancode.space k = Pressed)
  in
  let process_input = t.obj.pos.y > 0. in
  Gameobject.update_object_state dt t.obj;
  if process_input then begin
    if a_down && not d_down then (
      t.obj.pos.x <- t.obj.pos.x -. (vx *. float_dt);
      t.obj.vel.x <- -.vx;
      t.obj.animated <- true;
      t.obj.anim_name <- get_name anim_1);
    if d_down && not a_down then (
      t.obj.pos.x <- t.obj.pos.x +. (vx *. float_dt);
      t.obj.vel.x <- vx;
      t.obj.animated <- true;
      t.obj.anim_name <- get_name anim_2);
    if (not a_down) && not d_down then (
      t.obj.animated <- true;
      t.obj.anim_name <- get_name anim_3);
    if sp_pressed then t.sched_jump <- true
  end
  else begin
    t.obj.vel.x <- 0.
  end;
  if t.sched_jump && t.obj.on_ground then (
    t.sched_jump <- false;
    t.obj.animated <- false;
    t.obj.vel.x <- 0.;
    t.obj.vel.y <- dvy;
    play_channel (-1) (Hashtbl.find t.sounds "jump") 0);
  (* t.objx.pos.x <- t.obj.pos.x; t.objx.pos.y <- t.obj.pos.y +. margin;
     t.objy.pos.x <- t.obj.pos.x +. margin; t.objy.pos.y <- t.obj.pos.y; *)
  update_player_rects t;
  t.obj.on_ground <- false;
  if t.obj.pos.y < -1000. then (
    play_channel (-1) (Hashtbl.find t.sounds "death") 0;
    t.obj.vel.x <- 0.;
    t.obj.vel.y <- 0.;
    t.sched_jump <- false;
    t.obj.pos.x <- rc.x;
    t.obj.pos.y <- rc.y)

let get_anim t = (t.obj.animated, t.obj.anim_name)

let draw_animated_player row col width height row_space col_space r t =
  Gameobject.draw_animated_object row col width height row_space col_space r
    t.obj
