(* open Final *)
open Sdlevent
open Sdl

(* Redefine mod operator because it has strange behavior in OCaml *)
let ( mod ) x y =
  let result = x mod y in
  if result >= 0 then result else result + y

(* Simple vector type *)
type vector = {
  mutable x : float;
  mutable y : float;
}

(* Simple player type *)
type player_type = {
  pos : vector;
  vel : vector;
  mutable rect : Sdlrect.t;
  mutable on_ground : bool;
}

(* Some game constants *)
let width, height = (1920, 1080)
let ground_level = 256.
let bg_rect = Rect.make4 ~x:0 ~y:0 ~w:1920 ~h:1080
let caml_rect = Rect.make4 ~x:0 ~y:0 ~w:256 ~h:256

(* PLAYER *)
let player =
  {
    pos = { x = 0.; y = ground_level };
    vel = { x = 0.; y = 0. };
    rect = Rect.make4 ~x:0 ~y:0 ~w:256 ~h:256;
    on_ground = true;
  }

(* Keyboard state type *)
type keys = {
  mutable w : bool;
  mutable s : bool;
  mutable a : bool;
  mutable d : bool;
  mutable space : bool;
}

(* KEYBOARD STATE *)
let key_state = { w = false; a = false; s = false; d = false; space = false }

(* Process input helper: quit game *)
let quit () =
  Sdl.quit ();
  exit 0

(* Process input helper: update keyboard state *)
let update_key_state k state =
  let s =
    match state with
    | Pressed -> true
    | Released -> false
  in
  begin
    match k with
    | Keycode.W -> key_state.w <- s
    | Keycode.A -> key_state.a <- s
    | Keycode.S -> key_state.s <- s
    | Keycode.D -> key_state.d <- s
    | Keycode.Space -> key_state.space <- s
    | Keycode.Q | Keycode.Escape ->
        Sdl.quit ();
        exit 0
    | _ -> ()
  end

(* Process input helper: call other helpers *)
let proc_events = function
  | KeyDown { scancode = Scancode.ESCAPE; _ } | Quit _ -> quit ()
  | KeyDown { ke_state = state; keycode = k; _ }
  | KeyUp { ke_state = state; keycode = k; _ } -> update_key_state k state
  | _ -> ()

(* PROCESS INPUT *)
let rec event_loop () =
  match Event.poll_event () with
  | None -> ()
  | Some ev ->
      proc_events ev;
      event_loop ()

(* UPDATE GAME *)
let update_state dt =
  let float_dt = float_of_int dt in
  player.on_ground <- player.pos.y <= ground_level;
  let accel = 0.005 in
  if key_state.w then player.pos.y <- player.pos.y +. 0.;
  if key_state.s then player.pos.y <- player.pos.y -. 0.;
  if key_state.a then (
    player.pos.x <- player.pos.x -. 4.;
    player.vel.x <- -0.1);
  if key_state.d then (
    player.pos.x <- player.pos.x +. 4.;
    player.vel.x <- 0.1);
  if key_state.space && player.on_ground then (
    player.vel.x <- 0.;
    player.vel.y <- 1.;
    player.on_ground <- false);
  if player.on_ground then (
    player.vel.y <- 0.;
    player.vel.x <- 0.;
    player.pos.y <- ground_level)
  else (
    player.pos.y <-
      player.pos.y +. (player.vel.y *. float_dt) -. (accel *. (float_dt ** 2.));
    player.vel.y <- player.vel.y -. (accel *. float_dt));
  player.pos.x <- player.pos.x +. (player.vel.x *. float_dt)

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
  (rndr, caml, bg)

(* DRAW GAME *)
let draw (rndr, caml, bg) =
  player.rect <-
    Rect.make4
      ~x:(int_of_float player.pos.x mod width)
      ~y:(int_of_float (float_of_int height -. player.pos.y))
      ~w:256 ~h:256;
  Render.clear rndr;
  Render.set_scale rndr (1.0, 1.0);
  Render.copy rndr ~texture:bg ~src_rect:bg_rect ~dst_rect:bg_rect ();
  Render.copy rndr ~texture:caml ~src_rect:caml_rect ~dst_rect:player.rect ();
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
