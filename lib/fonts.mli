(** Fonts module. Provides a type to represent text labels and functions to
    manipulate them. *)

open Tsdl.Sdl
open Tsdl_ttf.Ttf

(** Represents a text label. *)
type t

(** [quit_font ()] shuts down the SDL_ttf library and frees any resources
    allocated by it. *)
val quit_font : unit -> unit

(** [new_font_object ()] creates a new font object. *)
val new_font_object : unit -> t

(** [init_font_object r fl txt (xc, yc) sz cl a t] initializes a font object [t]
    to be drawn on renderer [r], using the font file [fl], with text [txt],
    centered at [(xc, yc)], with font size [sz], color [cl], and alpha [a]. *)
val init_font_object :
  renderer ->
  string ->
  string ->
  float * float ->
  event_type ->
  color ->
  event_type ->
  t ->
  unit

(** [draw_font_object r t] renders font object [t] to renderer [r]. *)
val draw_font_object : renderer -> t -> unit

(** [change_alpha a t] changes the alpha value of font object [t]. *)
val change_alpha : int -> t -> unit
