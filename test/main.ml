open OUnit2
open Final.Spritesheet
open Final.Textureloader
open Final.Animations
open Final.Fonts
open Sdl

(** TODO: WRITE A TEST PLAN -4: The test plan is missing. -1: The test plan does
    not explain which parts of the system were automatically tested by OUnit vs.
    manually tested. -1: The test plan does not explain what modules were tested
    by OUnit and how test cases were developed (black box, glass box,
    randomized, etc.). -1: The test plan does not provide an argument for why
    the testing approach demonstrates the correctness of the system*)

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
  new_font_object "assets/FANTASY MAGIST.otf" "Hey" 20
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
  "Test suite for spritesheet, animation, and font functions"
  >::: List.flatten
         [ file_type_tests; get_image_format_tests; animation_test; font_tests ]

let () = run_test_tt_main test_suite
