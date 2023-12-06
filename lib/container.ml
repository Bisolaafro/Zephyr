(* utilized implementation of array lists from lab7 *)

type t = {
  mutable data : Mixer.Chunk.t option array;
  mutable size : int;
  mutable alter : int;
}

let empty () = { data = Array.make 10 None; size = 0; alter = 0 }
let size { size } = size

let query n con =
  match n >= 0 && n <= con.size - 1 with
  | true -> con.data.(n)
  | _ -> None

let add elt al =
  let _ =
    match al.size with
    | x when Array.length al.data = x ->
        let dest = Array.make (2 * x) None in
        let _ = Array.blit al.data 0 dest 0 x in
        let _ = al.data <- dest in
        Array.set dest x (Some elt)
    | _ -> Array.set al.data al.size (Some elt)
  in
  al.size <- 1 + al.size

let rec add_from_list lst con =
  match lst with
  | [] -> ()
  | h :: t ->
      let _ = add h con in
      add_from_list t con

let alternate con =
  let curr = con.alter in
  let _ = con.alter <- (con.alter + 1) mod con.size in
  con.data.(curr) |> Option.get
