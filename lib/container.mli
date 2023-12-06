(** Module that facilitates playing sound effects with some logic. For our game,
    this allows to reproduce sounds in sequence, such as walking, so that
    effects don't sound repetitive.*)

(** Type of container, which is an object that contains [Chunk.t] objects that
    can be played on demand. *)
type t

(** [empty ()] is the container with no chunks. *)
val empty : unit -> t

(** [size con] is the number of chunks that have been added to [con]. *)
val size : t -> int

(** [query n con] is [Some ch] if [n-1] is less than the number of total chunks
    that have been added to [con]. In addition, [ch] is the (n-1)th chunk that
    was added to the container. Otherwise, this function returns [None]. *)
val query : int -> t -> Mixer.Chunk.t option

(** [add ch con] modifies [con] and adds a chunk to it. Adding a chunk to the
    empty container will result in the chunk being at position 0. *)
val add : Mixer.Chunk.t -> t -> unit

(** [add_from_list lst con] adds all the the chunks in [lst] to [con] in the
    order that they appear. This is equivalent to using [add] in sequence. If
    [lst] is the empty list, nothing is added to [con]*)
val add_from_list : Mixer.Chunk.t list -> t -> unit

(** [alternate con] progressively returns the different chunks that were added.
    For example, if [con] contains the chunks [c1,c2,c3], then [alternate con]
    will first return [c1], when applied again it will return [c2], and when
    applied again it will return [c3]. When applied again, it will restart at
    [c1]. Requires: [con] is not empty. *)
val alternate : t -> Mixer.Chunk.t
