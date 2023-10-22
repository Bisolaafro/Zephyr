open Sdl

(* Define a type for the spritesheet *)
type t = {
  filename : string;
  rows : int;
  cols : int;
  w : int;
  h : int;
  mutable sprite_num_row : int;
  mutable sprite_num_col : int;
}

(* Define a function that creates a new spritesheet *)
let new_spritesheet filename rows cols w h =
  { filename; rows; cols; w; h; sprite_num_row = 0; sprite_num_col = 0 }

(* Define a function that loads the image file as a texture *)
let load_image renderer sheet =
  let surf = Surface.load_bmp sheet.filename in
  let tex = Texture.create_from_surface renderer surf in
  Surface.free surf;
  tex

let update_sprite_index sheet dt =
  if dt mod 10 = 0 && dt > 10 then
    let row, col =
      if sheet.sprite_num_row >= sheet.rows - 1 then (0, 0)
      else if sheet.sprite_num_col >= sheet.cols - 1 then
        (sheet.sprite_num_row + 1, 0)
      else (sheet.sprite_num_row, sheet.sprite_num_col + 1)
    in
    (row, col)
  else
    let row, col = (sheet.sprite_num_row, sheet.sprite_num_col) in
    (row, col)

let update_index_in_sheet sheet dt =
  match update_sprite_index sheet dt with
  | x, y ->
      sheet.sprite_num_row <- x;
      sheet.sprite_num_col <- y
