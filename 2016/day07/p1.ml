type state = { supported_ips: int;
             }
let starting_state = { supported_ips = 0;
                     }

let abba_regex = Str.regexp ".*\\([a-z]\\)\\([a-z]\\)\\2\\1.*"

let handle_line state line =
  (* only works if there are no nested brackets *)
  let tokens = Str.(split (regexp "[][]") line) in
  let check_abba index token =
    let is_match = Str.string_match abba_regex token 0
                   && Str.matched_group 1 token <> Str.matched_group 2 token
    in
    if index mod 2 = 0
    then begin
      if is_match then 1 else 0 (* match outside brackets is good *)
    end
    else begin
      if is_match then (-99999) else 0 (* cannot have match inside brackets *)
    end
  in
  let checked_abba = List.mapi check_abba tokens in
  let score = List.fold_left (+) 0 checked_abba in
  if score > 0
  then { state with supported_ips = state.supported_ips + 1 }
  else state

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
  print_string "Number of IPs which support TLS: ";
  print_int end_state.supported_ips;
  print_endline ""
