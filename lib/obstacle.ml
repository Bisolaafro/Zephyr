type t = {
  bottom_left : Vector.t;
  top_right : Vector.t;
  center : Vector.t;
  mutable width : float;
  mutable height : float;
  mutable texture : Sdltexture.t option;
  src_rect : Sdlrect.t option;
  mutable rect : Sdlrect.t option;
}

let new_obstacle =
  {
    bottom_left = Vector.zero;
    top_right = Vector.zero;
    center = Vector.zero;
    width = 0.;
    height = 0.;
    texture = None;
    src_rect = Some (Sdlrect.make4 ~x:0 ~y:0 ~w:256 ~h:256);
    rect = None;
  }

let init_obstacle texture (x0, y0) (x1, y1) t =
  let x0, y0, x1, y1 =
    (float_of_int x0, float_of_int y0, float_of_int x1, float_of_int y1)
  in
  t.bottom_left.x <- x0;
  t.bottom_left.y <- y0;
  t.top_right.x <- x1;
  t.top_right.y <- y1;
  t.texture <- Some texture;
  t.width <- x1 -. x0;
  t.height <- y1 -. y0;
  t.center.x <- x0 +. (t.width /. 2.);
  t.center.y <- y0 +. (t.height /. 2.);
  t.rect <-
    Some
      (Sdlrect.make4
         (int_of_float t.bottom_left.x)
         (int_of_float (float_of_int 1080 -. t.bottom_left.y))
         (int_of_float t.width) (int_of_float t.height))

let update_obstacle_state k dt t = ()

let draw_obstacle r t =
  let rect = Option.get t.rect in
  Sdlrender.copy r ~texture:(Option.get t.texture)
    ~src_rect:(Option.get t.src_rect) ~dst_rect:rect ()
