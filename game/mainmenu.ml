open Final.Component
open Final.Consts
open Final.Fonts
open Final.Mixer
open Final
open Tsdl.Sdl
open Tsdl_image.Image

type t = {
  mutable stage1 : Component.t option;
  mutable stage2 : Component.t option;
  mutable label : Fonts.t option;
  mutable ctr : int;
  fx : Container.t;
  mutable dismissed : bool;
  mutable finished : bool;
}

let new_main_menu () =
  {
    stage1 = None;
    stage2 = None;
    label = None;
    ctr = 0;
    fx = Container.empty ();
    dismissed = false;
    finished = false;
  }

let init_main_menu r t =
  let bg, city, l, ttl_comp, sk_comp =
    ( load_texture r "assets/city.jpeg" |> Result.get_ok,
      load_texture r "assets/nightcity.jpeg" |> Result.get_ok,
      new_font_object (),
      new_font_component (),
      new_font_component () )
  in
  let white = Color.create 255 255 255 255 in
  let bg_comp = new_image_component () in
  init_image_component bg (0, 0) (width, height) bg_comp;
  init_font_object r "assets/douar.ttf" "PRESS ENTER TO CONTINUE"
    (float_of_int width /. 2., float_of_int height /. 5.)
    40 white 0 l;
  init_font_component r "assets/douar.ttf" "CONCRETE HALLS"
    (float_of_int width /. 2., float_of_int height *. 4. /. 5.)
    120 white 0 ttl_comp;
  let st1 = new_stage [ bg_comp; ttl_comp ] in
  show 500 st1;
  t.stage1 <- Some st1;
  let city_comp = new_image_component () in
  init_image_component city (0, 0) (width, height) city_comp;
  init_font_component r "assets/douar.ttf" "Press Enter to skip"
    (float_of_int width /. 2., float_of_int height /. 5.)
    40 white 0 sk_comp;
  let st2 = new_stage [ city_comp; sk_comp ] in
  t.stage2 <- Some st2;
  t.label <- Some l

let update_main_menu_state k dt r t =
  let st1, st2 = (Option.get t.stage1, Option.get t.stage2) in
  update_component dt st1;
  update_component dt st2;
  t.ctr <- t.ctr + dt;
  if t.dismissed && t.ctr > 148000 then t.finished <- true;
  if t.dismissed then Component.hide 1000 st1;
  if t.ctr >= 2800 && t.dismissed then Component.show 500 st2

let dismiss t =
  if not t.dismissed then (
    t.dismissed <- true;
    t.ctr <- 0)

let is_dismissed t = t.dismissed
let is_finished t = t.finished

let draw_main_menu r t =
  let st1, st2, label =
    (Option.get t.stage1, Option.get t.stage2, Option.get t.label)
  in
  Component.draw_component r st1;
  if not t.dismissed then begin
    change_alpha
      (int_of_float ((sin (float_of_int t.ctr /. 1000.) ** 2.) *. 255.))
      label;
    draw_font_object r label
  end;
  Component.draw_component r st2
