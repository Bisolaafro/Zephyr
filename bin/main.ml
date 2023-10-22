open Sdlevent
open Sdl
open Final.Keyboard
open Final.Player
open Final.Gameobject
open Final.Consts

let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:width ~h:height

(* PLAYER *)
let player = new_player ()
let obj1 = GameObject.new_object ()
let obj2 = GameObject.new_object ()

(* KEYBOARD *)
let keyboard = new_keyboard

(* PROCESS INPUT *)
let rec event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some e ->
      update_keyboard e keyboard;
      event_loop ()

(* Process input helper: quit game *)
let quit_game () =
  Sdl.quit ();
  exit 0

(* UPDATE GAME *)
let update_state dt =
  if query_key Esc keyboard then quit_game ();
  if query_key E keyboard then (
    obj1.affected_by_gravity <- true;
    obj1.vel.x <- 0.5);
  if query_key Q keyboard then (
    obj1.affected_by_gravity <- true;
    obj1.vel.y <- 2.);
  update_player_state keyboard dt player;
  GameObject.update_object_state dt obj1;
  GameObject.update_object_state dt obj2;
  if
    Sdlrect.has_intersection (Option.get player.obj.rect) (Option.get obj1.rect)
  then begin
    if
      player.obj.pos.y > obj1.pos.y +. obj1.height -. 50.
      && player.obj.vel.y < 0.
    then (
      player.obj.pos.y <- obj1.pos.y +. obj1.height;
      player.obj.on_ground <- true;
      player.obj.vel.y <- 0.)
    else if
      player.obj.pos.y +. player.obj.height < obj1.pos.y +. 50.
      && player.obj.vel.y > 0.
    then (
      player.obj.pos.y <- obj1.pos.y -. player.obj.height;
      player.obj.vel.y <- 0.)
    else if
      player.obj.pos.x +. player.obj.width < obj1.pos.x +. 50.
      && player.obj.vel.x > 0.
    then player.obj.pos.x <- obj1.pos.x -. player.obj.width
    else if
      player.obj.pos.x > obj1.pos.x +. obj1.width -. 50.
      && player.obj.vel.x < 0.
    then player.obj.pos.x <- obj1.pos.x +. obj1.width
  end;
  if
    Sdlrect.has_intersection (Option.get player.obj.rect) (Option.get obj2.rect)
  then begin
    if
      player.obj.pos.y > obj2.pos.y +. obj2.height -. 50.
      && player.obj.vel.y < 0.
    then (
      player.obj.pos.y <- obj2.pos.y +. obj2.height;
      player.obj.on_ground <- true;
      player.obj.vel.y <- 0.)
    else if
      player.obj.pos.y +. player.obj.height < obj2.pos.y +. 50.
      && player.obj.vel.y > 0.
    then (
      player.obj.pos.y <- obj2.pos.y -. player.obj.height;
      player.obj.vel.y <- 0.)
    else if
      player.obj.pos.x +. player.obj.width < obj2.pos.x +. 50.
      && player.obj.vel.x > 0.
    then player.obj.pos.x <- obj2.pos.x -. player.obj.width
    else if
      player.obj.pos.x > obj2.pos.x +. obj2.width -. 50.
      && player.obj.vel.x < 0.
    then player.obj.pos.x <- obj2.pos.x +. obj2.width
  end;
  player.obj.rect <-
    Some
      {
        (Option.get player.obj.rect) with
        x = int_of_float player.obj.pos.x;
        y =
          int_of_float
            (float_of_int height -. (player.obj.pos.y +. player.obj.height));
      }

(* INITIALIZE GAME *)
let init () =
  Sdl.init [ `EVERYTHING ];
  Sdlimage.init [ `PNG ];
  let window =
    Window.create ~pos:(`centered, `centered) ~dims:(width, height)
      ~title:"Polaris" ~flags:[ Window.FullScreen ]
  in
  let rndr =
    Render.create_renderer ~win:window ~index:(-1)
      ~flags:[ Render.PresentVSync ]
  in
  let load_sprite_bmp renderer ~filename =
    Final.TextureLoader.(load_texture filename BMP renderer)
  in
  let caml_file = "assets/caml-export.bmp" in
  let bg_file = "assets/Background.bmp" in
  let box_file = "assets/box.bmp" in
  let caml = load_sprite_bmp rndr ~filename:caml_file in
  let bg = load_sprite_bmp rndr ~filename:bg_file in
  let box = load_sprite_bmp rndr ~filename:box_file in
  init_player caml player;
  GameObject.init_object box (1100., 420.) (1240., 530.) false obj1 ();
  GameObject.init_object box (700., 720.) (840., 830.) true obj2 ();
  (rndr, bg)

(* DRAW GAME *)
let draw (rndr, bg) =
  Render.clear rndr;
  Render.set_scale rndr (1.0, 1.0);
  Render.copy rndr ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  draw_player rndr player;
  GameObject.draw_object rndr obj1;
  GameObject.draw_object rndr obj2;
  Render.render_present rndr

(* GAME LOOP *)
let () =
  let renderer = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    update_state dt;
    draw renderer;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
