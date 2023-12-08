open Sdlevent
open Sdl
open Final.Keyboard
open Final.Consts
open Final.Textureloader
open Final.Levelloader
open Final.Mixer
open Final.Mainmenu
open Final.Fonts

type state =
  | MainMenu
  | Active

(* AUDIO *)
let _ = open_audio 44100 MIX_DEFAULT_FORMAT 2 2048
let _ = allocate_channels 4
let state = ref MainMenu
let fx = [ Chunk.load_wav "assets/jump.wav" ]
let select = Chunk.load_wav "assets/select.wav"
let call = Music.load_music "assets/call1.wav"
let main_enabled = false

(* LEVEL *)
let level_loader = new_level_loader ()
let main_menu = new_main_menu ()

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
  if not main_enabled then state := Active;
  if query_key Esc keyboard then quit_game ();
  match !state with
  | MainMenu ->
      update_main_menu_state keyboard dt r main_menu;
      if query_key EnterMain keyboard && not (is_dismissed main_menu) then (
        play_channel (-1) select 0;
        Music.play_music call 0;
        dismiss main_menu);
      if is_finished main_menu then state := Active
  | Active -> update_level_loader_state keyboard dt r level_loader

(* INITIALIZE GAME *)
let init () =
  Sdl.init [ `EVERYTHING ];
  Sdlimage.init [ `PNG ];
  Sdlttf.init ();
  let window =
    Window.create ~pos:(`centered, `centered) ~dims:(width, height)
      ~title:"Concrete Halls" ~flags:[ Window.FullScreen ]
  in
  let r =
    Render.create_renderer ~win:window ~index:(-1)
      ~flags:[ Render.PresentVSync ]
  in
  init_animated_level_loader "surface-1-linker.json" r level_loader fx;
  init_main_menu r main_menu;
  Mouse.show_cursor ~toggle:false;
  r

(* DRAW GAME *)
let draw r dt =
  Render.clear r;
  Render.set_scale r (1.0, 1.0);
  begin
    match !state with
    | MainMenu -> draw_main_menu r main_menu
    | Active -> draw_animated_level_loader r level_loader dt
  end;
  Render.render_present r

(* GAME LOOP *)
let () =
  let r = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    update_state r dt;
    draw r dt;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
