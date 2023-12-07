type audio_format =
  | AUDIO_S8
  | AUDIO_U8
  | AUDIO_S16LSB
  | AUDIO_S16MSB
  | AUDIO_S16SYS
  | AUDIO_U16
  | AUDIO_S32LSB
  | AUDIO_S32MSB
  | AUDIO_S32SYS
  | AUDIO_S32
  | AUDIO_F32LSB
  | AUDIO_F32MSB
  | AUDIO_F32SYS
  | AUDIO_F32
  | MIX_DEFAULT_FORMAT

type init_flag =
  | FLAC
  | MOD
  | MP3
  | OGG
  | MID
  | OPUS
  | WAVPACK

let init_flag_convert =
  let open Tsdl_mixer.Mixer.Init in
  function
  | FLAC -> flac
  | MOD -> modplug
  | MP3 -> mp3
  | OGG -> ogg
  | _ -> failwith "NOT SUPPORTED"

let my_format_to_tsdl =
  let open Tsdl.Sdl.Audio in
  function
  | AUDIO_S8 -> s8
  | AUDIO_U8 -> u8
  | AUDIO_S16LSB -> s16_lsb
  | AUDIO_S16MSB -> s16_msb
  | AUDIO_S16SYS -> s16_sys
  | AUDIO_U16 -> u16
  | AUDIO_S32LSB -> s32_lsb
  | AUDIO_S32MSB -> s32_msb
  | AUDIO_S32SYS -> s32_sys
  | AUDIO_S32 -> s32
  | AUDIO_F32LSB -> f32_lsb
  | AUDIO_F32MSB -> f32_msb
  | AUDIO_F32SYS -> f32_sys
  | AUDIO_F32 -> f32
  | MIX_DEFAULT_FORMAT -> s16_lsb

(* Init function *)
let init lst =
  List.fold_left
    (fun _ x -> ignore (Tsdl_mixer.Mixer.init (init_flag_convert x)))
    () lst

(* Exception*)
exception ReadError of string

(**** Module TYPES ****)
module type MusicModType = sig
  type t

  val play_music : t -> int -> unit
  val free_music : t -> unit
  val load_music : string -> t
  val music_vol : int -> int
  val fade_out_music : int -> unit option
end

module type ChunkModType = sig
  type t

  val load_wav : string -> t
  val chunk_vol : t -> int -> int
end

module type ChannelTrackerType = sig
  type t

  val create_tracker : int -> t
  val get_reserved : t -> int
  val reserve_channels : t -> Gameobject.GameObject.t -> int -> unit
  val get_obj_alloc : t -> Gameobject.GameObject.t -> int list option
  val free_obj : t -> Gameobject.GameObject.t -> unit
end

(** END OF TYPES **)

(* Implementation of Music*)

module Music : MusicModType = struct
  type t = Tsdl_mixer.Mixer.music

  let play_music t n =
    match Tsdl_mixer.Mixer.play_music t n with
    | Ok _ -> ()
    | Error (`Msg str) -> raise (ReadError str)

  let free_music = Tsdl_mixer.Mixer.free_music

  let load_music str =
    match Tsdl_mixer.Mixer.load_mus str with
    | Ok s -> s
    | Error (`Msg str) -> raise (ReadError str)

  let music_vol = Tsdl_mixer.Mixer.volume_music

  let fade_out_music ms =
    match Tsdl_mixer.Mixer.fade_out_music ms with
    | Ok _ -> Some ()
    | Error _ -> None
end

(* End of Music implementation*)

module Chunk : ChunkModType with type t = Tsdl_mixer.Mixer.chunk = struct
  type t = Tsdl_mixer.Mixer.chunk

  let load_wav str =
    match Tsdl_mixer.Mixer.load_wav str with
    | Ok s -> s
    | Error (`Msg str) -> raise (ReadError str)

  let chunk_vol = Tsdl_mixer.Mixer.volume_chunk
end

module ChannelTracker : ChannelTrackerType = struct
  type t = {
    size : int;
    mutable reserved : int;
    arr : Gameobject.GameObject.t ref option Array.t;
    hash : (Gameobject.GameObject.t, int list) Hashtbl.t;
  }

  let create_tracker n =
    {
      size = n;
      reserved = 0;
      arr = Array.make n None;
      hash = Hashtbl.create 35;
    }

  let get_reserved { reserved } = reserved

  let update_lst hash obj num =
    match Hashtbl.find_opt hash obj with
    | None -> Hashtbl.replace hash obj [ num ]
    | Some t -> Hashtbl.replace hash obj (num :: t)

  let reserve_channels t obj num =
    let num_ref = ref num in
    let ind = ref 0 in
    let _ = t.reserved <- t.reserved + num in
    while !num_ref > 0 do
      let _ =
        match t.arr.(!ind) with
        | None ->
            t.arr.(!ind) <- Some (ref obj);
            update_lst t.hash obj num;
            num_ref := !num_ref - 1
        | Some _ -> ()
      in
      ind := !ind + 1
    done

  let get_obj_alloc { hash } obj = Hashtbl.find_opt hash obj

  (* Think about structural or physical comparison, currently using physical *)
  let compare_obj_in_arr obj1 obj2 =
    match obj1 with
    | Some obj1_unwr -> !obj1_unwr == obj2
    | _ -> false

  let free_obj t obj =
    Array.iteri
      (fun i obj_wr ->
        if compare_obj_in_arr obj_wr obj then t.arr.(i) <- None;
        t.reserved <- t.reserved - 1)
      t.arr
end

let play_channel c chunk l =
  match Tsdl_mixer.Mixer.play_channel c chunk l with
  | Ok _ -> ()
  | Error _ -> failwith "SOMETHING HAPPENED WHEN PLAYING CHANNEL"

let allocate_channels = Tsdl_mixer.Mixer.allocate_channels
let volume = Tsdl_mixer.Mixer.volume

let playing n =
  let num_chans = allocate_channels ~-1 in
  if n >= 0 && n < num_chans - 1 then Some (Tsdl_mixer.Mixer.playing (Some n))
  else None

let open_audio freq format chan chunk =
  ignore
    (Tsdl_mixer.Mixer.open_audio freq (my_format_to_tsdl format) chan chunk)
