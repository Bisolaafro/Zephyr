(** Module that facilitates loading of texture from images, using SDLImage
    bindings to do so. *)

(** File formats that this module supports. *)
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

(** [load_texture name format rend] creates a texture using the renderer [ren].
    The picture is initialized from an [image] file name. Requires: the file
    extension of the image referenced in [name] must match that of [format].*)
val load_texture : string -> image_format -> Sdlrender.t -> Sdltexture.t
