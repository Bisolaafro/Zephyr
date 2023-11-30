open Sdl
open Final.Fonts
open Sdlevent
open Final.Keyboard
open Final.Player
open Final.Gameobject
open Final.Consts

let file = "assets/FANTASY MAGIST.otf"
let color = { Sdlttf.r = 255; g = 0; b = 0; a = 0 }
let text = "YOUR MOTHER"
let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:width ~h:height

let quit_game () =
  quit_font ();
  Sdl.quit ();
  exit 0

let proc_events = function
  | KeyDown { keycode = Keycode.Q }
  | KeyDown { keycode = Keycode.Escape }
  | Quit _ ->
      Sdlttf.quit ();
      Sdl.quit ();
      exit 0
  | e -> ()

let rec event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some ev ->
      proc_events ev;
      event_loop ()

let init () =
  Sdl.init [ `EVERYTHING ];
  Sdlttf.init ();
  let window =
    Window.create ~pos:(`centered, `centered) ~dims:(width, height)
      ~title:"Polaris" ~flags:[ Window.FullScreen ]
  in
  let rndr =
    Render.create_renderer ~win:window ~index:(-1)
      ~flags:[ Render.PresentVSync ]
  in
  let load_sprite_bmp renderer ~filename =
    Final.Textureloader.(load_texture filename BMP renderer)
  in
  let bg_file = "assets/Background.bmp" in
  let bg = load_sprite_bmp rndr ~filename:bg_file in
  let font_object = new_font_object file text 40 color in
  load_font font_object;
  update_position 200 200 font_object;
  font_speed (Some 10) (Some 10) font_object;

  (font_object, rndr, bg)

let draw (font_object, rndr, bg) dt =
  Render.clear rndr;
  Render.set_scale rndr (1.0, 1.0);
  Render.copy rndr ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  static_render rndr font_object ();
  (* mobile_render rndr font_object width height dt (); *)
  Render.render_present rndr

let () =
  let renderer = init () in
  let rec main_loop last_t =
    let t = Timer.get_ticks () in
    (* let dt = t - last_t in *)
    event_loop ();
    draw renderer t;
    main_loop t
  in
  main_loop (Timer.get_ticks ())
