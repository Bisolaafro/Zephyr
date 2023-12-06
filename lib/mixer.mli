(** This module wraps around the library [Tsdl_mixer] library, which
    interoperates with the other Ocaml bindings for [SDL] titled [Tsdl].
    Miraculously, [Tsdl_mixer] is able to function in tandem with [OcamlSDL2],
    and this module facilitates playing music and sound effects, amongst other
    things. *)

(** Audio formats supported by the [SDL_mixer] library. More information about
    their specifics can be found in the SDL documentation. *)
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

(** Flags passed to [init] that tell SDL_mixer what libraries to load.*)
type init_flag =
  | FLAC
  | MOD
  | MP3
  | OGG
  | MID
  | OPUS
  | WAVPACK

(** Exception that is raised when files could not be read. *)
exception ReadError of string

(** This function loads dynamic libraries that SDL_mixer needs, and prepares
    them for use. Unlike other SDL libraries, this function call is optional.
    For more information, see the API documentation of the function. Ideally,
    should not even use this function.*)
val init : init_flag list -> unit

(** Module that facilitates music playing. That is, a single music channel is
    usually played for an expended period of time, usually multiple times. *)
module type MusicModType = sig
  (* A loaded music file that can be played. *)
  type t

  (** [play_music m n] plays the music object [m], and plays it in a loop [n]
      times. That is, [n=0] means play music once and then stop. *)
  val play_music : t -> int -> unit

  (** [free_music m] frees the music object [m]. If the music object is
      currently playing, it will be stopped. Once a music object is not being
      used, you should free it. *)
  val free_music : t -> unit

  (** [load_music m] creates a music object by loading it from the directory
      provided in [m]. This must happen after [open_audio] has been called.
      Raises: [ReadError] if the file could not be read. *)
  val load_music : string -> t

  (** [music_vol n] sets the volume of the music channel and returns the
      previous value. The maximum volume is [128], anything higher than that
      will simply default to [128]. Passing a negative number will simply return
      the current volume without changing it. *)
  val music_vol : int -> int
end

(** Implementation of MusicModType *)
module Music : MusicModType

(** A chunk is the other type of audio data structure, in addition to
    [MusicModType], which is meant to be a file completely decoded into memory
    up front. In contrast to [MusicModType.t], an indefinite number can play at
    a time.*)
module type ChunkModType = sig
  (** A loaded chunk file that can be played. These usually are [.wav] files. *)
  type t

  (** [load_wav s] loads a supported audio file into a chunk, where [s] is the
      location of the file. Raises: [ReadError] if the file could not be read. *)
  val load_wav : string -> t

  (** [chunk_vol ch vol] sets the volume of chunk [ch] to [vol] and returns the
      previous value. [vol] is usually between [0] and [128]. Passing a negative
      number will simply return the current volume, while something greater will
      default to [128]. *)
  val chunk_vol : t -> int -> int
end

(*** Implementation of ChunkModType*)
module Chunk : ChunkModType

(** [open_audio freq format chan chunk] opens the default audio device for
    playback. In other words, this function is the actual thing that makes
    'sound.'

    - Parameter [freq]: the frequency to playback audio at (in Hz) (44100 is
      good)

    - Parameter [format]: one of [SDL]'s audio format values. Should usually use
      [MIX_DEFAULT_FORMAT]

    - Parameter [chan]: number of channels (1 is mono, 2 is stereo), usually
      choose [1] or [2].

    - Parameter [chunk]: audio buffer size in sample FRAMES. (2048 is good) *)
val open_audio : int -> audio_format -> int -> int -> unit

(** [play_channel c chunk l] plays the chunk [chunk] on the channel number [c]
    [l] times. Passing [c] as [-1] will play the chunk on the first available
    channel. *)
val play_channel : int -> Chunk.t -> int -> unit

(** [allocate num] allocates [num] channels for playing audio track and returns
    the number itself. Note that this is distinct from the mono,stereo, etc,
    meaning of channel. This refers to the number of tracks that can
    simultaneously be played. *)
val allocate_channels : int -> int

(** [volume ch vol] sets the volume of the channel [ch] to [vol]. Note that
    [vol] is usually between [0] and [128]. Passing [-1] for vol will simply
    return the current volume without making any changes.*)
val volume : int -> int -> int

(** [playing n] is [Some true] if there is a chunk currently playing in channel
    [n], false otherwise. If [n] is greater than the current number of channels,
    [playing n] is [None]. *)
val playing : int -> bool option

(** A ChannelTrackerType module provides functionality that allows the user to
    easily add sound effects to gameobjects by abstracting away the *)
module type ChannelTrackerType = sig
  (** Keeps track of the channels currently allocated in the game.*)
  type t

  (** [create_tracker num] creates a tracker that keeps track of [num] channels.
      This functions independently of the [allocate_channels] function.
      Requires: [num] be the number of allocated channels using
      [allocate_channels]. *)
  val create_tracker : int -> t

  (** [get_reserved t] is the number of tracks reserved for all game objects in
      the tracker [t]. *)
  val get_reserved : t -> int

  (** [reserve_channels t obj num] allocates [num] channels for the [obj]
      GameObject on the tracker [t]. Requires: adding [num] to the already
      reserved channels must not exceed the total number of tracks already
      allocated. *)
  val reserve_channels : t -> Gameobject.GameObject.t -> int -> unit

  (** [get_obj_alloc t obj] returns a list with channels allocated to the game
      object [obj]. Note that these numbers can be safely used with
      [play_channel]. In fact, this is the intended use. *)
  val get_obj_alloc : t -> Gameobject.GameObject.t -> int list option

  (** [free_obj tr obj] removes the channel reservation of [obj] and makes it
      available to other objects.*)
  val free_obj : t -> Gameobject.GameObject.t -> unit
end

(** Implementation of ChannelTrackerType *)
module ChannelTracker : ChannelTrackerType
