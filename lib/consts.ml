let width = 1920
let height = 1080
let ground_level = 70.
let accel = 0.005

let ( % ) x y =
  let result = Float.rem x y in
  if result >= 0. then result else result +. y
