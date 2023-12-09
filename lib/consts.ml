open Spritesheet
open Animations

let width, height = (1920, 1080)
let accel = 0.005
let player_width, player_height = (90., 150.)
let x0, y0 = (100., 600.)

let player_spritesheet =
  new_spritesheet "assets/punkgirly.png" 12 8 24 48 0 0 7 5

let animation_table = Hashtbl.create 3
let anim_1 = animation "run" 4 0 5 1 6 100
let anim_2 = animation "run2" 4 0 5 1 6 100
let anim_3 = animation "idle" 8 0 3 1 6 100

let () =
  Hashtbl.add animation_table (get_name anim_1) anim_1;
  Hashtbl.add animation_table (get_name anim_2) anim_2;
  Hashtbl.add animation_table (get_name anim_3) anim_3

let main_enabled = true
