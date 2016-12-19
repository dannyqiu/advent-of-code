let swide = 50
let stall = 6

type state = { pixels_lit: int;
               display: int array array;
             }
let starting_state = { pixels_lit = 0;
                       display = Array.make_matrix stall swide 0;
                     }

let rect_regex = Str.regexp "\\([0-9]+\\)x\\([0-9]\\)"
let rotate_row_regex = Str.regexp "y=\\([0-9]+\\) by \\([0-9]+\\)"
let rotate_column_regex = Str.regexp "x=\\([0-9]+\\) by \\([0-9]+\\)"

let print_display display =
  let print_pixel pixel = print_string @@ if pixel = 0 then "." else "#" in
  let print_pixel_row row = Array.iter print_pixel row; print_endline "" in
  print_endline "";
  Array.iter print_pixel_row display

let handle_rect state args =
  if Str.string_match rect_regex args 0
  then begin
    let wide = int_of_string (Str.matched_group 1 args) in
    let tall = int_of_string (Str.matched_group 2 args) in
    for t = 0 to (tall - 1) do
      for w = 0 to (wide - 1) do
        state.display.(t).(w) <- 1
      done
    done;
    state
  end
  else failwith @@ "Invalid arguments to rect: " ^ args

let handle_rotate_row state args =
  if Str.string_match rotate_row_regex args 0
  then begin
    let row = int_of_string (Str.matched_group 1 args) in
    let amt = int_of_string (Str.matched_group 2 args) mod swide in
    let saved = Array.make amt 666 in
    (* save pixels that will be overwritten *)
    for i = (swide - 1) downto (swide - amt) do
      saved.(i - (swide - amt)) <- state.display.(row).(i)
    done;
    for w = (swide - 1) downto amt do
      state.display.(row).(w) <- state.display.(row).(w - amt)
    done;
    (* restore overwritten pixels *)
    for w = 0 to (amt - 1) do
      state.display.(row).(w) <- saved.(w)
    done;
    state
  end
  else failwith @@ "Invalid arguments to rotate row: " ^ args

let handle_rotate_column state args =
  if Str.string_match rotate_column_regex args 0
  then begin
    let col = int_of_string (Str.matched_group 1 args) in
    let amt = int_of_string (Str.matched_group 2 args) mod stall in
    let saved = Array.make amt 666 in
    (* save pixels that will be overwritten *)
    for i = (stall - 1) downto (stall - amt) do
      saved.(i - (stall - amt)) <- state.display.(i).(col)
    done;
    for t = (stall - 1) downto amt do
      state.display.(t).(col) <- state.display.(t - amt).(col)
    done;
    (* restore overwritten pixels *)
    for t = 0 to (amt - 1) do
      state.display.(t).(col) <- saved.(t)
    done;
    state
  end
  else failwith @@ "Invalid arguments to rotate column: " ^ args

let handle_rotate state line =
  let space = String.index line ' ' in
  let args = String.sub line (space + 1) (String.length line - space - 1) in
  match String.sub line 0 space with
  | "row" -> handle_rotate_row state args
  | "column" -> handle_rotate_column state args
  | c -> failwith @@ "Invalid rotate command: " ^ c

let handle_line state line =
  let space = String.index line ' ' in
  let args = String.sub line (space + 1) (String.length line - space - 1) in
  match String.sub line 0 space with
  | "rect" -> handle_rect state args
  | "rotate" -> handle_rotate state args
  | c -> failwith @@ "Invalid command: " ^ c

let count_lit_pixels display =
  Array.fold_left (fun sum arr -> Array.fold_left (+) sum arr) 0 display

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> { state with pixels_lit = count_lit_pixels state.display }

let rec get_all_input buffer =
  try
    let line = input_line stdin in
    if String.length line = 0
    then buffer
    else get_all_input (line::buffer)
  with
  | End_of_file -> List.rev buffer

let _ =
  let end_state = get_all_input [] |> handle_input starting_state in
  print_string "Number of pixels lit: ";
  print_int end_state.pixels_lit;
  print_display end_state.display;
