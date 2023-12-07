open Textureloader
open Consts
open Fonts
open Sdl

type t = {
  mutable background : Sdltexture.t option;
  mutable label : Fonts.t option;
  mutable alpha_ctr : int;
}

let src_rect = Rect.make4 ~x:0 ~y:0 ~w:3840 ~h:2160
let dst_rect = Rect.make4 ~x:0 ~y:0 ~w:width ~h:height
let new_main_menu () = { background = None; label = None; alpha_ctr = 0 }

let init_main_menu r t =
  t.background <- Some (load_texture main_menu_bg JPG r);
  t.label <-
    Some
      (Fonts.new_font_object "assets/douar.ttf" "PRESS ENTER TO CONTINUE" 40
         { Sdlttf.r = 255; g = 255; b = 255; a = 0 });
  load_font (Option.get t.label);
  let w, h = get_dims (Option.get t.label) in
  update_position ((width / 2) - (w / 2)) (height - 100) (Option.get t.label)

let update_main_menu_state k dt r t = t.alpha_ctr <- t.alpha_ctr + dt

let draw_main_menu r t =
  Render.copy r ~texture:(Option.get t.background) ~src_rect ~dst_rect ();
  static_render_alpha r
    ~alpha:
      (int_of_float ((sin (float_of_int t.alpha_ctr /. 1000.) ** 2.) *. 255.))
    (Option.get t.label)
