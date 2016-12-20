type state = { decompressed: string;
             }
let starting_state = { decompressed = "";
                     }

let marker_regex = Str.regexp "(\\([0-9]+\\)x\\([0-9]+\\))"

let rec decompress buffer line start =
  try
    let pos = Str.search_forward marker_regex line start in
    Buffer.add_string buffer (String.sub line start (pos - start));
    let len = Str.matched_group 1 line |> int_of_string in
    let repeats = Str.matched_group 2 line |> int_of_string in
    let repeated_string = String.sub line (Str.match_end ()) len in
    for i = 0 to (repeats - 1) do
      Buffer.add_string buffer repeated_string
    done;
    let next = (Str.match_end ()) + len in
    decompress buffer line next
  with
  | Not_found -> begin
      let len = (String.length line) - start in
      Buffer.add_string buffer (String.sub line start len)
    end

let handle_line state line =
  let buffer = Buffer.create (String.length line) in
  decompress buffer line 0;
  { state with decompressed = Buffer.contents buffer }

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
  print_int @@ String.length end_state.decompressed;
  print_endline ""
