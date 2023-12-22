open Gameobject
open Yojson
open Tsdl.Sdl
open Tsdl_image.Image

type tileset_t = {
  mutable texture : texture option;
  mutable cols : int;
  mutable tile_side : int;
}

type t = {
  mutable tiles : (Gameobject.t * rect) option array option;
  mutable tilemap_cols : int;
  mutable tilemap_rows : int;
  mutable tile_side : int;
  tileset : tileset_t;
}

let new_tilemap () =
  {
    tiles = None;
    tilemap_cols = 0;
    tilemap_rows = 0;
    tile_side = 0;
    tileset = { texture = None; cols = 0; tile_side = 0 };
  }

let extract_list json =
  let open Basic.Util in
  let layers_list = json |> member "layers" |> to_list in
  let first_layer = List.hd layers_list in
  let data_list = first_layer |> member "data" |> to_list in
  List.map to_int data_list

let extract_dim json =
  let open Basic.Util in
  let layers_list = json |> member "layers" |> to_list in
  let first_layer = List.hd layers_list in
  let cols = first_layer |> member "width" |> to_int in
  let rows = first_layer |> member "height" |> to_int in
  (cols, rows)

let extract_tileset_filename json =
  let open Basic.Util in
  let tilesets_list = json |> member "tilesets" |> to_list in
  let first_tileset = List.hd tilesets_list in
  first_tileset |> member "source" |> to_string

let extract_tileset_texture r tileset_json =
  let open Basic.Util in
  let filename = tileset_json |> member "image" |> to_string in
  load_texture r filename |> Result.get_ok

let extract_tileset_cols tileset_json =
  let open Basic.Util in
  let cols = tileset_json |> member "columns" |> to_int in
  cols

let extract_tileset_tile_side tileset_json =
  let open Basic.Util in
  let side = tileset_json |> member "tilewidth" |> to_int in
  side

let rec init_tilemap_helper ?(i = 0) lst t =
  match lst with
  | [] -> ()
  | hd :: tl ->
      if hd <> 0 then begin
        let tile_code = hd - 1 in
        let tiles = Option.get t.tiles in
        let x0 = float_of_int (i mod t.tilemap_cols * t.tile_side) in
        let y0 =
          float_of_int (Consts.height - (i / t.tilemap_cols * t.tile_side))
          -. float_of_int t.tile_side
        in
        let x1 = x0 +. float_of_int t.tile_side in
        let y1 = y0 +. float_of_int t.tile_side in
        let src_x = tile_code mod t.tileset.cols * t.tileset.tile_side in
        let src_y = tile_code / t.tileset.cols * t.tileset.tile_side in
        let src_rect =
          Rect.create ~x:src_x ~y:src_y ~w:t.tileset.tile_side
            ~h:t.tileset.tile_side
        in
        let tile_obj = Gameobject.new_object () in
        begin
          Gameobject.init_object
            (Option.get t.tileset.texture)
            (x0, y0) (x1, y1) false tile_obj;
          Array.set tiles i (Some (tile_obj, src_rect))
        end
      end;
      init_tilemap_helper ?i:(Some (i + 1)) tl t

let init_tilemap file r t =
  let json = Basic.from_file file in
  let lst = extract_list json in
  let tilemap_cols, tilemap_rows = extract_dim json in
  let tileset_json = Basic.from_file (extract_tileset_filename json) in
  let tileset_texture = extract_tileset_texture r tileset_json in
  let tileset_cols = extract_tileset_cols tileset_json in
  let tileset_tile_side = extract_tileset_tile_side tileset_json in
  let tile_side = Consts.width / tilemap_cols in
  t.tiles <- Some (Array.make (tilemap_cols * tilemap_rows) None);
  t.tilemap_cols <- tilemap_cols;
  t.tilemap_rows <- tilemap_rows;
  t.tile_side <- tile_side;
  t.tileset.texture <- Some tileset_texture;
  t.tileset.cols <- tileset_cols;
  t.tileset.tile_side <- tileset_tile_side;
  init_tilemap_helper lst t

let rec draw_tilemap r ?(i = 0) t =
  let tiles = Option.get t.tiles in
  if i = Array.length tiles then ()
  else begin
    let tile = Array.get tiles i in
    if tile <> None then begin
      let obj, src_raw = Option.get tile in
      let src = Some src_raw in
      Gameobject.draw_object ?src r obj
    end;
    draw_tilemap r ?i:(Some (i + 1)) t
  end
