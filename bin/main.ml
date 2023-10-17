(* open Final *)
open Sdlevent
open Sdl
open Final.Keyboard
open Final.Player

(* Some game constants *)
let width, height = (1920, 1080)
let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:1920 ~h:1080
let caml_rect = Rect.make4 ~x:0 ~y:0 ~w:256 ~h:256

(* PLAYER *)
let player = new_player

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
let quit () =
  Sdl.quit ();
  exit 0

(* UPDATE GAME *)
let update_state dt =
  if query_key Esc keyboard || query_key Q keyboard then quit ();
  update_player_state keyboard dt player

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
  let caml_file = "assets/caml.bmp" in
  let bg_file = "assets/splash.bmp" in
  let caml = load_sprite rndr ~filename:caml_file in
  let bg = load_sprite rndr ~filename:bg_file in
  init_player caml player;
  (rndr, caml, bg)

(* DRAW GAME *)
let draw (rndr, caml, bg) =
  Render.clear rndr;
  Render.set_scale rndr (1.0, 1.0);
  Render.copy rndr ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  draw_player rndr player;
  Render.render_present rndr

(* GAME LOOP *)
let () =
  let renderer = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    draw renderer;
    update_state dt;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
