open Tsdl.Sdl

type t = {
  pos : Vector.t;
  vel : Vector.t;
  mutable width : float;
  mutable height : float;
  mutable texture : texture option;
  mutable src_rect : rect option;
  mutable rect : rect option;
  mutable affected_by_gravity : bool;
  mutable on_ground : bool;
  mutable facing_back : bool;
  mutable animated : bool;
  mutable anim_name : string;
}

let new_object () =
  {
    pos = Vector.zero ();
    vel = Vector.zero ();
    width = 0.;
    height = 0.;
    texture = None;
    src_rect = None;
    rect = None;
    affected_by_gravity = false;
    on_ground = true;
    facing_back = false;
    animated = false;
    anim_name = "";
  }

let init_object texture (x0, y0) (x1, y1) grav t =
  t.width <- x1 -. x0;
  t.height <- y1 -. y0;
  t.pos.x <- x0;
  t.pos.y <- y0;
  t.texture <- Some texture;
  let src_rect =
    Rect.create ~x:0 ~y:0 ~w:(int_of_float t.width) ~h:(int_of_float t.height)
  in
  let rect =
    Rect.create ~x:(int_of_float t.pos.x)
      ~y:(int_of_float (float_of_int Consts.height -. (t.pos.y +. t.height)))
      ~w:(int_of_float t.width) ~h:(int_of_float t.height)
  in
  t.src_rect <- Some src_rect;
  t.rect <- Some rect;
  t.affected_by_gravity <- grav

let update_object_state dt t =
  let rect = Option.get t.rect in
  let float_dt = float_of_int dt in
  let a = if t.affected_by_gravity then Consts.accel else 0. in
  t.pos.y <- t.pos.y +. (t.vel.y *. float_dt) -. (0.5 *. a *. (float_dt ** 2.));
  t.vel.y <- t.vel.y -. (a *. float_dt);
  t.pos.x <- t.pos.x +. (t.vel.x *. float_dt);
  if t.vel.x < 0. then t.facing_back <- true;
  if t.vel.x > 0. then t.facing_back <- false;
  if t.on_ground then t.vel.x <- 0.;
  Rect.set_x rect (int_of_float t.pos.x);
  Rect.set_y rect
    (int_of_float (float_of_int Consts.height -. (t.pos.y +. t.height)))

let draw_object ?src ?flip r t =
  let rect, tx = (Option.get t.rect, Option.get t.texture) in
  let src_rect =
    begin
      match src with
      | None ->
          Rect.create ~x:0 ~y:0 ~w:(int_of_float t.width)
            ~h:(int_of_float t.height)
      | Some s -> s
    end
  in
  let flip =
    if t.facing_back then Flip.horizontal
    else begin
      match flip with
      | None -> Flip.none
      | Some f -> f
    end
  in
  render_copy_ex ~src:src_rect ~dst:rect r tx 0. None flip |> Result.get_ok

let get_object row col width height row_space col_space r t =
  let x, y =
    if row = 0 && col = 0 then (0, 0)
    else if row = 0 && col <> 0 then ((col * width) + (col_space * col), 0)
    else if col = 0 && row <> 0 then (0, (row * height) + (row_space * row))
    else ((col * width) + (col_space * col), (row * height) + (row_space * row))
  in
  t.src_rect <- Some (Rect.create ~x ~y ~w:width ~h:height)

let draw_animated_object row col width height row_space col_space r t =
  get_object row col width height row_space col_space r t;
  draw_object ?src:t.src_rect r t
