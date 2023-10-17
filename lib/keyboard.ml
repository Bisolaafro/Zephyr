open Sdl
open Sdlevent

type t = {
  mutable q : bool;
  mutable w : bool;
  mutable s : bool;
  mutable a : bool;
  mutable d : bool;
  mutable space : bool;
  mutable esc : bool;
}

type key =
  | Q
  | W
  | S
  | A
  | D
  | Space
  | Esc

let new_keyboard =
  {
    q = false;
    w = false;
    a = false;
    s = false;
    d = false;
    space = false;
    esc = false;
  }

let update_key k s t =
  let s_bool =
    match s with
    | Pressed -> true
    | Released -> false
  in
  begin
    match k with
    | Scancode.Q -> t.q <- s_bool
    | Scancode.W -> t.w <- s_bool
    | Scancode.S -> t.s <- s_bool
    | Scancode.A -> t.a <- s_bool
    | Scancode.D -> t.d <- s_bool
    | Scancode.SPACE -> t.space <- s_bool
    | Scancode.ESCAPE -> t.esc <- s_bool
    | _ -> ()
  end

let update_keyboard e t =
  match e with
  | KeyDown { ke_state = s; scancode = k; _ }
  | KeyUp { ke_state = s; scancode = k; _ } -> update_key k s t
  | _ -> ()

let query_key k t =
  match k with
  | Q -> t.q
  | W -> t.w
  | S -> t.s
  | A -> t.a
  | D -> t.d
  | Space -> t.space
  | Esc -> t.esc
