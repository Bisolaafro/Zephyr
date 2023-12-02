open Sdlevent
open Sdl
open Final.Keyboard
open Final.Consts
open Final.Textureloader
open Final.Levelloader

(* LEVEL *)
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
  init_level_loader "1.json" r level_loader;
  r

(* DRAW GAME *)
let draw r =
  Render.clear r;
  Render.set_scale r (1.0, 1.0);
  draw_level_loader r level_loader;
  Render.render_present r

(* GAME LOOP *)
let () =
  let r = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    update_state r dt;
    draw r;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
