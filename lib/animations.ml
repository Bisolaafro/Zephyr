type t = {
  name : string;
  row_start : int;
  col_start : int;
  col_end : int;
  rows : int;
  cols : int;
  speed : int;
}

let get_row_start t = t.row_start
let get_col_start t = t.col_start
let get_col_end t = t.col_end
let get_rows t = t.rows
let get_cols t = t.cols
let get_speed t = t.speed
let get_name t = t.name
let animation_table = Hashtbl.create 3

let animation name row_start col_start col_end rows cols speed : t =
  { name; row_start; col_start; col_end; rows; cols; speed }

let anim_1 = animation "walk" 0 0 5 1 6 4
let anim_2 = animation "excited" 2 0 5 1 6 4

let () =
  Hashtbl.add animation_table (get_name anim_1) anim_1;
  Hashtbl.add animation_table (get_name anim_2) anim_2
