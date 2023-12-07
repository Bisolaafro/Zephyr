open Textureloader
open Consts
open Fonts
open Sdl
open Mixer

type t = {
  mutable background : Sdltexture.t option;
  mutable city : Sdltexture.t option;
  mutable label : Fonts.t option;
  mutable alpha_ctr : int;
  fx : Container.t;
  mutable dismissed : bool;
  mutable finished : bool;
}

let src_rect = Rect.make4 ~x:0 ~y:0 ~w:3840 ~h:2160
let dst_rect = Rect.make4 ~x:0 ~y:0 ~w:width ~h:height

let new_main_menu () =
  {
    background = None;
    city = None;
    label = None;
    alpha_ctr = 0;
    fx = Container.empty ();
    dismissed = false;
    finished = false;
  }

let init_main_menu r t =
  let bg, city, l =
    ( load_texture main_menu_bg JPG r,
      load_texture "assets/nightcity.jpeg" JPG r,
      Fonts.new_font_object "assets/douar.ttf" "PRESS ENTER TO CONTINUE" 40
        { Sdlttf.r = 255; g = 255; b = 255; a = 0 } )
  in
  t.background <- Some bg;
  t.city <- Some city;
  t.label <- Some l;
  load_font l;
  let w, h = get_dims l in
  update_position ((width / 2) - (w / 2)) (height - 100) l;
  Texture.set_blend_mode bg Blend;
  Texture.set_blend_mode city Blend

let update_main_menu_state k dt r t =
  t.alpha_ctr <- t.alpha_ctr + dt;
  if t.dismissed && t.alpha_ctr > 148000 then t.finished <- true

let dismiss t =
  if not t.dismissed then (
    t.dismissed <- true;
    t.alpha_ctr <- 0)

let is_dismissed t = t.dismissed
let is_finished t = t.finished

let draw_main_menu r t =
  let bg, city, l =
    (Option.get t.background, Option.get t.city, Option.get t.label)
  in
  let float_ctr = float_of_int t.alpha_ctr in
  if t.dismissed then begin
    Texture.set_alpha_mod bg
      ~alpha:
        (let alpha =
           int_of_float ((1. -. ((float_ctr /. 1000.) ** 2.)) *. 255.)
         in
         if alpha >= 0 then alpha else 0)
  end;
  Texture.set_alpha_mod city ~alpha:(if float_ctr >= 2800. then 255 else 0);
  Render.copy r ~texture:bg ~src_rect ~dst_rect ();
  if not t.dismissed then
    static_render_alpha r
      ~alpha:
        (int_of_float ((sin (float_of_int t.alpha_ctr /. 1000.) ** 2.) *. 255.))
      l
  else Render.copy r ~texture:city ~src_rect ~dst_rect ()
