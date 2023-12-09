open Sdlevent
open Keyboard
open Key
open Consts
open Textureloader
open Levelloader
open Mixer
open Mainmenu
open Fonts

type state =
  | MainMenu
  | Active

(* AUDIO *)
let _ = open_audio 44100 MIX_DEFAULT_FORMAT 2 2048
let _ = allocate_channels 7
let state = ref MainMenu
let fx = []
let select = Chunk.load_wav "assets/select.wav"
let ambient = Music.load_music "assets/wind.wav"
let call = Music.load_music "assets/call1.wav"
let atlas = Chunk.load_wav "assets/music/atlas.mp3"
let secret = Chunk.load_wav "assets/music/secret-meeting.mp3"
let cont = Container.empty ()
let _ = Container.add_from_list [ atlas; secret ] cont
let _ = volume 5 10

(* LEVEL *)
let level_loader = new_level_loader ()
let main_menu = new_main_menu ()

(* KEYBOARD *)
let keyboard = new_keyboard

(* PROCESS INPUT *)
let rec event_loop () =
  match Sdlevent.poll_event () with
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
        ignore (Music.fade_out_music 100);
        if Music.music_vol (-1) <= 32 then Music.free_music ambient;
        Music.play_music call 0;
        dismiss main_menu);
      if is_finished main_menu then state := Active
  | Active ->
      if playing 5 |> Option.get |> not then
        play_channel 5 (Container.alternate cont) 0;
      update_level_loader_state keyboard dt r level_loader

(* INITIALIZE GAME *)
let init () =
  Sdl.init [ `EVERYTHING ];
  Sdlimage.init [ `PNG ];
  Sdlttf.init ();
  let window =
    Sdlwindow.create ~pos:(`centered, `centered) ~dims:(width, height)
      ~title:"Concrete Halls" ~flags:[ Sdlwindow.FullScreen ]
  in
  let r =
    Sdlrender.create_renderer ~win:window ~index:(-1)
      ~flags:[ Sdlrender.PresentVSync ]
  in
  init_animated_level_loader "surface-1-linker.json" r level_loader fx;
  init_main_menu r main_menu;
  Sdlmouse.show_cursor ~toggle:false;
  Music.play_music ambient 5;
  ignore (Music.music_vol 30);
  r

(* DRAW GAME *)
let draw r dt =
  Sdlrender.clear r;
  Sdlrender.set_scale r (1.0, 1.0);
  begin
    match !state with
    | MainMenu -> draw_main_menu r main_menu
    | Active -> draw_animated_level_loader r level_loader dt
  end;
  Sdlrender.render_present r

(* GAME LOOP *)
let run () =
  let r = init () in
  let rec main_loop last_t =
    let t = Sdltimer.get_ticks () in
    let dt = t - last_t in
    event_loop ();
    update_state r dt;
    draw r dt;
    main_loop t
  in
  main_loop (Sdltimer.get_ticks ())
