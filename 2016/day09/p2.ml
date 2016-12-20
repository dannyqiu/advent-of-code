type state = { length: int;
             }
let starting_state = { length = 0;
                     }

let marker_regex = Str.regexp "(\\([0-9]+\\)x\\([0-9]+\\))"

let rec decompress line start total_len =
  try
    let pos = Str.search_forward marker_regex line start in
    let no_markers_len = pos - start in
    let repeats = Str.matched_group 2 line |> int_of_string in
    let len = Str.matched_group 1 line |> int_of_string in
    let repeated_string = String.sub line (Str.match_end ()) len in
    let next = (Str.match_end ()) + len in
    let repeated_len = repeats * (decompress repeated_string 0 0) in
    decompress line next (total_len + no_markers_len + repeated_len)
  with
  | Not_found -> total_len + (String.length line) - start

let handle_line state line =
  let total_len = decompress line 0 0 in
  { state with length = total_len }

let rec handle_input state lines =
  match lines with
  | line::t -> begin
      let new_state = handle_line state line in
      handle_input new_state t
    end
  | _ -> state

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
  print_string "Decompressed Length: ";
  print_int end_state.length;
  print_endline ""
