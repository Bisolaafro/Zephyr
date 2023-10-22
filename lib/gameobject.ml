module type GameObjectType = sig
  type t = {
    pos : Vector.t;
    vel : Vector.t;
    mutable width : float;
    mutable height : float;
    mutable texture : Sdltexture.t option;
    mutable src_rect : Sdlrect.t option;
    mutable rect : Sdlrect.t option;
    mutable affected_by_gravity : bool;
    mutable on_ground : bool;
    mutable facing_back : bool;
  }

  val new_object : unit -> t

  val init_object :
    Sdltexture.t -> float * float -> float * float -> bool -> t -> unit

  val update_object_state : int -> t -> unit
  val draw_object : Sdlrender.t -> t -> unit
end

module GameObject = struct
  type t = {
    pos : Vector.t;
    vel : Vector.t;
    mutable width : float;
    mutable height : float;
    mutable texture : Sdltexture.t option;
    mutable src_rect : Sdlrect.t option;
    mutable rect : Sdlrect.t option;
    mutable affected_by_gravity : bool;
    mutable on_ground : bool;
    mutable facing_back : bool;
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
    }

  let init_object texture (x0, y0) (x1, y1) grav t =
    t.width <- x1 -. x0;
    t.height <- y1 -. y0;
    t.pos.x <- x0;
    t.pos.y <- y0;
    t.texture <- Some texture;
    t.src_rect <-
      Some
        (Sdlrect.make4 ~x:0 ~y:0 ~w:(int_of_float t.width)
           ~h:(int_of_float t.height));
    t.rect <-
      Some
        (Sdlrect.make4 (int_of_float t.pos.x)
           (int_of_float (float_of_int Consts.height -. (t.pos.y +. t.height)))
           (int_of_float t.width) (int_of_float t.height));
    t.affected_by_gravity <- grav

  let update_object_state dt t =
    let float_dt = float_of_int dt in
    let a = if t.affected_by_gravity then Consts.accel else 0. in
    t.pos.y <- t.pos.y +. (t.vel.y *. float_dt) -. (0.5 *. a *. (float_dt ** 2.));
    t.vel.y <- t.vel.y -. (a *. float_dt);
    t.pos.x <- t.pos.x +. (t.vel.x *. float_dt);
    if t.pos.y <= Consts.ground_level then (
      t.pos.y <- Consts.ground_level;
      t.on_ground <- true);
    if t.vel.x < 0. then t.facing_back <- true;
    if t.vel.x > 0. then t.facing_back <- false;
    if t.on_ground then t.vel.x <- 0.;
    if t.pos.y <= Consts.ground_level then t.pos.y <- Consts.ground_level;
    t.rect <-
      Some
        {
          (Option.get t.rect) with
          x = int_of_float t.pos.x;
          y = int_of_float (float_of_int Consts.height -. (t.pos.y +. t.height));
        }

  let draw_object r t =
    Sdlrender.copyEx r ~texture:(Option.get t.texture)
      ~src_rect:(Option.get t.src_rect) ~dst_rect:(Option.get t.rect) ~angle:0.
      ~flip:(if t.facing_back then Flip_None else Flip_Horizontal)
      ()
end
