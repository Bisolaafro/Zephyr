open OUnit2
open Final.Spritesheet

(* Define a type for the spritesheet *)

(* Define a function that creates a new spritesheet *)
let sheet = new_spritesheet "assets/fire.bmp" 2 8 102 153
let update_player_state_tests = []

(* Define a list of all the test cases *)
let suite =
  "Test suite for spritesheet functions"
  >::: List.flatten [ update_player_state_tests ]

(* Define a main function that runs the test suite *)
let () = run_test_tt_main suite
