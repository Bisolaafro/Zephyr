type t

(** Returns new player *)
val new_spritesheet : string -> int -> int -> int -> int -> t

(** Initializes player with given texture *)
val load_image : Sdltype.renderer -> t -> Sdltexture.t

(** Gets the row and col of the current sprite in the sheet*)
val update_sprite_index : t -> int -> int * int

(** Updates the current sprite index*)
val update_index_in_sheet : t -> int -> unit
