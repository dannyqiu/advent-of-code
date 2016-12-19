type state = { north_pole_room: int list;
             }
let starting_state = { north_pole_room = [];
                     }

let explode_letters = Str.split (Str.regexp "")

let parse_info info =
  let bracket = String.index info '[' in
  let sector_id = String.sub info 0 bracket |> int_of_string in
  let checksum = String.sub info (bracket + 1) (String.length info - bracket - 2)
                 |> explode_letters in
  (sector_id, checksum)

let decrypt cipher key =
  let code_a = Char.code 'a' in
  let convert c =
    if c = ' '
    then ' '
    else Char.chr (((Char.code c - code_a + key) mod 26) + code_a)
  in
  String.map convert cipher

let handle_line state line =
  let tokens = Str.(split (regexp "-") line) in
  let rec handle_tokens cipher = function
    | [info] -> begin
        let (sector_id, checksum) = parse_info info in
        let decrypted = decrypt cipher sector_id in
        if Str.string_match (Str.regexp ".*north") decrypted 0
           || Str.string_match (Str.regexp ".*pole") decrypted 0
        then { state with north_pole_room = sector_id::state.north_pole_room }
        else state
      end
    | data::t -> handle_tokens (cipher ^ data ^ " ") t
    | [] -> failwith "Empty line"
  in
  handle_tokens "" tokens

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

let combine_rooms a b = a ^ (string_of_int b) ^ ", "

let _ =
  let end_state = get_all_input [] |> handle_input starting_state in
  print_string "Sector ID(s) of North Pole objects: ";
  print_string (List.fold_left combine_rooms "" end_state.north_pole_room);
  print_endline ""
