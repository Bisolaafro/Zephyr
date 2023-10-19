open Sdlevent
open Sdl
open Final.Keyboard
open Final.Player
open Final.Obstacle

(* Some game constants *)
let width, height = (1920, 1080)
let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:1920 ~h:1080
let caml_rect = Rect.make4 ~x:0 ~y:0 ~w:264 ~h:174

(* PLAYER *)
let player = new_player
let obstacle = new_obstacle

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
  if query_key Esc keyboard || query_key Q keyboard then quit_game ();
  update_player_state keyboard dt player;
  if
    Sdlrect.has_intersection (Option.get player.rect) (Option.get obstacle.rect)
  then
    if
      (* if player.pos.x +. 264. < obstacle.bottom_left.x +. 50. then
         player.pos.x <- obstacle.bottom_left.x -. 264.; if player.pos.x >
         obstacle.bottom_left.x +. 250. then player.pos.x <-
         obstacle.bottom_left.x +. 300.; *)
      player.pos.y -. 174. > obstacle.bottom_left.y -. 100. && player.vel.y < 0.
    then (
      player.pos.y <- obstacle.bottom_left.y +. 174.;
      player.on_ground <- true;
      player.vel.y <- 0.);
  (* if player.pos.y < obstacle.bottom_left.y -. 200. then player.pos.y <-
     obstacle.bottom_left.y); *)
  player.rect <-
    Some
      {
        (Option.get player.rect) with
        x = int_of_float player.pos.x mod 1920;
        y = int_of_float (float_of_int 1080 -. player.pos.y);
      }

(* INITIALIZE GAME *)
let init () =
  Sdl.init [ `EVERYTHING ];
  let window =
    Window.create ~pos:(`centered, `centered) ~dims:(width, height)
      ~title:"Polaris" ~flags:[ Window.FullScreen ]
  in
  let rndr =
    Render.create_renderer ~win:window ~index:(-1) ~flags:[ Render.Accelerated ]
  in
  let load_sprite renderer ~filename =
    let surf = Surface.load_bmp ~filename in
    let tex = Texture.create_from_surface renderer surf in
    Surface.free surf;
    tex
  in
  let caml_file = "assets/caml-export.bmp" in
  let bg_file = "assets/Background.bmp" in
  let rect_file = "assets/box.bmp" in
  let caml = load_sprite rndr ~filename:caml_file in
  let bg = load_sprite rndr ~filename:bg_file in
  let rect = load_sprite rndr ~filename:rect_file in
  init_player caml player;
  init_obstacle rect (500, 220) (700, 420) obstacle;
  (rndr, bg)

(* DRAW GAME *)
let draw (rndr, bg) =
  Render.clear rndr;
  Render.set_scale rndr (1.0, 1.0);
  Render.copy rndr ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  draw_player rndr player;
  draw_obstacle rndr obstacle;
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
