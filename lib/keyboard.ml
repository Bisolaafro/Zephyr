open Tsdl.Sdl

type status =
  | Pressed
  | Down
  | Released
  | Up

type t = (scancode, status) Hashtbl.t

let event = Event.create ()
let new_keyboard () : t = Hashtbl.create 10

let print_keyboard t =
  Hashtbl.iter
    (fun x y ->
      Printf.printf "%s -> %s\n" (string_of_int x)
        ((fun x ->
           match x with
           | Up -> "Up"
           | Down -> "Down"
           | Pressed -> "Pressed"
           | Released -> "Released")
           y))
    t;
  print_endline "----"

let update_key k s t =
  let status = if s = Event.key_down then Pressed else Released in
  Hashtbl.replace t k status

let update_status t =
  let change_key_status k st =
    let new_st =
      match st with
      | Pressed -> Down
      | Released -> Up
      | st -> st
    in
    Hashtbl.replace t k new_st
  in
  Hashtbl.iter change_key_status t

let handle_keyboard_event e t =
  let s, k, r =
    ( Event.get e Event.typ,
      Event.get e Event.keyboard_scancode,
      Event.get e Event.keyboard_repeat )
  in
  if (s = Event.key_down || s = Event.key_up) && r = 0 then update_key k s t;
  if s = Event.quit then failwith "Program terminated unexpectedly."

let rec event_loop t =
  match poll_event (Some event) with
  | false -> ()
  | true ->
      handle_keyboard_event event t;
      event_loop t

let update_keyboard t =
  update_status t;
  event_loop t

let query_key k t = try Hashtbl.find t k with _ -> Up
