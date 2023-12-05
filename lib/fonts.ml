open Sdl

type t = {
  filename : string;
  mutable text : string;
  mutable font_size : int;
  mutable color : Sdlttf.color;
  mutable src_rect : Sdlrect.t;
  mutable surface : Sdlsurface.t option;
  mutable dst_rect : Sdlrect.t option;
  mutable vel_x : int option;
  mutable vel_y : int option;
}

let new_font_object filename text font_size color =
  let font = Sdlttf.open_font ~file:filename ~ptsize:font_size in
  let w, h = Sdlttf.size_text font text in
  let src_rect = Sdlrect.make4 ~x:0 ~y:0 ~w ~h in
  {
    filename;
    text;
    font_size;
    color;
    src_rect;
    surface = None;
    dst_rect = None;
    vel_x = None;
    vel_y = None;
  }

let quit_font () = Sdlttf.quit ()

let load_font font_object =
  let font =
    Sdlttf.open_font ~file:font_object.filename ~ptsize:font_object.font_size
  in
  font_object.surface <-
    Some
      (Sdlttf.render_text_solid font ~text:font_object.text
         ~color:font_object.color)

let static_render renderer font_object =
  let tex =
    Texture.create_from_surface renderer (Option.get font_object.surface)
  in
  Render.copy renderer ~texture:tex ~src_rect:font_object.src_rect
    ~dst_rect:(Option.get font_object.dst_rect)

let update_position x y font_object =
  let w, h = Surface.get_dims (Option.get font_object.surface) in
  font_object.dst_rect <- Some (Sdlrect.make4 ~x ~y ~w ~h)

let get_speed font_object = (font_object.vel_x, font_object.vel_y)
let get_color font_object = font_object.color
let get_text font_object = font_object.text

let font_speed vel_x vel_y font_object =
  font_object.vel_x <- vel_x;
  font_object.vel_y <- vel_y

let mobile_render renderer font_object x_max y_max dt =
  let tex =
    Texture.create_from_surface renderer (Option.get font_object.surface)
  in
  let dst_rect =
    if font_object.vel_y <> None then
      let y = dt / Option.get font_object.vel_y mod y_max in
      { (Option.get font_object.dst_rect) with Rect.y }
    else Option.get font_object.dst_rect
  in
  let dst_rect =
    if font_object.vel_x <> None then
      let x = dt / Option.get font_object.vel_x mod x_max in
      { dst_rect with Rect.x }
    else dst_rect
  in
  Render.copy renderer ~texture:tex ~src_rect:font_object.src_rect ~dst_rect
