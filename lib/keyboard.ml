open Sdl
open Sdlevent
open Key

(* Might be better to just use an array?*)
type t = {
  (* This represents the state of the letter. i.e, if t.q is true then the key q
     is currently being pressed. *)
  mutable zero : bool;
  mutable one : bool;
  mutable two : bool;
  mutable three : bool;
  mutable four : bool;
  mutable five : bool;
  mutable six : bool;
  mutable seven : bool;
  mutable eight : bool;
  mutable nine : bool;
  mutable q : bool;
  mutable w : bool;
  mutable e : bool;
  mutable r : bool;
  mutable t : bool;
  mutable y : bool;
  mutable u : bool;
  mutable i : bool;
  mutable o : bool;
  mutable p : bool;
  mutable a : bool;
  mutable s : bool;
  mutable d : bool;
  mutable f : bool;
  mutable g : bool;
  mutable h : bool;
  mutable j : bool;
  mutable k : bool;
  mutable l : bool;
  mutable z : bool;
  mutable x : bool;
  mutable c : bool;
  mutable v : bool;
  mutable b : bool;
  mutable n : bool;
  mutable m : bool;
  mutable space : bool;
  mutable esc : bool;
  mutable enter_main : bool;
}

type key = Key.key

(* | Q | W | S | A | D | Space | Esc *)

let new_keyboard : t =
  {
    zero = false;
    one = false;
    two = false;
    three = false;
    four = false;
    five = false;
    six = false;
    seven = false;
    eight = false;
    nine = false;
    q = false;
    w = false;
    e = false;
    r = false;
    t = false;
    y = false;
    u = false;
    i = false;
    o = false;
    p = false;
    a = false;
    s = false;
    d = false;
    f = false;
    g = false;
    h = false;
    j = false;
    k = false;
    l = false;
    z = false;
    x = false;
    c = false;
    v = false;
    b = false;
    n = false;
    m = false;
    space = false;
    esc = false;
    enter_main = false;
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
    | Scancode.E -> t.e <- s_bool
    | Scancode.R -> t.r <- s_bool
    | Scancode.T -> t.t <- s_bool
    | Scancode.Y -> t.y <- s_bool
    | Scancode.U -> t.u <- s_bool
    | Scancode.I -> t.i <- s_bool
    | Scancode.O -> t.o <- s_bool
    | Scancode.P -> t.p <- s_bool
    | Scancode.A -> t.a <- s_bool
    | Scancode.S -> t.s <- s_bool
    | Scancode.D -> t.d <- s_bool
    | Scancode.F -> t.f <- s_bool
    | Scancode.G -> t.g <- s_bool
    | Scancode.H -> t.h <- s_bool
    | Scancode.J -> t.j <- s_bool
    | Scancode.K -> t.k <- s_bool
    | Scancode.L -> t.l <- s_bool
    | Scancode.Z -> t.z <- s_bool
    | Scancode.X -> t.x <- s_bool
    | Scancode.C -> t.c <- s_bool
    | Scancode.V -> t.v <- s_bool
    | Scancode.B -> t.b <- s_bool
    | Scancode.N -> t.n <- s_bool
    | Scancode.M -> t.m <- s_bool
    | Scancode.Num0 -> t.zero <- s_bool
    | Scancode.Num1 -> t.one <- s_bool
    | Scancode.Num2 -> t.two <- s_bool
    | Scancode.Num3 -> t.three <- s_bool
    | Scancode.Num4 -> t.four <- s_bool
    | Scancode.Num5 -> t.five <- s_bool
    | Scancode.Num6 -> t.six <- s_bool
    | Scancode.Num7 -> t.seven <- s_bool
    | Scancode.Num8 -> t.eight <- s_bool
    | Scancode.Num9 -> t.nine <- s_bool
    | Scancode.SPACE -> t.space <- s_bool
    | Scancode.ESCAPE -> t.esc <- s_bool
    | Scancode.RETURN -> t.enter_main <- s_bool
    | _ -> print_string "Non alpha-numeric key pressed!"
  end

let update_keyboard e t =
  match e with
  | KeyDown { ke_state = s; scancode = k; _ }
  | KeyUp { ke_state = s; scancode = k; _ } -> update_key k s t
  | _ -> ()

let query_key k t : bool =
  match k with
  | Zero -> t.zero
  | One -> t.one
  | Two -> t.two
  | Three -> t.three
  | Four -> t.four
  | Five -> t.five
  | Six -> t.six
  | Seven -> t.seven
  | Eight -> t.eight
  | Nine -> t.nine
  | Q -> t.q
  | W -> t.w
  | E -> t.e
  | R -> t.r
  | T -> t.t
  | Y -> t.y
  | U -> t.u
  | I -> t.i
  | O -> t.o
  | P -> t.p
  | A -> t.a
  | S -> t.s
  | D -> t.d
  | F -> t.f
  | G -> t.g
  | H -> t.h
  | J -> t.j
  | K -> t.k
  | L -> t.l
  | Z -> t.z
  | X -> t.x
  | C -> t.c
  | V -> t.v
  | B -> t.b
  | N -> t.n
  | M -> t.m
  | Space -> t.space
  | Esc -> t.esc
  | EnterMain -> t.enter_main
