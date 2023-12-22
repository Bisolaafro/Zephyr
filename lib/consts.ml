open Spritesheet
open Animations

let width = 1512
let height = 9. /. 16. *. float_of_int width |> int_of_float
let accel = 0.000005 *. float_of_int height
let player_width, player_height = (1., 1.75)

let player_spritesheet =
  new_spritesheet "assets/punkgirly.png" 12 8 24 48 0 0 7 5

let vx = 0.0003 *. float_of_int height
let dvy = 0.00175 *. float_of_int height
let animation_table = Hashtbl.create 3
let anim_1 = animation "run" 4 0 5 1 6 100
let anim_2 = animation "run2" 4 0 5 1 6 100
let anim_3 = animation "idle" 8 0 3 1 6 100

let () =
  Hashtbl.add animation_table (get_name anim_1) anim_1;
  Hashtbl.add animation_table (get_name anim_2) anim_2;
  Hashtbl.add animation_table (get_name anim_3) anim_3
