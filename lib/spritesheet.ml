open Sdl
open TextureLoader

type t = {
  filename : string;
  rows : int;
  cols : int;
  w : int;
  h : int;
  mutable sprite_num_row : int;
  mutable sprite_num_col : int;
}

let get_image_format str =
  match str with
  | "png" -> PNG
  | "jpg" -> JPG
  | "pcx" -> PCX
  | "bmp" -> BMP
  | "ico" -> ICO
  | "cur" -> CUR
  | "gif" -> GIF
  | "lbm" -> LBM
  | "pnm" -> PNM
  | "tif" -> TIF
  | "xcf" -> XCF
  | "xpm" -> XPM
  | "xv" -> XV
  | "webp" -> WEBP
  | _ -> failwith "Unsupported Image Format"

let new_spritesheet filename rows cols w h =
  { filename; rows; cols; w; h; sprite_num_row = 0; sprite_num_col = 0 }

let load_image renderer sheet =
  let len_str = String.length sheet.filename in
  let sub_str = String.sub sheet.filename (len_str - 3) 3 in
  let final_str =
    if sub_str = "ebp" then "webp"
    else if sub_str = ".xv" then "xv"
    else sub_str
  in
  let img_format = get_image_format final_str in
  load_texture sheet.filename img_format renderer

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
