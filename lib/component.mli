(** Component module. Wraps SDL textures to enable simple drawing, fading in or
    out. *)

open Tsdl.Sdl

(** Represents a screen component such as an image, a piece of text, etc. *)
type t

(** [new_image_component ()] returns a new, empty image component. *)
val new_image_component : unit -> t

(** [new_font_component ()] returns a new, empty font component. *)
val new_font_component : unit -> t

(** [new_stage lst] returns a stage component from a list [lst] of components. *)
val new_stage : t list -> t

(** [init_image_component tx pos dims t] initializes an image component [t] with
    the given texture [tx], at position [pos] and with dimensions [dims]. *)
val init_image_component : texture -> int * int -> int * int -> t -> unit

(** [init_font_object r fl txt (xc, yc) sz cl a t] initializes a font component
    [t] to be drawn on renderer [r], using the font file [fl], with text [txt],
    centered at [(xc, yc)], with font size [sz], color [cl], and alpha [a]. *)
val init_font_component :
  renderer ->
  string ->
  string ->
  float * float ->
  event_type ->
  color ->
  event_type ->
  t ->
  unit

(** [show ms t] shows the component [t] on the screen, fading in for [ms]
    milliseconds. If [ms] is zero, then the component is shown instantly. *)
val show : int -> t -> unit

(** [hide ms t] hides the component [t] on the screen, fading out for [ms]
    milliseconds. If [ms] is zero, then the component is hidden instantly. *)
val hide : int -> t -> unit

(** [active t] returns whether the component is active (i.e. being shown on
    screen). *)
val active : t -> bool

(** [update_component dt t] updates the component [t] with time [dt] elapsed
    since the last update. *)
val update_component : int -> t -> unit

(** [draw_component r t] draws the component [t] to the renderer [r]. *)
val draw_component : renderer -> t -> unit
