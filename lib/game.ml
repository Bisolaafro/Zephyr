open Sdl
open Sdlevent

type t = {
  window : Sdlwindow.t ref;
  renderer : Sdltype.renderer ref;
  mutable running : bool;
}

let init title pos dim flags =
  Sdl.init [ `EVERYTHING ];
  let message = Sdlerror.get_error () in
  let this_running = if message = "" then true else false in
  print_string message;
  let xpos, ypos = pos in
  let width, height = dim in
  let this_window =
    Window.create ~pos:(xpos, ypos) ~title ~dims:(width, height) ~flags |> ref
  in
  let this_renderer =
    Render.create_renderer ~win:this_window.contents ~index:(-1)
      ~flags:[ Render.Accelerated ]
    |> ref
  in
  let _ =
    Render.set_draw_color this_renderer.contents ~rgb:(255, 255, 255) ~a:255
  in
  { window = this_window; renderer = this_renderer; running = this_running }

let handle_event_helper = function
  | KeyDown { keycode = Keycode.Q; _ }
  | KeyDown { keycode = Keycode.Escape; _ }
  | KeyDown { scancode = Scancode.ESCAPE; _ }
  | Quit _ ->
      Sdl.quit ();
      exit 0
  | _ -> ()

let handle_events _ =
  match Sdlevent.poll_event () with
  | None -> ()
  | Some s -> handle_event_helper s

let render game =
  Sdlrender.clear game.renderer.contents;
  Sdlrender.render_present game.renderer.contents

let running game = game.running

let clean () =
  Sdl.quit ();
  exit 0

(* TODO: implement this*)
let update _ = ()
