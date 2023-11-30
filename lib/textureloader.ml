type image_format =
  | PNG
  | JPG
  | PCX
  | BMP
  | ICO
  | CUR
  | GIF
  | LBM
  | PNM
  | TIF
  | XCF
  | XPM
  | XV
  | WEBP

let load_file name mode = Sdlrwops.from_file ~filename:name ~mode

let load_texture name format ren : Sdltexture.t =
  let open Sdlimage in
  let r_op = load_file name "r" in

  let temp_surf =
    match format with
    | PNG -> load_png_rw r_op
    | JPG -> load_jpg_rw r_op
    | PCX -> load_pcx_rw r_op
    | BMP -> load_bmp_rw r_op
    | ICO -> load_ico_rw r_op
    | CUR -> load_cur_rw r_op
    | GIF -> load_gif_rw r_op
    | LBM -> load_lbm_rw r_op
    | PNM -> load_pnm_rw r_op
    | TIF -> load_pnm_rw r_op
    | XCF -> load_xcf_rw r_op
    | XPM -> load_xpm_rw r_op
    | XV -> load_xv_rw r_op
    | WEBP -> load_webp_rw r_op
  in
  (* Closes files after reading from it*)
  let _ = Sdlrwops.close r_op in
  let sdl_tex = Sdl.Texture.create_from_surface ren temp_surf in
  let _ = Sdlsurface.free temp_surf in
  sdl_tex
