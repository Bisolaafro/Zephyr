type t = {
  mutable x : float;
  mutable y : float;
}

let zero _ = { x = 0.; y = 0. }
let add v1 v2 = { x = v1.x +. v2.x; y = v1.y +. v2.y }

let scale n v =
  v.x <- n *. v.x;
  v.y <- n *. v.y

let length v = sqrt ((v.x *. v.x) +. (v.y *. v.y))

let normalize v =
  let len = length v in
  v.x <- v.x /. len;
  v.y <- v.y /. len
