(** Textureloader module. Facilitates loading textures from images using
    SDLImage bindings. *)

(** Supported file formats. *)
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

(** [load_texture fl format rndr] creates a texture using the renderer [rndr].
    The picture is initialized from an [fl] file name. Requires: the file
    extension of the image referenced in [fl] must match that of [format].*)
val load_texture : string -> image_format -> Sdlrender.t -> Sdltexture.t
