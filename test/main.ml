open OUnit2
open Final.Spritesheet
open Final.Textureloader
open Final.Animations
open Final.Fonts
open Sdl
open Final.Vector
open Final.Mixer

(** TESTING PLAN:
    - OUnit tests: We mostly tested functions that had to with I/O operations as
      well as the logic for displaying animations and playing audio. The
      functions in the [Mixer]/[Container] modules were tested only with respect
      to being to properly load audio files. It would've been impossible to test
      that the right effect was being played with OUnit2 tests. Note that the
      testing of this file reading-functionaly was almost entirely glass-box, as
      the code for these modules consisted heavily of wrapping around the more
      complex functionality provided by the [Ocamlsdl2] and [Tsdl_mixer]
      libraries.

    - In addition, we tested the functions in the simple [Vector] module, which
      had only a few functions but for which we could build a more robust
      testing suite. This was done with glass-box testing in mind, as we were
      pretty confident that the implementation was correct.

    - We also tested the back-end logic for animations thoroughly with OUnit
      tests, this was done to ensure that the [Spritesheet] and [Animations]
      modules correctly represented the rows and columns of a given png image
      with multiple animation stages. Note that these tests also provide
      coverage for the [Textureloader] module, which is used to load image. The
      testing for this part of the code was done against the implementation, as
      this provided a guarantee that the logic itself worked properly.

    - We also tested some of the functionality of the [Font] module, such as the
      speed and color of the font using [OUnit2] tests. The testing suite for
      the module consists largely of glass-box tests. As was the case with
      [Mixer]/[Container], this module wrapped around the [sdl2_ttf] library,
      which is what does the heavy lifting.

    - In summary, the following modules were tested using [OUnit2]:
    - Mixer
    - Container
    - Vector
    - Textureloader
    - Fonts
    - Animations

    - All remaining modules, as they largely consisted of direct interaction
      with the player, were manually tested by the team members.

    - We are confident that our testing strategy shows the proper
      function/correctness of the components in the game and game engine we
      built. For instance, we have very thoroughly tested that the features we
      have implemented for I/O and user interaction work as expected, which has
      given us more certainty that our system works as expected. The [OUnit2]
      tests we developed provide even more evidence that our project has the
      right functionality, as they tell us that the way in which we implemented
      much of the logic in the game engine works properly.

    - However, no test suite is perfect. We did find some issues that we believe
      go beyond what we have coded, such as some unexpected behavior that arises
      when using the sdl bindings. For instance, loading certain audio files
      makes the system crash due to a segmentation fault. The code in [Mixer] is
      designed to handle exceptions that are raised by the underlying libraries,
      however, the error that is raised is not an ocaml exception, but some sort
      of system failure.

    - In all, the testing we have done gives us a strong guarantee that our
      system should work under normal circumstances. *)

(* AUDIO INITIALIZATION. *)
let _ = init [ MP3 ]
let _ = open_audio 44100 MIX_DEFAULT_FORMAT 1 2048
let sheet = new_spritesheet "assets/fire.bmp" 2 8 102 153
let assert_file_type str1 str2 _ = assert_equal str1 str2

let assert_file_type_failure str =
  let exn = Failure "Invalid File" in
  fun ctxt ->
    assert_raises ~msg:"Invalid File" exn (fun () ->
        try file_type str with Invalid_argument _ -> raise exn)

let assert_image_format img1 img2 _ = assert_equal img1 img2

let assert_image_format_failure str =
  let exn = Failure "Unsupported Image Format" in
  fun ctxt ->
    assert_raises ~msg:"Unsupported Image Format" exn (fun () ->
        try get_image_format str with Invalid_argument _ -> raise exn)

(** [test_audio name file] asserts that calling
    [Final.Mixer.Chunk.load_wav file] does not raise an exception. It does not
    make sense to compare chunk objects, so we just test that the reading the
    file does not crash. *)
let test_audio_loader name file =
  name >:: fun _ -> assert_equal () (ignore (Final.Mixer.Chunk.load_wav file))

(** [test_audio name file] asserts that calling
    [Final.Mixer.Chunk.load_wav file] on an invalid .wav [file] name raises a
    [Final.Mixer.ReadError] exception. *)
let test_audio_loader_exp name file =
  name >:: fun _ ->
  assert_raises
    (Final.Mixer.ReadError ("Couldn't open " ^ file))
    (fun _ -> Final.Mixer.Chunk.load_wav file)

(** [test_vector name v1 v2] is the [OUnit] test that verifies that the
    components of each vector is the same. *)
let test_vector name v1 v2 =
  name >:: fun _ ->
  assert_equal v1 v2 ~printer:(fun { x; y } ->
      "{" ^ string_of_float x ^ "; " ^ string_of_float y ^ "}")

(** [test_float name x y] is the [OUnit2.test] that verifies that floats [x] and
    [y] are equal up to the margin of error [e], which should ideally be small. *)
let test_float name x y e =
  name >:: fun _ ->
  assert_equal x y ~printer:string_of_float ~cmp:(fun x y ->
      Float.abs (x -. y) < e)

(** [assert_int name x y] is the [OUnit2.test] that verifies that [x=y]. *)
let assert_int name x y =
  name >:: fun _ -> assert_equal x y ~printer:string_of_int

(** [Chunk.t] object used for testing *)
let ch = Final.Mixer.Chunk.load_wav "assets/exterior_fx.wav"

let audio_test =
  [
    test_audio_loader "Loading rain_on_brick" "assets/rain_on_brick.mp3";
    test_audio_loader_exp "Trying to load non-existent file" "nonsense.wav";
    test_audio_loader_exp "Trying to load non-existent file" "hello.wav";
    test_audio_loader "Loading jump sound" "assets/jump.wav";
    test_audio_loader "Loading exterior sound effect" "assets/exterior_fx.wav";
    test_audio_loader_exp "File name exists, but not in the right directory"
      "files/exterior_fx.wav";
  ]

let vector_test =
  [
    test_vector "zero vector" { x = 0.; y = 0. } (zero ());
    test_vector "addition of two zero vectors"
      (add (zero ()) (zero ()))
      (zero ());
    test_vector "adding a vector to the zero vector does not change it"
      (add (zero ()) { x = 4.3; y = 4.9 })
      { x = 4.3; y = 4.9 };
    (let v1 = { x = 0.5; y = 0.5 } in
     scale 2. v1;
     let v2 = { x = 1.0; y = 1.0 } in
     test_vector "scaling vector by 2" v1 v2);
    (let v1 = { x = 1.0; y = 1.0 } in
     scale 1. v1;
     let v2 = { x = 1.0; y = 1.0 } in
     test_vector "scaling vector by 1 doesnt change it" v1 v2);
    (let v1 = { x = 0.5; y = 0.5 } in
     let v2 = { x = -0.5; y = -0.5 } in
     let v3 = add v1 v2 in
     test_vector "subtracting a vector from itself equals the zero vector" v3
       (zero ()));
    (let v = { x = 4.0; y = 4.0 } in
     normalize v;
     test_float
       "the length of a normalized vector should be approximately one. " 1.
       (v |> length))
      0.0001;
    (let v = { x = 2.0; y = 2.0 } in
     normalize v;
     test_float "normalizing vector whose components are 2 " 1. (v |> length))
      0.0001;
    (let v = { x = 1.0; y = 1.0 } in
     test_float
       "vector whose components are both 1 should have sqrt 2 length.  "
       (sqrt 2.) (v |> length) 0.0001);
    (let v = { x = 1.0; y = 0.0 } in
     test_float "length of standard basis vector is 1. " 1. (v |> length) 0.0001);
    (let v = { x = 0.0; y = 0.0 } in
     test_float "length of 0 vector is 0. " 0. (v |> length) 0.0001);
  ]

let container_tests =
  Final.Container.
    [
      assert_int "size of empty container is 0" 0 (empty () |> size);
      (let con = empty () in
       add ch con;
       let size = size con in
       assert_int "size of container with 1 song is 1" 1 size);
      (let con = empty () in
       add ch con;
       ignore (alternate con);
       let size = size con in
       assert_int "calling alternate should not change size" 1 size);
      (let con = empty () in
       add_from_list [ ch; ch; ch ] con;
       let size = size con in
       assert_int "testing using from_list function on non empty list" 3 size);
      (let con = empty () in
       add_from_list [] con;
       let size = size con in
       assert_int "testing using from_list function on empty list" 0 size);
      (let con = empty () in
       add_from_list [ ch; ch; ch ] con;
       add ch con;
       let size = size con in
       assert_int "using list to add to container and directly adding" 4 size);
      (let con = empty () in
       add_from_list [ ch ] con;
       "testing that alternate with one element returns the same element \
        (physical equality)"
       >:: fun _ -> assert_equal ch (alternate con) ~cmp:Stdlib.( == ));
    ]

let file_type_tests =
  [
    "testing file_type on a file with one character before the file type"
    >:: assert_file_type "jpg" (file_type "a.jpg");
    "testing file type on a file with multiple characters before the file type"
    >:: assert_file_type "png" (file_type "assets/asset.png");
    "testing file type on xv file edge case (two letter file type)"
    >:: assert_file_type "xv" (file_type "asset.xv");
    "testing file_type on webp file edge case (four letter file type)"
    >:: assert_file_type "webp" (file_type "asset.webp");
    "testing file_type on a string path with less than three characters"
    >:: assert_file_type_failure ".s";
  ]

let get_image_format_tests =
  [
    "testing image format on png"
    >:: assert_image_format PNG (get_image_format "png");
    "testing image format on jpg"
    >:: assert_image_format JPG (get_image_format "jpg");
    "testing image format on pcx"
    >:: assert_image_format PCX (get_image_format "pcx");
    "testing image format on bmp"
    >:: assert_image_format BMP (get_image_format "bmp");
    "testing image format on ico"
    >:: assert_image_format ICO (get_image_format "ico");
    "testing image format on cur"
    >:: assert_image_format CUR (get_image_format "cur");
    "testing image format on gif"
    >:: assert_image_format GIF (get_image_format "gif");
    "testing image format on lbm"
    >:: assert_image_format LBM (get_image_format "lbm");
    "testing image format on pnm"
    >:: assert_image_format PNM (get_image_format "pnm");
    "testing image format on tif"
    >:: assert_image_format TIF (get_image_format "tif");
    "testing image format on xcf"
    >:: assert_image_format XCF (get_image_format "xcf");
    "testing image format on xpm"
    >:: assert_image_format XPM (get_image_format "xpm");
    "testing image format on xv"
    >:: assert_image_format XV (get_image_format "xv");
    "testing image format on webp"
    >:: assert_image_format WEBP (get_image_format "webp");
    "testing image format on unsupported file type"
    >:: assert_image_format_failure "pdf";
  ]

let new_animation = animation "catrun" 0 0 2 2 3 5

let animation_test =
  [
    ( "testing that the name of the animation was initialized properly"
    >:: fun _ -> assert_equal "catrun" (get_name new_animation) );
    ( "testing that the starting row of the animation was initialized properly"
    >:: fun _ -> assert_equal 0 (get_row_start new_animation) );
    ( "testing that the starting column of the animation was initialized \
       properly"
    >:: fun _ -> assert_equal 0 (get_col_start new_animation) );
    ( "testig that the end column was initialized properly" >:: fun _ ->
      assert_equal 2 (get_col_end new_animation) );
    ( "testing that the number of rows to animate was initialized properly"
    >:: fun _ -> assert_equal 2 (get_rows new_animation) );
    ( "testing that the number of columns to animate was initialized properly"
    >:: fun _ -> assert_equal 3 (get_cols new_animation) );
    ( "testing that the speed to animate at was initialized properly"
    >:: fun _ -> assert_equal 5 (Final.Animations.get_speed new_animation) );
  ]

let () = Sdlttf.init ()

let new_font =
  new_font_object "assets/fantasy.otf" "Hey" 20
    { Sdlttf.r = 255; g = 0; b = 60; a = 240 }

let font_tests =
  [
    ( "testing that a font starts out with no speed" >:: fun _ ->
      assert_equal (None, None) (Final.Fonts.get_speed new_font) );
    ( "testing that font_color, red field is initialized properly" >:: fun _ ->
      assert_equal 255 (get_color new_font).r );
    ( "testing that font_color, green field is initialized properly" >:: fun _ ->
      assert_equal 0 (get_color new_font).g );
    ( "testing that font_color, blue field is initialized properly" >:: fun _ ->
      assert_equal 60 (get_color new_font).b );
    ( "testing that font_color, alpha field is initialized properly" >:: fun _ ->
      assert_equal 240 (get_color new_font).a );
    ( "testing that the text of the font_object was initialized properly"
    >:: fun _ -> assert_equal "Hey" (get_text new_font) );
    ( "testing that the x velocity gets updated with font_speed" >:: fun _ ->
      font_speed (Some 6) None new_font;
      assert_equal (Some 6, None) (Final.Fonts.get_speed new_font) );
    ( "testing that the y velocity gets updated with font_speed" >:: fun _ ->
      font_speed None (Some 8) new_font;
      assert_equal (None, Some 8) (Final.Fonts.get_speed new_font) );
    ( "testing that both the x and y velocity gets updated with font_speed"
    >:: fun _ ->
      font_speed (Some 6) (Some 8) new_font;
      assert_equal (Some 6, Some 8) (Final.Fonts.get_speed new_font) );
  ]

let test_suite =
  "Test suite for spritesheet, animation, font, and audio functions. "
  >::: List.flatten
         [
           file_type_tests;
           get_image_format_tests;
           animation_test;
           font_tests;
           vector_test;
           audio_test;
           container_tests;
         ]

let () = run_test_tt_main test_suite
