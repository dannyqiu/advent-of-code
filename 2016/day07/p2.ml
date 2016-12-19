module StringSet = Set.Make(String)

type state = { supported_ips: int;
             }
let starting_state = { supported_ips = 0;
                     }

let aba_regex = Str.regexp "\\([a-z]\\)[a-z]\\1"

let is_valid_match aba =
  String.length aba = 3
  && String.get aba 0 <> String.get aba 1
  && String.get aba 0 = String.get aba 2

let add_match set is_brackets aba =
  if is_valid_match aba
  then begin
    let aba = (
      if is_brackets
      then (String.sub aba 1 1) ^ (String.sub aba 0 1) ^ (String.sub aba 1 1)
      else aba
    ) in
    StringSet.add aba set
  end
  else set

let rec get_matches set is_brackets line start =
  try
    let pos = Str.search_forward aba_regex line start in
    let aba = Str.matched_string line in
    let new_set = add_match set is_brackets aba in
    get_matches new_set is_brackets line (pos + 1)
  with
  | Not_found -> set

let handle_line state line =
  (* only works if there are no nested bracked *)
  let tokens = Str.(split (regexp "[][]") line) in
  let supernet_set = ref StringSet.empty in (* no brackets *)
  let hypernet_set = ref StringSet.empty in (* has brackets *)
  let check_aba index token =
    if index mod 2 = 0
    then supernet_set := get_matches !supernet_set false token 0
    else hypernet_set := get_matches !hypernet_set true token 0
  in
  List.iteri check_aba tokens;
  if StringSet.inter !supernet_set !hypernet_set |> StringSet.is_empty
  then state
  else { state with supported_ips = state.supported_ips + 1 }

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
  print_string "Number of IPs which support SSL: ";
  print_int end_state.supported_ips;
  print_endline ""
