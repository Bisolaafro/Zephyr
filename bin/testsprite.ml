(* Import the modules *)
open Final.Keyboard
open Final.Spritesheet
open Final.Player
open Sdl
open Sdlevent

(* Define some constants *)
let window_width, window_height = (1920, 1080)
let window_height = 480
let sprite_rows = 2
let sprite_cols = 8
let sprite_width = 102
let sprite_height = 153
let sprite_speed = 2.0
let row_space = 0
let col_space = 0
let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:1920 ~h:1080
let player = new_player ()
let keyboard = new_keyboard

let quit () =
  Sdl.quit ();
  exit 0

let rec event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some e ->
      update_keyboard e keyboard;
      event_loop ()

let update_state dt =
  if query_key Esc keyboard || query_key Q keyboard then quit ();
  update_player_state keyboard dt player

let init () =
  Sdl.init [ `EVERYTHING ];
  let window =
    Window.create ~pos:(`centered, `centered)
      ~dims:(window_width, window_height)
      ~title:"Polaris" ~flags:[ Window.FullScreen ]
  in
  let renderer =
    Render.create_renderer ~win:window ~index:(-1) ~flags:[ Render.Accelerated ]
  in

  let load_sprite renderer ~filename =
    let surf = Surface.load_bmp ~filename in
    let tex = Texture.create_from_surface renderer surf in
    Surface.free surf;
    tex
  in
  let bg_file = "assets/splash.bmp" in
  let bg = load_sprite renderer ~filename:bg_file in
  let spritesheet =
    new_spritesheet "assets/fire.bmp" sprite_rows sprite_cols sprite_width
      sprite_height
  in
  let texture = load_image renderer spritesheet in
  init_player texture player;
  (renderer, spritesheet, bg)

let draw (renderer, spritesheet, bg) dt =
  Render.clear renderer;
  Render.set_scale renderer (1.0, 1.0);
  Render.copy renderer ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  let row, col = update_sprite_index spritesheet dt in
  update_index_in_sheet spritesheet dt;
  (* get_player row col sprite_width sprite_height renderer player; *)
  draw_animated_player row col sprite_width sprite_height renderer player;
  Render.render_present renderer

let () =
  let renderer = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    draw renderer t;
    update_state dt;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
