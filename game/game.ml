open Tsdl.Sdl
open Tsdl_ttf
open Tsdl_image
open Final.Keyboard
open Final.Consts
open Final.Levelloader
open Final.Mixer
open Final.Fonts
open Final.Container
open Mainmenu

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
let cont = Final.Container.empty ()
let _ = Final.Container.add_from_list [ atlas; secret ] cont
let _ = volume 5 10
let events = Event.create ()

(* LEVEL *)
let level_loader = new_level_loader ()
let main_menu = new_main_menu ()

(* KEYBOARD *)
let keyboard = new_keyboard ()

(* PROCESS INPUT *)
(* let rec event_loop () = match poll_event (Some events) with | false -> () |
   true -> update_keyboard events keyboard; event_loop () *)

(* Process input helper: quit game *)
let quit_game () =
  quit ();
  exit 0

(* UPDATE GAME *)
let update_state r dt =
  update_keyboard keyboard;
  if query_key Scancode.escape keyboard = Pressed then quit_game ();
  match !state with
  | MainMenu ->
      update_main_menu_state keyboard dt r main_menu;
      if
        query_key Scancode.return keyboard = Pressed
        && not (is_dismissed main_menu)
      then (
        play_channel (-1) select 0;
        ignore (Music.fade_out_music 100);
        if Music.music_vol (-1) <= 32 then Music.free_music ambient;
        Music.play_music call 0;
        dismiss main_menu)
      else if
        query_key Scancode.return keyboard = Pressed && is_dismissed main_menu
      then (
        Music.free_music call;
        state := Active);
      if is_finished main_menu then state := Active
  | Active ->
      update_level_loader_state keyboard dt r level_loader;
      if playing 5 |> Option.get |> not then
        play_channel 5 (Final.Container.alternate cont) 0

(* INITIALIZE GAME *)
let init () =
  begin
    match Tsdl.Sdl.init Init.everything with
    | Ok () -> ()
    | Error _ -> failwith "Unable to initialize SDL."
  end;
  ignore (Tsdl_image.Image.init Tsdl_image.Image.Init.png);
  Ttf.init () |> Result.get_ok;
  let open Image.Init in
  Image.init (jpg + png) |> ignore;
  let window =
    Tsdl.Sdl.create_window "Concrete Halls" ~w:width ~h:height
      Tsdl.Sdl.Window.fullscreen
    |> Result.get_ok
  in
  let r =
    Tsdl.Sdl.create_renderer ~index:(-1) ~flags:Tsdl.Sdl.Renderer.presentvsync
      window
    |> Result.get_ok
  in
  Tsdl.Sdl.render_set_logical_size r width height |> Result.get_ok;
  init_animated_level_loader "surface-1-linker.json" r level_loader fx;
  init_main_menu r main_menu;
  show_cursor true |> Result.get_ok |> ignore;
  Music.play_music ambient 5;
  Music.music_vol 30 |> ignore;
  let w, h = get_window_size window in
  Printf.printf "%s, %s" (string_of_int w) (string_of_int h);
  print_endline "";
  r

(* DRAW GAME *)
let draw r dt =
  Tsdl.Sdl.render_clear r |> ignore;
  Tsdl.Sdl.render_set_scale r 1.0 1.0 |> ignore;
  begin
    match !state with
    | MainMenu -> draw_main_menu r main_menu
    | Active -> draw_animated_level_loader r level_loader dt
  end;
  Tsdl.Sdl.render_present r

(* GAME LOOP *)
let run () =
  let r = init () in
  let rec main_loop last_t =
    let t = Int32.to_int (get_ticks ()) in
    let dt = t - last_t in
    update_state r dt;
    draw r dt;
    main_loop t
  in
  main_loop (Int32.to_int (get_ticks ()))
