open Tsdl.Sdl
open Tsdl_ttf.Ttf
open Gameobject

type t = { obj : Gameobject.t }

let quit_font () = Tsdl_ttf.Ttf.quit ()
let new_font_object () = { obj = new_object () }

let init_font_object r fl txt (xc, yc) sz cl a t =
  let font = open_font fl sz |> Result.get_ok in
  let w, h = size_text font txt |> Result.get_ok in
  let x0, y0 = (xc -. (float_of_int w /. 2.), yc -. (float_of_int h /. 2.)) in
  let x1, y1 = (x0 +. float_of_int w, y0 +. float_of_int h) in
  let tx =
    render_text_blended font txt cl
    |> Result.get_ok
    |> create_texture_from_surface r
    |> Result.get_ok
  in
  set_texture_blend_mode tx Blend.mode_blend |> Result.get_ok;
  set_texture_alpha_mod tx a |> Result.get_ok;
  init_object tx (x0, y0) (x1, y1) false t.obj

let draw_font_object r t = draw_object r t.obj

let change_alpha a t =
  set_texture_alpha_mod (Option.get t.obj.texture) a |> Result.get_ok
