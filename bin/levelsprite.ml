open Sdlevent
open Sdl
open Final.Keyboard
open Final.Consts
open Final.Textureloader
open Final.Levelloader
open Final.Mixer

let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:width ~h:height

(* AUDIO *)
let _ = open_audio 44100 MIX_DEFAULT_FORMAT 2 2048
let _ = allocate_channels 4
let fx = [ Chunk.load_wav "assets/jump.wav" ]

(* LEVEL *)
(* let obj1 = GameObject.new_object () let obj2 = GameObject.new_object () *)
let level_loader = new_level_loader ()

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
let update_state r dt =
  if query_key Esc keyboard then quit_game ();
  update_level_loader_state keyboard dt r level_loader

(* INITIALIZE GAME *)
let init () =
  Sdl.init [ `EVERYTHING ];
  Sdlimage.init [ `PNG ];
  let window =
    Window.create ~pos:(`centered, `centered) ~dims:(width, height)
      ~title:"Polaris" ~flags:[ Window.FullScreen ]
  in
  let r =
    Render.create_renderer ~win:window ~index:(-1)
      ~flags:[ Render.PresentVSync ]
  in

  let load_sprite_png renderer ~filename = load_texture filename PNG renderer in
  let bg_file = "assets/bg3.png" in

  let bg = load_sprite_png r ~filename:bg_file in

  init_animated_level_loader "1.json" r level_loader fx;

  (r, bg)

(* DRAW GAME *)
let draw (rndr, bg) dt =
  Render.clear rndr;
  Render.set_scale rndr (1.0, 1.0);
  Render.copy rndr ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  draw_animated_level_loader rndr level_loader dt;
  Render.render_present rndr

(* GAME LOOP *)
let () =
  let r, bg = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    update_state r dt;
    draw (r, bg) dt;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
