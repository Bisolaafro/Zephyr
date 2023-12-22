open Consts
open Fonts
open Tsdl.Sdl

type transition_t =
  | None
  | FadeOut
  | FadeIn

type font_renderable_t = { font_obj : Fonts.t }

type image_renderable_t = {
  mutable texture : texture option;
  mutable dst_rect : rect option;
}

type renderable_t =
  | Font of font_renderable_t
  | Image of image_renderable_t

type individual_component_t = {
  mutable fade_t : int;
  mutable fade_total : int;
  mutable active : bool;
  mutable transition : bool;
  mutable transition_type : transition_t;
  renderable : renderable_t;
}

type t =
  | Component of individual_component_t
  | Stage of t list

let new_image_component () =
  Component
    {
      fade_t = 0;
      fade_total = 0;
      active = false;
      transition = false;
      transition_type = None;
      renderable = Image { texture = None; dst_rect = None };
    }

let new_font_component () =
  Component
    {
      fade_t = 0;
      fade_total = 0;
      active = false;
      transition = false;
      transition_type = None;
      renderable = Font { font_obj = new_font_object () };
    }

let new_stage l = Stage l

let init_image_component tx pos dims t =
  match t with
  | Component c -> begin
      match c.renderable with
      | Image i ->
          set_texture_blend_mode tx Blend.mode_blend |> ignore;
          set_texture_alpha_mod tx 0 |> ignore;
          i.texture <- Some tx;
          i.dst_rect <-
            Some (Rect.create (fst pos) (snd pos) (fst dims) (snd dims))
      | Font _ -> failwith "Cannot initialize font as image."
    end
  | Stage _ -> failwith "Cannot apply to stage."

let init_font_component r fl txt (xc, yc) sz cl a t =
  match t with
  | Component c -> begin
      match c.renderable with
      | Font f -> init_font_object r fl txt (xc, yc) sz cl a f.font_obj
      | Image _ -> failwith "Cannot initialize image as font."
    end
  | Stage _ -> failwith "Cannot apply to stage."

let rec show ms t =
  match t with
  | Component c ->
      if (not c.active) && not c.transition then begin
        c.transition_type <- FadeIn;
        c.fade_t <- ms;
        c.fade_total <- ms;
        c.transition <- true
      end
  | Stage s -> List.iter (show ms) s

let rec hide ms t =
  match t with
  | Component c ->
      if c.active && not c.transition then begin
        c.transition_type <- FadeOut;
        c.fade_t <- ms;
        c.fade_total <- ms;
        c.transition <- true
      end
  | Stage s -> List.iter (hide ms) s

let active t =
  match t with
  | Component c -> c.active
  | Stage _ -> raise (Invalid_argument "Cannot apply to stage.")

let rec update_component dt t =
  match t with
  | Component c ->
      if c.transition then begin
        if c.fade_t > 0 then c.fade_t <- c.fade_t - dt
        else begin
          c.fade_t <- 0;
          c.active <- not c.active;
          c.transition <- false;
          c.transition_type <- None
        end
      end
  | Stage s -> List.iter (update_component dt) s

let draw_renderable r alpha renderable =
  match renderable with
  | Image i ->
      let tx, dst = (Option.get i.texture, Option.get i.dst_rect) in
      set_texture_alpha_mod tx alpha |> ignore;
      render_copy ~dst r tx |> ignore
  | Font f ->
      change_alpha alpha f.font_obj;
      draw_font_object r f.font_obj

let draw_individual_component r c =
  let alpha =
    let f target sign =
      if c.fade_t <= 0 then target
      else
        sign target
          (int_of_float
             (float_of_int c.fade_t /. float_of_int c.fade_total *. 255.))
    in
    match c.transition_type with
    | FadeIn -> f 255 ( - )
    | FadeOut -> f 0 ( + )
    | None -> if c.active then 255 else 0
  in
  draw_renderable r alpha c.renderable

let rec draw_component r t =
  match t with
  | Component c -> draw_individual_component r c
  | Stage s -> List.iter (draw_component r) s
