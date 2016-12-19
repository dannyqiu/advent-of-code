type state = { password: string
             }
let starting_state = { password = "";
                     }

let zero_regex = Str.regexp "00000"

let handle_line state line =
  let pass = ref "" in
  let index = ref 0 in
  while String.length !pass < 8 do
    let to_hash = line ^ (string_of_int !index) in
    let md5 = to_hash |> Digest.string |> Digest.to_hex in
    if Str.string_match zero_regex md5 0
    then pass := !pass ^ (String.sub md5 5 1)
    else ();
    incr index
  done;
  { state with password = !pass }


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
  print_string "Password: ";
  print_string end_state.password;
  print_endline ""
