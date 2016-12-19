module StringMap = Map.Make(String)

type state = { real_rooms: int list;
             }
let starting_state = { real_rooms = [];
                     }

let explode_letters = Str.split (Str.regexp "")

let parse_info info =
  let bracket = String.index info '[' in
  let sector_id = String.sub info 0 bracket |> int_of_string in
  let checksum = String.sub info (bracket + 1) (String.length info - bracket - 2)
                 |> explode_letters in
  (sector_id, checksum)

let parse_data start_count data =
  let letters = explode_letters data in
  let incr_count count l =
    try
      let c = StringMap.find l count in
      count |> StringMap.remove l |> StringMap.add l (c + 1)
    with
    | Not_found -> StringMap.add l 1 count
  in
  List.fold_left incr_count start_count letters

let get_checksum count =
  let comparator a b =
    if snd a <> snd b
    then -(Pervasives.compare (snd a) (snd b))
    else Pervasives.compare (fst a) (fst b)
  in
  count |> StringMap.bindings
        |> List.sort comparator
        |> List.split
        |> fst

let verify_checksum checksum count =
  match get_checksum count with
  | l1::l2::l3::l4::l5::t -> checksum = [l1;l2;l3;l4;l5]
  | _ -> false

let handle_line state line =
  let tokens = Str.(split (regexp "-") line) in
  let rec handle_tokens count = function
    | [info] -> begin
        let (sector_id, checksum) = parse_info info in
        if verify_checksum checksum count
        then { state with real_rooms = sector_id::state.real_rooms }
        else state
      end
    | data::t -> begin
        let new_count = parse_data count data in
        handle_tokens new_count t
      end
    | [] -> failwith "Empty line"
  in
  handle_tokens StringMap.empty tokens

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
  print_string "Sum of sector IDs of real rooms: ";
  print_int (List.fold_left (+) 0 end_state.real_rooms);
  print_endline ""
